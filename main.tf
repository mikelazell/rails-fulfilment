terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"

  backend "s3" {
    bucket         = "s3-tfstate-core-euwest2"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "core-terraform-state"
    encrypt        = true
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

####

################################################


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs                          = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  private_subnets              = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets               = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets             = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]
  enable_nat_gateway           = true
  enable_vpn_gateway           = false
  create_database_subnet_group = true
  database_subnet_group_name   = var.db_subnet_name
  single_nat_gateway           = true

  tags = {
    Terraform   = "true"
    Environment = var.environment_name
  }
}


resource "aws_security_group" "app_db_security_group" {
  name        = var.security_group_name
  description = var.security_group_name
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment_name
  }
}

resource "aws_db_instance" "rails_database" {
  allocated_storage            = 20
  engine                       = "postgres"
  engine_version               = "12.8"
  instance_class               = var.db_size
  name                         = var.database_name
  identifier                   = var.database_name
  username                     = var.db_user
  password                     = var.db_password
  parameter_group_name         = "default.postgres12"
  skip_final_snapshot          = true
  availability_zone            = var.db_availability_zone
  db_subnet_group_name         = module.vpc.database_subnet_group_name
  performance_insights_enabled = false
  vpc_security_group_ids       = [aws_security_group.app_db_security_group.id]


  tags = {
    Terraform   = "true"
    Environment = var.environment_name
  }
}

resource "aws_elastic_beanstalk_application" "tfrailsapp" {
  name = var.rails_app_name

  tags = {
    Terraform = "true"
    Environment = var.environment_name
  }
}

resource "aws_elastic_beanstalk_environment" "beanstalkappenv" {
  name                = var.environment_name
  application         = aws_elastic_beanstalk_application.tfrailsapp.name
  solution_stack_name = var.rails_app_eb_stack
  tier                = "WebServer"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = module.vpc.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "DBSubnets"
    value     = join(",", module.vpc.private_subnets)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "True"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", module.vpc.public_subnets)
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.app_db_security_group.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance "
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 1
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT"
    value     = "80"
  }


  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SECRET_KEY_BASE"
    value     = var.rails_app_secret_key_base
  }


  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATABASE_URL"
    value     = format("%s%s%s%s%s%s/%s", "postgres://", var.db_user, ":", var.db_password, "@", aws_db_instance.rails_database.address, var.database_name)
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment_name
  }
}


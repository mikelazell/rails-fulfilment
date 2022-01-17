
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
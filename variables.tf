variable "environment_name" {
  description = "Name of the environment"
  type        = string
  default     = "development"
}

variable "db_subnet_name" {
  description = "Name of the postgres DB subnet"
  type        = string
  default     = "dbsn-fulfilment-dev-euwest2"
}

variable "security_group_name" {
  description = "Name of the security group that ties elastic beanstalk and RDS together"
  type        = string
  default     = "sgfulfilment-dev-euwest2"
}

variable "vpc_name" {
  description = "Name of the VPC used for fulfilment app"
  type        = string
  default     = "vpc-fulfilment-dev-euwest2"
}

variable "database_name" {
  description = "Name of the database the rails app uses"
  type        = string
  default     = "tfdatabasename"
  #cannot use default naming strategy above due to AWS DB naming rules (no hyphens)
}

variable "db_size" {
  description = "The size of the rails DB"
  type        = string
  default     = "db.t2.micro"
}

variable "db_user" {
  description = "The username of the rails DB"
  type        = string
  default     = "fulfilmentuser"
}

variable "db_password" {
  description = "The password of the rails DB"
  type        = string
  default     = "DBPASSWORD"
}

variable "db_availability_zone" {
  description = "The default availability zone of rails DB"
  type        = string
  default     = "eu-west-2a"
}

variable "rails_app_name" {
  description = "The name of the app rails app"
  type        = string
  default     = "eb-fulfilment-dev-euwest2"
}

variable "rails_app_eb_stack" {
  description = "The name of stack to run on elastic beanstalk"
  type        = string
  default     = "64bit Amazon Linux 2 v3.4.1 running Ruby 3.0"
}

variable "rails_app_secret_key_base" {
  description = "The secret_key_base_to_use_on_rails"
  type        = string
  default     = "SECRETKEYBASE"
}
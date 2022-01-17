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


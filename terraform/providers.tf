terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.16.0"
    }
  }

  backend "s3" {
    bucket = "terraform-class-13"
    key    = "terraform_state_file/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

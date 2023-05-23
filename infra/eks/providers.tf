terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.47.0"
    }
  }

  required_version = "~> 1.3"
}

provider "aws" {
    version = "4.47.0"
    region = var.AWS_REGION
    shared_credentials_files = var.AWS_AUTH_FILE
    profile = var.AWS_AUTH_FILE  
}
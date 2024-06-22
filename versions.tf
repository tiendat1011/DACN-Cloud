terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "ap-southeast-2"
}

terraform {
  backend "s3" {
    bucket = "bucketdacn"
    key    = "state/terraform.tfstate"  
    region = "ap-southeast-2"  
  }
}
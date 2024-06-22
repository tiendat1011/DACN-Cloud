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
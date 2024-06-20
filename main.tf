provider "aws" {
  region     = "ap-southeast-2"
}

locals {
  access_key = file("./accesskey")
  secret_key = file("./secretkey")
}

output "stronggokey" {
  value = local.access_key
}

output "khoedidikey" {
  value = local.secret_key
}

module "vpc" {
  source = "./modules/vpc"
  access_key = local.access_key
  secret_key = local.secret_key
  vpc_cidr   = "10.0.0.0/16"
}

module "ec2" {
  source = "./modules/ec2"
  access_key = local.access_key
  secret_key = local.secret_key
  vpc_id     = module.vpc.aws_vpc_id
  subnet_1_id = module.vpc.subnet_1_id
  subnet_2_id = module.vpc.subnet_2_id
  ami         = "ami-076fe60835f136dc9"
  instance_type = "t2.micro"
  key_name      = "aws-key"  
  public_key_path = file("./ed25519.pub")
}

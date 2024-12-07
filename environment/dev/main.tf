data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_key_pair" "eks_keypair" {
  key_name   = "eks-ed25519-key"
  public_key = file("./ed25519.pub")
}

# Create a VPC
module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr                = var.vpc_cidr
  public_subnet_block     = var.public_subnet_block
  private_subnet_block    = var.private_subnet_block
  map_public_ip_on_launch = var.map_public_ip_on_launch
  azs                     = length(data.aws_availability_zones.azs) > var.az_count ? slice(data.aws_availability_zones.azs, 0, var.az_count) : data.aws_availability_zones.azs
}

module "internet_gateway" {
  source = "../../modules/internet_gateway"

  vpc_id = module.vpc.vpc_id
}

module "nat_gateway" {
  source = "../../modules/nat_gateway"

  public_subnet_ids = module.vpc.public_subnet_ids
}

module "route_table" {
  source = "../../modules/route_table"

  vpc_id = module.vpc.vpc_id
  igw_id = module.internet_gateway.igw_id
  nat_gw_id = module.nat_gateway.nat_gateway_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "default_private_security_group" {
  source = "../../modules/security_group"

  name_sg = var.default_private_name_sg
  description_sg = var.default_private_description_sg
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "SSH from user IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = []
      security_groups = [module.default_public_security_group.security_group_id]
    },
  ]

  egress_rules = [
    {
      description = "Allow all outbound traffics"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "default_public_security_group" {
  source = "../../modules/security_group"

  name_sg = var.default_public_name_sg 
  description_sg = var.default_public_description_sg
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      description = "SSH from public instances"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.ssh_ips
      security_groups = []
    },
    {
      description = "HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      security_groups = []
    },
    {
      description = "HTTPS from anywhere"
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      security_groups = []
    }
  ]
  egress_rules = [
    {
      description = "Allow all outbound traffics"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# Create EKS Cluster and Node group
module "eks" {
  source            = "../../modules/eks"
  cluster_name      = "my-cluster"
  subnet_1_id       = module.vpc.subnet_1_id
  subnet_2_id       = module.vpc.subnet_2_id
  key_name          = aws_key_pair.eks_keypair.key_name
  security_group_id = module.vpc.security_group_id

  depends_on = [module.vpc]
}

# Create records with Route53
module "route53" {
  source = "../../modules/route53"
}
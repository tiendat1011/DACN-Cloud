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
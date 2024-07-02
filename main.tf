resource "aws_key_pair" "eks_keypair" {
  key_name   = "eks-ed25519-key"
  public_key = file("./ed25519.pub")
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr   = "10.0.0.0/16"
}

module "eks" {
  source = "./modules/eks"
  cluster_name = "my-cluster"
  subnet_1_id = module.vpc.subnet_1_id
  subnet_2_id = module.vpc.subnet_2_id
  key_name = aws_key_pair.eks_keypair.key_name
  security_group_id = module.vpc.security_group_id
}

module "rotue53" {
  source ="./modules/route53"
}
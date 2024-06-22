resource "aws_key_pair" "eks_keypair" {
  key_name   = "eks-ed25519-key"
  public_key = file("./ed25519.pub")
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr   = "10.0.0.0/16"
}

# module "ec2" {
#   source = "./modules/ec2"
#   vpc_id     = module.vpc.aws_vpc_id
#   subnet_1_id = module.vpc.subnet_1_id
#   subnet_2_id = module.vpc.subnet_2_id
#   ami         = "ami-076fe60835f136dc9"
#   instance_type = "t2.micro"
#   key_name      = "aws-key"  
#   public_key_path = file("./ed25519.pub")
# }

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster"
  cluster_version = "1.21"
  subnets         = [module.vpc.subnet_1_id, module.vpc.subnet_2_id]
  vpc_id          = module.vpc.aws_vpc_id

  node_groups = {
    frontend_nodes = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

      instance_type = "t2.micro"
      key_name      = aws_key_pair.eks_keypair.key_name  # Tên của key pair cho SSH
    }

    backend_nodes = {
      desired_capacity = 1
      max_capacity     = 2
      min_capacity     = 1

      instance_type = "t2.micro"
      key_name      = aws_key_pair.eks_keypair.key_name  # Tên của key pair cho SSH
    }
  }

  tags = {
    Environment = "test"
    Terraform   = "true"
  }
}

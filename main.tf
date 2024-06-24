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

# module "eks" {
#   source          = "terraform-aws-modules/eks/aws"
#   cluster_name    = "my-cluster"
#   cluster_version = "1.30"
#   subnet_ids         = [module.vpc.subnet_1_id, module.vpc.subnet_2_id]
#   vpc_id          = module.vpc.aws_vpc_id
#   cluster_endpoint_public_access  = true

#   enable_cluster_creator_admin_permissions = true

#   enable_efa_support = true

#   cluster_addons = {
#     coredns = {
#       most_recent = true
#     }
#     kube-proxy = {
#       most_recent = true
#     }
#     vpc-cni = {
#       most_recent    = true
#       before_compute = true
#       configuration_values = jsonencode({
#         env = {
#           ENABLE_PREFIX_DELEGATION = "true"
#           WARM_PREFIX_TARGET       = "1"
#         }
#       })
#     }
#   }

#   eks_managed_node_groups = {
#     frontend_nodes = {
#       desired_capacity = 1
#       max_capacity     = 2
#       min_capacity     = 1

#       instance_type = "t2.micro"
#       key_name      = aws_key_pair.eks_keypair.key_name  # Tên của key pair cho SSH
#     }

#     backend_nodes = {
#       desired_capacity = 1
#       max_capacity     = 2
#       min_capacity     = 1

#       instance_type = "t2.micro"
#       key_name      = aws_key_pair.eks_keypair.key_name  # Tên của key pair cho SSH
#     }
#   }

#   tags = {
#     Environment = "test"
#     Terraform   = "true"
#   }
# }

module "eks" {
  source = "./modules/eks"
  cluster_name = "my-cluster"
  key_name = aws_key_pair.eks_keypair.key_name
  security_group_id = module.vpc.security_group_id
}
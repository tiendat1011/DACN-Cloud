variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_block" {
  type = list(string)
  description = "The list of public subnets CIDR block"
}

variable "map_public_ip_on_launch" {
  type = bool
  description = "Allow instances launched into subnet is public"
}

variable "private_subnet_block" {
  type = list(string)
  description = "The list of private subnets CIDR block"
}

variable "azs" {
  type = list(string)
  description = "The available zones of subnet"
}



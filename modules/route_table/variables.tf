variable "vpc_id" {
  type = string
  description = "The ID of VPC"
}

variable "igw_id" {
  type = string
  description = "value"
}

variable "nat_gw_id" {
  type = string
  description = "The ID of NAT Gateway"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "value"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "value"
}
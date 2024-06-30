variable cluster_name {
    description = "Cluster name"
    type = string
}

variable "subnet_1_id" {
    description = "Subnet 1 ID"
    type = string
    default = "10.0.1.0/24"
}

variable "subnet_2_id" {
    description = "Subnet 2 ID"
    type = string
    default = "10.0.2.0/24"
}

variable "key_name" {
    description = "Key name for SSH"
    type = string
}

variable "security_group_id" {
    description = "Security groups ID"
}

# variable "vpc_id" {
#   description = "The VPC ID"
#   type        = string
# }
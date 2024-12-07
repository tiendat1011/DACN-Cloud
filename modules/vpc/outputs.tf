output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value = aws_subnet.private[*].id
}

# output "aws_vpc_id" {
#   description = "VPC"
#   value = aws_vpc.main.id
# }

# output "subnet_1_id" {
#   description = "Subnet 1"
#   value = aws_subnet.subnet_1.id
# }

# output "subnet_2_id" {
#   description = "Subnet 2"
#   value = aws_subnet.subnet_2.id
# }

# output "security_group_id" {
#   description = "Security groups ID"
#   value = [aws_security_group.allow_all.id]
# }

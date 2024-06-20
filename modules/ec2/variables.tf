variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "subnet_1_id" {
  description = "The Subnet 1 ID"
  type        = string
}

variable "subnet_2_id" {
  description = "The Subnet 2 ID"
  type        = string
}

variable "ami" {
  description = "The AMI ID for the instances"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" 
}

variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key name for the instances"
  type        = string
}

variable "public_key_path" {
  description = "The path to the public key file"
  type        = string
}

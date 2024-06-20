variable "access_key" {
  description = "The access key for AWS"
  type        = string
}

variable "secret_key" {
  description = "The secret key for AWS"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

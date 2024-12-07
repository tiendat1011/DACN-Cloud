variable "name_sg" {
  type = string
  description = "The name of security group"
}

variable "description_sg" {
  type = string
  description = "The description of security"
}

variable "vpc_id" {
  type = string
  description = "The ID of VPC"
}

variable "ingress_rules" {
  description = "List of ingress rules for security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    security_groups = list(string)
  }))
  default = [
    {
      cidr_blocks = []
      security_groups = []
    }
  ]
}

variable "egress_rules" {
  description = "Lists of egress rules for security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [ {
      cidr_blocks = []
    } 
  ]
}
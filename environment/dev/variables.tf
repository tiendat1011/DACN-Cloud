variable "vpc_cidr" {
  type        = string
  description = "value"
  default     = "10.0.0.0/16"
}

variable "public_subnet_block" {
  type        = list(string)
  description = "value"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_block" {
  type        = list(string)
  description = "value"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = ""
  default     = true
}

variable "az_count" {
  type        = number
  description = "Selected number of available zone"
  default     = 2
}

variable "default_public_name_sg" {
  type = string
  description = "Name of default public instances security group"
  default = "public_sg"
}

variable "default_public_description_sg" {
  type = string
  description = "Description of default public security group"
  default = "Basic rules of public instances such as allow tls, http, ssh"
}

variable "default_private_name_sg" {
  type = string
  description = "Name of default private instances security group"
  default = "private_sg"
}

variable "default_private_description_sg" {
  type = string
  description = "Description of default public security group"
  default = "Basic rules of private instances such as allow tls, http, ssh"
}

variable "ssh_ips" {
  type = list(string)
  description = "IP Address that allow to access instance"
  default = [ "0.0.0.0/32" ]
}
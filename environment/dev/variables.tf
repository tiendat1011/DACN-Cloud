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
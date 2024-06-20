variable "access_key"  {
  description = "The access key for AWS"
  type        = string
  default = file("./accesskey")
}

variable "secret_key" {
  description = "The secret key for AWS"
  type        = string
  default = file("./secretkey")
}


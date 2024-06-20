variable "access_key"  {
  description = "The access key for AWS"
  type        = string
  default = local.access_key
}

variable "secret_key" {
  description = "The secret key for AWS"
  type        = string
  default = local.secret_key
}
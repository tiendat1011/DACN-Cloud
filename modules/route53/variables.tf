variable "hosted_zone_name" {
    description = "Name of hosted zone"
    type = string
    default = "tuilaphu.id.vn"
}

variable "is_destroy" {
    description = "Resources is destroy or not"
    type = bool
    default = false
}
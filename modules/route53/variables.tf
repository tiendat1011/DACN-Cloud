variable "lb_tags" {
  description = "Tags to identify the Load Balancer"
  type        = map(string)
  default     = {
    kubernetes.io/cluster/my-cluster = "owned"
    kubernetes.io/service-name    = "ingress-nginx/ingress-nginx-controller"
  }
}

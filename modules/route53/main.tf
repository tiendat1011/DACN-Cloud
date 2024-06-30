data "aws_route53_zone" "selected" {
    name = var.hosted_zone_name
}

data "aws_lbs" "nginx_lb" {
  tags = {
   "kubernetes.io/cluster/my-cluster" = "owned"
   "kubernetes.io/service-name"    = "ingress-nginx/ingress-nginx-controller"
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.hosted_zone_name
  type    = "A"

  alias {
    name                   = data.aws_lbs.nginx_lb.dns_name
    zone_id                = data.aws_lbs.nginx_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "backend" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "api.tuilaphu.id.vn"
  type    = "A"

  alias {
    name                   = data.aws_lbs.nginx_lb.dns_name
    zone_id                = data.aws_lbs.nginx_lb.zone_id
    evaluate_target_health = true
  }
}
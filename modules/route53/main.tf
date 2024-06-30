data "aws_route53_zone" "selected" {
    name = var.hosted_zone_name
}

data "aws_lbs" "nginx_arn" {
  tags = {
   "kubernetes.io/cluster/my-cluster" = "owned"
   "kubernetes.io/service-name"    = "ingress-nginx/ingress-nginx-controller"
  }
}

data "aws_lb" "nginx_lb" {
    arn = tolist(data.aws_lbs.nginx_arn.arns)[0]
}

resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.hosted_zone_name
  type    = "A"

  alias {
    name                   = data.aws_lb.nginx_lb.dns_name
    zone_id                = data.aws_lb.nginx_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "backend" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "api.tuilaphu.id.vn"
  type    = "A"

  alias {
    name                   = data.aws_lb.nginx_lb.dns_name
    zone_id                = data.aws_lb.nginx_lb.zone_id
    evaluate_target_health = true
  }
}
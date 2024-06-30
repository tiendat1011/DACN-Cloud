data "aws_route53_zone" "selected" {
    name = var.hosted_zone_name
}

data "aws_lb" "nginx_lb" {
  name = "ingress-nginx-controller"
}

resource "aws_route53_zone" "primary" {
  name = var.hosted_zone_name
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
    name                   = var.dns_name
    zone_id                = var.zone_id
    evaluate_target_health = true
  }
}
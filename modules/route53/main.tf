data "aws_route53_zone" "selected" {
    name = var.hosted_zone_name
}

data "aws_lb" "nginx_lb" {
  filter {
    name   = "tag:kubernetes.io/cluster/my-cluster"
    values = [var.lb_tags["kubernetes.io/cluster/my-cluster"]]
  }

  filter {
    name   = "tag:kubernetes.io/service-name"
    values = [var.lb_tags["ingress-nginx/ingress-nginx-controller"]]
  }
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
    name                   = data.aws_lb.nginx_lb.dns_name
    zone_id                = data.aws_lb.nginx_lb.zone_id
    evaluate_target_health = true
  }
}
data "aws_vpc" "vpc" {
  filter {
    name = "cidr"
    values = ["10.0.0.0/16"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name = "tag:Name"
    values = ["${local.project}-project-public*"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name = "tag:Name"
    values = ["${local.project}-project-private*"]
  }
}

data "aws_subnet" "private-subnet-1" {
  filter {
    name = "cidr"
    values = ["${var.cidr_base}10.0/24"]
  }
}

data "aws_subnet" "private-subnet-2" {
 filter {
    name = "cidr"
    values = ["${var.cidr_base}11.0/24"]
  }
}

data "aws_acm_certificate" "ssl_cert" {
  domain      = "*.${var.zone_name}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "zone_name" {
  name         = var.zone_name
  private_zone = false
}

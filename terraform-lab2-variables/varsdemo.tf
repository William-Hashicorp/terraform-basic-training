terraform {
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.70.0"
    }
  }
}

provider "tencentcloud" {
  region = "ap-singapore"
}

resource "tencentcloud_security_group" "var_demo" {
  name = "williamy-variables"

  tags = {
    "department" = "hashicorp"
  }
}


resource "tencentcloud_security_group_rule" "allow_dns" {

  security_group_id = tencentcloud_security_group.var_demo.id
  type              = "ingress"
  policy            = "ACCEPT"
  port_range        = "53"
  ip_protocol       = "tcp"
  cidr_ip           = var.vpn_ip
}

resource "tencentcloud_security_group_rule" "allow_http" {

  security_group_id = tencentcloud_security_group.var_demo.id
  type              = "ingress"
  policy            = "ACCEPT"
  port_range        = "80"
  ip_protocol       = "tcp"
  cidr_ip           = var.vpn_ip
}

resource "tencentcloud_security_group_rule" "allow_https" {

  security_group_id = tencentcloud_security_group.var_demo.id
  type              = "ingress"
  policy            = "ACCEPT"
  port_range        = "443"
  ip_protocol       = "tcp"
  cidr_ip           = var.vpn_ip
}
provider "aws" {
  region     = "ap-southeast-1"
}

data "aws_ami" "app_ami" {
  most_recent = true
  owners = ["amazon"]
  # owners = ["self"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "instance-1" {
    ami = data.aws_ami.app_ami.id
   instance_type = "t2.micro"
}

# terraform {
#   required_providers {
#     tencentcloud = {
#       source  = "tencentcloudstack/tencentcloud"
#       version = ">= 1.70.0"
#     }
#   }
# }

# provider "tencentcloud" {
#   region = var.region
# }

# # image id list
# # https://console.cloud.tencent.com/cvm/image/index?rid=9&tab=PUBLIC_IMAGE&imageType=PUBLIC_IMAGE

# data "tencentcloud_images" "ubuntu" {
#   image_type = ["PUBLIC_IMAGE"]
#   image_name_regex  = "^Ubuntu Server 20.*64"
#   # os_name    = "ubuntu"
# }

# resource "tencentcloud_instance" "wy-datasource" {
#   instance_name   = "wy-datasource"
#   image_id        = data.tencentcloud_images.ubuntu.images.0.image_id
#   # instace type
#   # https://intl.cloud.tencent.com/document/product/213/11518
#   instance_type   = "S1.MEDIUM4"
# }

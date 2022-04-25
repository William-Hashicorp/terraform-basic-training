# # Terraform provider, define it will talk to aws
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 3.64.0"
#         }
#   }
# }

# tencent cloud provider doc
# https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs
# https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources
# TCC regions and AZ
# https://intl.cloud.tencent.com/document/product/213/6091
# TCC instance type
# https://intl.cloud.tencent.com/document/product/213/11518



terraform {
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.70.0"
    }
  }
}

provider "tencentcloud" {
  region = var.region
}


# Get availability regions
data "tencentcloud_availability_regions" "default" {
}

# Get availability zones
data "tencentcloud_availability_zones_by_product" "default" {
  product = "cvm"
}

# Get availability images
data "tencentcloud_images" "default" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "centos"
}

# Get availability instance types
data "tencentcloud_instance_types" "default" {
  cpu_core_count = 2
  memory_size    = 4

  filter {
    name   = "zone"
    values = ["${var.availability_zone}"]
  }

  filter {
    name   = "instance-family"
    values = ["S5"]
  }
}

// Create VPC resource
resource "tencentcloud_vpc" "app" {
  cidr_block = "10.0.0.0/16"
  name       = "${var.prefix}_app_vpc"
}

resource "tencentcloud_subnet" "app" {
  vpc_id            = tencentcloud_vpc.app.id
  availability_zone = data.tencentcloud_availability_zones_by_product.default.zones.0.name
  name              = "${var.prefix}_app_subnet"
  cidr_block        = "10.0.1.0/24"
}

# define the actual aws instance with all the parameters above.
resource "tencentcloud_instance" "demo-ec2-instance-with-key" {

  instance_name = "${var.prefix}-demo-ec2-instance-with-key"
  #availability_zone = "${var.availability_zone}"
  availability_zone = data.tencentcloud_availability_zones_by_product.default.zones.0.name

  image_id      = data.tencentcloud_images.default.images.0.image_id
  instance_type = var.instance_type

  # instance_name     = "awesome_app"
  # availability_zone = data.tencentcloud_availability_zones.default.zones.0.name
  # image_id          = data.tencentcloud_images.default.images.0.image_id
  # instance_type     = data.tencentcloud_instance_types.default.instance_types.0.instance_type
  system_disk_type = "CLOUD_PREMIUM"
  system_disk_size = 50
  # hostname          = "user"
  # project_id        = 0
  vpc_id    = tencentcloud_vpc.app.id
  subnet_id = tencentcloud_subnet.app.id
  count     = 2

  data_disks {
    data_disk_type = "CLOUD_PREMIUM"
    data_disk_size = 50
    encrypt        = false
  }

  # vpc_id                     = "vpc-31zmeluu"
  # subnet_id                  = "subnet-aujc02np"

  # define the key pair for ssh
  # in AWS, it is .name, in tic, it is .id 
  key_name = tencentcloud_key_pair.demo-key-pair.id

  # enable public ip address and bandwidth
  allocate_public_ip         = true
  internet_max_bandwidth_out = 2

  # put a tag to label the resource
  tags = {
    Name       = "${var.prefix}-demo-instance-with-key"
    TTL        = 168
    Owner      = "william.yang@hashicorp.com"
    Purpose    = "demo for terraform features"
    Department = "devops"
    # Billable = "true"
  }
}





# create aws key pair, create private key 
resource "tls_private_key" "tlskey" {
  algorithm = "RSA"
}


resource "tencentcloud_key_pair" "demo-key-pair" {
  key_name   = "${var.prefix}_key"
  public_key = tls_private_key.tlskey.public_key_openssh
  # lifecycle {
  #   ignore_changes = [
  #     public_key,
  #   ]
  # }
}

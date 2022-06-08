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


# Get availability zones
data "tencentcloud_availability_zones_by_product" "default" {
  product = "cvm"
}

# Get availability regions
data "tencentcloud_availability_regions" "default" {
}


// Create VPC resource
resource "tencentcloud_vpc" "hashicat" {
  cidr_block = var.address_space
  name       = "${var.prefix}-vpc"
}


# subnet resource , equal vswitch
resource "tencentcloud_subnet" "hashicat" {
  vpc_id            = tencentcloud_vpc.hashicat.id
  availability_zone = data.tencentcloud_availability_zones_by_product.default.zones.0.name
  name              = "${var.prefix}-vswitch"
  cidr_block        =  var.subnet_prefix
}


resource "tencentcloud_security_group" "hashicat" {
  name   = "${var.prefix}-security-group"
  description = "hashicat"

  # project_id = tencentcloud_vpc.hashicat.id
  project_id = 0
}



resource "tencentcloud_security_group_rule" "allow_ssh" {
  type              = "ingress"
  policy            = "ACCEPT"
  security_group_id = tencentcloud_security_group.hashicat.id

  port_range        = "22"
  ip_protocol       = "tcp"
  cidr_ip           = "0.0.0.0/0"
}



resource "tencentcloud_security_group_rule" "allow_http" {
  type              = "ingress"
  policy            = "ACCEPT"
  security_group_id = tencentcloud_security_group.hashicat.id

  port_range        = "80"
  ip_protocol       = "tcp"
  cidr_ip           = "0.0.0.0/0"
}


resource "tencentcloud_security_group_rule" "allow_https" {
  type              = "ingress"
  policy            = "ACCEPT"
  security_group_id = tencentcloud_security_group.hashicat.id

  port_range        = "443"
  ip_protocol       = "tcp"
  cidr_ip           = "0.0.0.0/0"
}


resource "tencentcloud_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  policy            = "ACCEPT"
  security_group_id = tencentcloud_security_group.hashicat.id

  # port_range        = "-1/-1"
  # ip_protocol       = "all"
  cidr_ip           = "0.0.0.0/0"
}



data "tencentcloud_images" "ubuntu" {
  image_type = ["PUBLIC_IMAGE"]
  image_name_regex  = "^Ubuntu Server 20.*64"
  # os_name    = "ubuntu"
}



resource "tencentcloud_eip" "hashicat" {
  name         = "${var.cataddressname}"
  internet_max_bandwidth_out = 2
  internet_service_provider = "BGP"
  internet_charge_type = "BANDWIDTH_POSTPAID_BY_HOUR"
}


resource "tencentcloud_eip_association" "hashicat" {
  instance_id   = tencentcloud_instance.hashicat.id
  eip_id = tencentcloud_eip.hashicat.id
  }

# provision ecs instance
resource "tencentcloud_instance" "hashicat" {
  instance_name   = "${var.prefix}-hashicat"
  image_id        = data.tencentcloud_images.ubuntu.images.0.image_id
  instance_type   = var.instance_type
  availability_zone = data.tencentcloud_availability_zones_by_product.default.zones.0.name

  subnet_id      = tencentcloud_subnet.hashicat.id
  security_groups = [tencentcloud_security_group.hashicat.id]
  vpc_id = tencentcloud_vpc.hashicat.id

  allocate_public_ip         = true
  internet_max_bandwidth_out = 2


  system_disk_type = "CLOUD_PREMIUM"
  system_disk_size = 50
  data_disks {
    data_disk_type = "CLOUD_PREMIUM"
    data_disk_size = 50
    encrypt        = false
  }

  key_name = tencentcloud_key_pair.hashicat.id


  tags = {
    Department = "devops"
    Billable   = "true"
  }
}


# We're using a little trick here so we can run the provisioner without
# destroying the VM. Do not do this in production.

# If you need ongoing management (Day N) of your virtual machines a tool such
# as Chef or Puppet is a better choice. These tools track the state of
# individual files and can keep them in the correct configuration.

# Here we do the following steps:
# Sync everything in files/ to the remote VM.
# Set up some environment variables for our script.
# Add execute permissions to our scripts.
# Run the deploy_app.sh script.
# default user is ubuntu, not root, need to use sudo to install components

resource "null_resource" "configure-cat-app" {
  depends_on = [tencentcloud_eip_association.hashicat]

  triggers = {
    build_number = timestamp()
  }

  provisioner "file" {
    source      = "files/"
    #destination = "/root/"
    destination = "/home/ubuntu/"

    connection {
      type        = "ssh"
      # user        = "root"
      user = "ubuntu"
      private_key = tls_private_key.hashicat.private_key_pem
      host        = tencentcloud_eip.hashicat.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -qq -y update",
      "sudo apt-get -qq -y install apache2",
      "sudo systemctl start apache2",
      "sudo chmod +x *.sh",
      "sudo PLACEHOLDER=${var.placeholder} WIDTH=${var.width} HEIGHT=${var.height} PREFIX=${var.prefix} ./deploy_app.sh",
      "sudo apt-get -qq -y install cowsay",
      "cowsay Mooooooooooo!",
    ]

    connection {
      type        = "ssh"
      # user        = "root"
      user = "ubuntu"
      private_key = tls_private_key.hashicat.private_key_pem
      host        = tencentcloud_eip.hashicat.public_ip
    }
  }
}

resource "tls_private_key" "hashicat" {
  algorithm = "RSA"
}

locals {
  private_key_filename = "${var.prefix}-ssh-key.pem"
}

resource "tencentcloud_key_pair" "hashicat" {
  key_name = "${var.prefix}_key"
  public_key    = tls_private_key.hashicat.public_key_openssh
}

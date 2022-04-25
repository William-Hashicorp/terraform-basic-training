# Terraform provider, define it will talk to aws
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.64.0"
        }
  }
}

# Use this data source to get the ID of a registered AMI for use in other resources.
# this is the image template used for this sample
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


# create aws key pair, create private key 
resource "tls_private_key" "tlskey" {
  algorithm = "RSA"
}

# create aws key pair, create public key with the private key
resource "aws_key_pair" "demo-key-pair" {
  key_name   = "${var.prefix}-demo-key-terraform"
  public_key = tls_private_key.tlskey.public_key_openssh
}


#define the region of aws
provider "aws" {
  region  = var.region
}

# define the actual aws instance with all the parameters above.
resource "aws_instance" "demo-ec2-instance-with-key" {
  # image template
  ami                         = data.aws_ami.ubuntu.id
    # define the vm type as t2.micro
  instance_type               = var.instance_type
  # define the key pair for ssh
  key_name                    = aws_key_pair.demo-key-pair.key_name
  # enable public ip address
  associate_public_ip_address = true

 # put a tag to label the resource
  tags = {
    Name = "${var.prefix}-demo-ec2-instance-with-key"
    TTL = 168
    Owner = "william.yang@hashicorp.com"
    Purpose = "demo for terraform features"
    Department = "devops"
    # Billable = "true"
  }
}


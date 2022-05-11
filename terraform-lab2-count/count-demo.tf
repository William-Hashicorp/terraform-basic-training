


provider "aws" {
  region     = "us-west-2"
}

# resource "aws_instance" "instance-1" {
#    ami = "ami-082b5a644766e0e6f"
#    instance_type = "t2.micro"
#    count = 3
# }

# use count index
# resource "aws_lb" "lb" {
#   name = "loadbalancer-${count.index}"
#   count = 3
# }


# combine with list
# variable "user_names" {
#   type = list
#   default = ["dev-admin", "stage-admin","prod-admin"]
# }

# resource "aws_iam_user" "adminuser" {
#   name = var.user_names[count.index]
#   count = 3
#   path = "/system/"
# }

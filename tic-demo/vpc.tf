// Create a vpc
resource "tencentcloud_vpc" "vpc_demo" {
  name = "ajaxhe-vpc-demo"
  cidr_block = "10.0.0.0/16"

  tags = {
    role = "cgi"
    env = "prod"
  }
}
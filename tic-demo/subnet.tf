// Create a subnet
resource "tencentcloud_subnet" "subnet_demo" {
  name = "ajaxhe-subnet-demo"
  cidr_block = "10.0.1.0/24"
  availability_zone = var.default_az
  vpc_id = tencentcloud_vpc.vpc_demo.id
  route_table_id = tencentcloud_route_table.rtb_demo.id

  tags = {
    role = "cgi"
    env = "prod"
  }
}
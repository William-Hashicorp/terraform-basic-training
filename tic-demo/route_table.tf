// Create a route table
resource "tencentcloud_route_table" "rtb_demo" {
  name = "ajaxhe-rtb-demo"
  vpc_id = tencentcloud_vpc.vpc_demo.id
  
  tags = { 
    role = "cgi" 
    env = "prod"
  }
}
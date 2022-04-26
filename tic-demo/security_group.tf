// Create a security group and rule
resource "tencentcloud_security_group" "sg_demo" {
  name = "ajaxhe-sg-demo" 
  tags = { 
    role = "cgi"
    env = "prod"
  } 
}
  
resource "tencentcloud_security_group_rule" "sg_rule_demo" {
  security_group_id = tencentcloud_security_group.sg_demo.id
  type = "ingress"
  cidr_ip = "0.0.0.0/0"
  ip_protocol = "tcp"
  port_range = "22,80"
  policy = "accept"
}
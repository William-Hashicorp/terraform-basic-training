// Create cvm
resource "tencentcloud_instance" "cvm_demo" {
  instance_name = "ajaxhe-cvm-demo"
  availability_zone = var.default_az
  image_id = "img-pi0ii46r"
  instance_type = "S2.SMALL1"
  system_disk_type = "CLOUD_PREMIUM"
  allocate_public_ip = true
 
  security_groups = [
    tencentcloud_security_group.sg_demo.id
  ]

  vpc_id = tencentcloud_vpc.vpc_demo.id
  subnet_id = tencentcloud_subnet.subnet_demo.id
  internet_max_bandwidth_out = 10
  count = 2

  tags = {
    role = "cgi"
    env = "prod"
  }
}
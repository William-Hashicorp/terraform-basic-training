resource "tencentcloud_mysql_instance" "mysql_demo" {
  internet_service = 1
  engine_version   = "5.7"
  
  root_password     = "YourPassword00"
  slave_deploy_mode = 0
  first_slave_zone  = var.default_az
  second_slave_zone = var.default_az
  slave_sync_mode   = 1
  availability_zone = var.default_az
  instance_name     = "ajaxhe_mysql_demo"
  mem_size          = 128000
  volume_size       = 250
  vpc_id            = tencentcloud_vpc.vpc_demo.id
  subnet_id         = tencentcloud_subnet.subnet_demo.id
  intranet_port     = 3306
  security_groups   = [tencentcloud_security_group.sg_demo.id]

  tags = {
    role = "db"
    env = "prod"
  }

  parameters = {
    max_connections = "1000"
  }
}
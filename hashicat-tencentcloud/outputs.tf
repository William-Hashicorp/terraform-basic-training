# Outputs file
output "catapp_ip" {
  value = "http://${tencentcloud_eip.hashicat.public_ip}"
}

output "private_key" {
value = tls_private_key.tlskey.private_key_pem
sensitive = true
}

output "public_key" {
value = tls_private_key.tlskey.public_key_openssh
}

output "public_ip_address_s1" {
value = tencentcloud_instance.demo-ec2-instance-with-key[0].public_ip
}

output "public_ip_address_s2" {
value = tencentcloud_instance.demo-ec2-instance-with-key[1].public_ip
}
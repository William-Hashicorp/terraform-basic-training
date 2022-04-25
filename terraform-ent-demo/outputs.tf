output "private_key" {
value = tls_private_key.tlskey.private_key_pem
sensitive = true
}

output "public_key" {
value = tls_private_key.tlskey.public_key_openssh
}

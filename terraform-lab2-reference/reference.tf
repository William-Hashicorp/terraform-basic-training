provider "aws" {
  region     = "us-east-1"

}

resource "aws_instance" "william-myec2" {
   ami = "ami-082b5a644766e0e6f"
   instance_type = "t2.micro"
}

resource "aws_eip" "william-lb" {
  vpc      = true
}

# associate the instance and eip
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.william-myec2.id
  allocation_id = aws_eip.william-lb.id
}


resource "aws_security_group" "allow_tls" {
  name        = "william-security-group"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.william-lb.public_ip}/32"]

  }
}
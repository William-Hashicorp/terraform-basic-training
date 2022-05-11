provider "aws" {
  region = "ap-south-1"
}


resource "aws_instance" "test-debug" {

  # ami = "ami-0d6621c01e8c2de2c"
  ami           = "ami-0d6621c01e812321c"
  instance_type = "t2.micro"

}
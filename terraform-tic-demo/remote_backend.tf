 terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "William-Hashicorp"
    workspaces {
      name = "terraform-tic-demo"
            }
  }
} 


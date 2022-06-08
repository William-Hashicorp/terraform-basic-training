terraform {
  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.70.0"
    }
  }
}

provider "tencentcloud" {
  region = "ap-singapore"
}

resource "tencentcloud_eip" "williamy-lb" {
  name      = "williamy_gateway_ip"
}

# output "eip-publicip" {
#   value = tencentcloud_eip.williamy-lb.public_ip
# }

# output "eip-dns" {
#   value = tencentcloud_eip.williamy-lb.name
# }


output "eip-publicip" {
  value = tencentcloud_eip.williamy-lb
}




# no permission in the test account
# resource "tencentcloud_cos_bucket" "williamy-my-storage" {
#   bucket = "williamy-12345"
# }
# output "mys3bucket" {
#   value = tencentcloud_cos_bucket.williamy-my-storage.cos_bucket_url
# }



# module "network_vpc" {
#   source  = "terraform-google-modules/network/google//modules/vpc"
#   version = "9.0.0"
#   network_name = "vpc-01-memcache"
#   project_id = var.project_id
#   auto_create_subnetworks = true
# }
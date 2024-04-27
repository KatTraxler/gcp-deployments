########################################################################
# Define modules
########################################################################
module "public_function" {
    source  = "./modules/public-function"
    project_id = var.project_id
    region = var.region

}

module "function_v2" {
    source  = "./modules/function-v2"
    project_id = var.project_id
    region = var.region

}
########################################################################
# Define modules
########################################################################
module "basic_instance" {
    source  = "./modules/basic-instance"
    
    project_id = var.project_id
    region     = var.region

}
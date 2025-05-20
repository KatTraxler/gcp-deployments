########################################################################
# Define modules
########################################################################
module "restrict_storage_by_identity" {
    source      = "./modules/restrict-storage-by-identity"
    project-id  = var.project-id
    region      = var.region
    
}
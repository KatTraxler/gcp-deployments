########################################################################
# Define modules
########################################################################
module "shared_infra" {
    source  = "./modules/shared_infra"
    
    project_id = var.project_id
    region     = var.region

}

module "deploy_workflow_invoke_ec2" {
    source  = "./modules/workflow_invoke_ec2"
    project_id = var.project_id
    region     = var.region
    depends_on = [ module.shared_infra ]
}

module "deploy_workflow_basic_callback" {
    source  = "./modules/workflow_with_callback_basic"
    project_id = var.project_id
    region     = var.region
    depends_on = [ module.shared_infra ]
}

module "deploy_workflow_with_pubsub" {
    source  = "./modules/workflows-with-pubsub"
    project_id = var.project_id
    region     = var.region
    depends_on = [ module.shared_infra ]
}
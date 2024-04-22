########################################################################
# Define modules
########################################################################
module "call_apsi" {
    source  = "./modules/execute-api-calls"
    project_id = var.project_id

}

module "call_deploy_job" {
    source  = "./modules/cloud-run-job"


}

module "call_deploy_service" {
    source  = "./modules/cloud-run-service"
    project_id = var.project_id
    region = var.region
    
}
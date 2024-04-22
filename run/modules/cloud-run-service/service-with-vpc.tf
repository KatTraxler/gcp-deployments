# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A CLOUD RUN SERVICE with a VPC Serverless Connector
# ------------------------------------------------------------------------------------------


module "cloud-run_example_cloud_run_vpc_connector" {
  source  = "GoogleCloudPlatform/cloud-run/google//examples/cloud_run_vpc_connector"
  version = "0.10.0"
 project_id = var.project_id
}
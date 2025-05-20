########################################################################
# Enable APIs
########################################################################
resource "google_project_service" "enable_project_apis" {
  count   = length(local.enable_services)
  project = var.project_id
  service = local.enable_services[count.index]
  disable_on_destroy = false
  timeouts {
    create = "30m"
    update = "40m"
  }
}

########################################################################
# Enable Logging
########################################################################

resource "google_project_iam_audit_config" "project" {
  count   = length(local.enable_logs)
  project = var.project_id
  service = local.enable_logs[count.index]
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
}

##########################################################################
# Batch Modules
###########################################################################

# module "batchWorkflow-runnable-script" {
#     source              = "./modules/batchWorkflow-runnable-script"
#     project_id          = var.project_id
#     region              = var.region
#     depends_on          = [ google_project_service.enable_project_apis ]

# }

module "batchWorkflow-runnable-container" {
    source              = "./modules/batchWorkflow-runnable-container"
    project_id          = var.project_id
    region              = var.region
    depends_on          = [ google_project_service.enable_project_apis ]

}
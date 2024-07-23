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
# Define modules
########################################################################

# module "create_ai_notebook" {
#     source      = "./modules/notebooks"
#     project_id  = var.project_id
#     region      = var.region
#     zone        = var.zone
#     depends_on = [ google_project_service.enable_project_apis ]
# }

# module "create_custom_container_notebook" {
#     source      = "./modules/custom-container-notebooks"
#     project_id  = var.project_id
#     region      = var.region
#     zone        = var.zone
#     depends_on = [ google_project_service.enable_project_apis ]
# }

module "create_avml_notebook" {
    source      = "./modules/avml-container-notebook"
    project_id  = var.project_id
    region      = var.region
    zone        = var.zone
    depends_on = [ google_project_service.enable_project_apis ]
}
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


resource "google_project_service" "enable_project_apis" {
  project = var.project_id
  service = "certificatemanager.googleapis.com"
  disable_on_destroy = false
  timeouts {
    create = "30m"
    update = "40m"
  }
}
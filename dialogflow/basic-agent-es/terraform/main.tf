resource "google_project_service" "agent_project" {
  project = var.project_id
  service = "dialogflow.googleapis.com"
  disable_dependent_services = false
}


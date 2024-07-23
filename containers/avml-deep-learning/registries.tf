
resource "google_artifact_registry_repository" "avml-deep-learning-container-repo" {
  project       = data.google_project.project.project_id
  location      = var.region
  repository_id = "avml-deep-learning"
  description   = "Registry which Cloud Build can push the AVML containter to when its built"
  format        = "DOCKER"
}

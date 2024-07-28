
resource "google_artifact_registry_repository" "avml-basic-repo" {
  project       = data.google_project.project.project_id
  location      = var.region
  repository_id = "avml-containers"
  description   = "Registry which Cloud Build can push a variaety of AVML containters after its built with cloudbuild"
  format        = "DOCKER"
}

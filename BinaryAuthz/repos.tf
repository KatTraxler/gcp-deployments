# ---------------------------------------------------------------------------------------------------------------------
# CREATE A CONTAINER REGIGISTY WHERE CLOUD BUILD WILL STORE IMAGES and PULL FROM
# ---------------------------------------------------------------------------------------------------------------------

resource "google_artifact_registry_repository" "hello_word" {
  location      = "us"
  repository_id = "my-repos"
  description   = "docker repository for sample hellow world app"
  format        = "DOCKER"
}
# ---------------------------------------------------------------------------------------------------------------------
# CREATE A CLOUD BUILD TRIGGER
# ---------------------------------------------------------------------------------------------------------------------
data "google_project" "project" {
  project_id = var.project_id
}

resource "google_cloudbuild_trigger" "avml_basic__cloudbuild_trigger" {
  name          = "build-avml-basic-container"
  project       = var.project_id
  location = "global"

  github {
    owner = "KatTraxler"
    name  = "gcp-deployments"
    push {
      branch = "^main$"
    }
  }


  filename = "./containers/avml-basic/image-files/cloudbuild.yaml"
}


# ---------------------------------------------------------------------------------------------------------------------
# ADD PERMISSIONS TO CLOUDBUILD P4SA
# ----------------------------------------------------

resource "google_project_iam_member" "cloudbuild" {
  project       = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}
# ---------------------------------------------------------------------------------------------------------------------
# CREATE A CONTAINER REGIGISTY WHERE CLOUD BUILD WILL STORE ARITFACTS AND CLOUD BUILD WILL PULL FROM
# ---------------------------------------------------------------------------------------------------------------------


resource "google_sourcerepo_repository" "my_repo" {
  name = "kat-dummy-repo"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A CLOUD BUILD TRIGGER
# ---------------------------------------------------------------------------------------------------------------------

data "google_project" "project" {}

resource "google_cloudbuild_trigger" "service-account-trigger" {

  trigger_template {
    branch_name = "master"
    repo_name   = "kat-dummy-repo"
  }
 
  filename        = "cloudbuild.yaml"
  depends_on = [ module.cli ]

}



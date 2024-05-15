provider "google" {
  region  = "us-central1"
  project = "${var.project_id}"
  user_project_override = true
  billing_project = "${var.project_id}"
}
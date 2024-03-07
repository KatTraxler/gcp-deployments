provider "google" {
  region  = "${var.region}"
  project = "${var.project_id}"
  user_project_override = true
  billing_project = "${var.project_id}"
}
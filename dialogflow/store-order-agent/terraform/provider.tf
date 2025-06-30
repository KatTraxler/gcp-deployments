provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
  billing_project = var.project_id
  user_project_override = true
}

terraform {
  required_providers {
    google = ">= 4.40.0"
    null   = ">= 3.2.0"
  }

  required_version = ">= 1.2.0"
}

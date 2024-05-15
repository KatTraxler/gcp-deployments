# Cloud Storage bucket names must be globally unique
resource "random_id" "bucket_name_suffix" {
  byte_length = 4
}

# Create a Cloud Storage bucket
resource "google_storage_bucket" "default" {
  name          = "trigger-workflows-${data.google_project.project.name}-${random_id.bucket_name_suffix.hex}"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
}

# Grant the Cloud Storage service account permission to publish Pub/Sub topics
data "google_storage_project_service_account" "gcs_account" {}
resource "google_project_iam_member" "pubsubpublisher" {
  project = data.google_project.project.id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}
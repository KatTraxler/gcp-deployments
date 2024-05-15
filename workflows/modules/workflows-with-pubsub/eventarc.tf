## Eventarc IAM

# Used to retrieve project information later
data "google_project" "project" {}

# Create a service account for Eventarc trigger and Workflows
resource "google_service_account" "eventarc" {
  account_id   = "eventarc-workflows-sa"
  display_name = "Eventarc Workflows Service Account"
}

# Grant permission to invoke workflows
resource "google_project_iam_member" "workflowsinvoker" {
  project = data.google_project.project.id
  role    = "roles/workflows.invoker"
  member  = "serviceAccount:${google_service_account.eventarc.email}"
}

# Grant permission to receive events
resource "google_project_iam_member" "eventreceiver" {
  project = data.google_project.project.id
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.eventarc.email}"
}

# Create an Eventarc trigger, routing Cloud Storage events to Workflows
resource "google_eventarc_trigger" "default" {
  name     = "trigger-storage-workflows-tf"
  location = var.region

  # Capture objects changed in the bucket
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.storage.object.v1.finalized"
  }
  matching_criteria {
    attribute = "bucket"
    value     = google_storage_bucket.default.name
  }

  # Send events to Workflows
  destination {
    workflow = google_workflows_workflow.workflow_with_pubsub_trigger.id
  }

  service_account = google_service_account.eventarc.email

}
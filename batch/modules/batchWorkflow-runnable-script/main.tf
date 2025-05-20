########################################################################
# Create SA for Workflows to run Batch Job
########################################################################

resource "google_service_account" "service_account" {
  project = var.project_id
  account_id   = "workflow-service-account"
  display_name = "Service Account for Workflow to execute a batch job with"
}
resource "google_project_iam_binding" "project" {
  project = var.project_id
  role    = "roles/batch.admin"

  members = [
    google_service_account.service_account.member
  ]
}

resource "google_project_iam_binding" "service_usage" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageConsumer"

  members = [
    google_service_account.service_account.member
  ]
}

resource "google_project_iam_binding" "log_writing" {
  project = var.project_id
  role    = "roles/logging.admin"

  members = [
    google_service_account.service_account.member
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Service-Account Level IAM
# ---------------------------------------------------------------------------------------------------------------------

## Allow the workflows SA to ActAs the default Compute SA
## Required for the Workflows Service Account to provision computing environment

data "google_compute_default_service_account" "default" {
  project = var.project_id
}

resource "google_service_account_iam_member" "actas-gce-default-account-by-workflow-sa" {
  service_account_id = data.google_compute_default_service_account.default.name
  role               = "roles/iam.serviceAccountUser"
  member             = google_service_account.service_account.member
}
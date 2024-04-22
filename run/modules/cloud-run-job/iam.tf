resource "google_service_account" "service_account" {
  account_id   = "cloud-run-job-sa"
  display_name = "Execution Service Account for Cloud Run Jobs"
}

resource "google_secret_manager_secret_iam_member" "secret-access-sa" {
  secret_id = google_secret_manager_secret.secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = google_service_account.service_account.member
  depends_on = [google_secret_manager_secret.secret]
}
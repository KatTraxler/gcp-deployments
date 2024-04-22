resource "google_service_account" "service_account" {
  account_id   = "cloud-run-service-sa"
  display_name = "Execution Service Account for Cloud Run Services"
}
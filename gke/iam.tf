# ---------------------------------------------------------------------------------------------------------------------
# New Customer Managed Service Account
# ---------------------------------------------------------------------------------------------------------------------

resource "google_service_account" "gke-node-sa" {
  account_id   = "gke-node-sa"
  display_name = "Service Account run the GKE nodes as"
  project = var.project_id

}

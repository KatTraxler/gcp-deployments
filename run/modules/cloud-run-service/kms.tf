data "google_project" "project" {
}

resource "random_string" "keyRandomKMS" {
  length = 5
  special = false
  lower  = true
}

resource "google_secret_manager_secret" "service-secret" {
  secret_id = "service-secret-${random_string.keyRandomKMS.id}"
  replication {
    auto {}
  }
#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "google_secret_manager_secret_version" "secret-version-data" {
  secret = google_secret_manager_secret.service-secret.name
  secret_data = "secret-data"
#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "google_secret_manager_secret_iam_member" "secret-access" {
  secret_id = google_secret_manager_secret.service-secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  depends_on = [google_secret_manager_secret.service-secret]
}
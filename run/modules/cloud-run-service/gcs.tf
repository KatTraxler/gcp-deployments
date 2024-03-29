resource "random_string" "keyRandomGCS" {
  length = 5
  special = false
  lower  = true
  upper = false

}

resource "google_storage_bucket" "cloudrun-service" {
    name     = "cloudrun-service-${random_string.keyRandomGCS.id}"
    location = "US"
}
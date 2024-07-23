# resource "random_string" "bucket_suffix" {
#   length = 4
#   special = false
#   lower = true
#   upper = false
# }

# resource "google_storage_bucket" "startup-script-bucket" {
#   name          = "startup-script-bucket-${random_string.bucket_suffix.id}"
#   location      = "US"
#   project       = var.project_id
#   force_destroy = true

#   uniform_bucket_level_access = true

# }

# resource "google_storage_bucket_object" "startup-scripts" {
#   name          = "startup-script.sh"
#   content        = local.startup-script
#   bucket        = "${google_storage_bucket.startup-script-bucket.name}"
# }
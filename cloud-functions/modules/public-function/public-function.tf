resource "random_string" "this" {
  length = 4
  special = false
  upper = false
} 

resource "google_storage_bucket" "function-bucket" {
  name     = "cloud-function-souce-${random_string.this.id}"
  location = "US"
  uniform_bucket_level_access = true
}

data "archive_file" "default" {
  type        = "zip"
  output_path = "/tmp/function-source.zip"
  source_dir  = "./modules/public-function/helloworldHttp"
}
resource "google_storage_bucket_object" "object" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.function-bucket.name
  source = data.archive_file.default.output_path # Add path to the zipped function source code
}



resource "google_cloudfunctions_function" "function" {
  name        = "public-function-test"
  description = "My function"
  runtime     = "nodejs16"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.function-bucket.name
  source_archive_object = google_storage_bucket_object.object.name
  trigger_http          = true
  entry_point           = "helloHttp"
  ingress_settings      = "ALLOW_ALL" 
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "user:kat@trustoncloud.com"
}

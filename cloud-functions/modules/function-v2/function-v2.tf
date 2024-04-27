locals {
  project = var.project_id
}

resource "google_service_account" "account" {
  account_id = "gcf-v2-sa"
  display_name = "Cloud Functions v2 Service Account"
}

resource "google_pubsub_topic" "topic" {
  name = "functions-v2-topic"
}

resource "random_string" "this" {
  length = 4
  special = false
  upper = false
} 

resource "google_storage_bucket" "bucket" {
  name     = "${local.project}-gcf-source-${random_string.this.id}"  # Every bucket name must be globally unique
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
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.default.output_path # Add path to the zipped function source code
}

resource "google_cloudfunctions2_function" "function" {
  name = "gcf-function"
  location = "us-central1"
  description = "a new function"

  build_config {
    runtime = "nodejs16"
    entry_point = "helloHttp"  # Set the entry point 
    environment_variables = {
        BUILD_CONFIG_TEST = "build_test"
    }
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.object.name
      }
    }
  }

  service_config {
    max_instance_count  = 3
    min_instance_count = 1
    available_memory    = "4Gi"
    timeout_seconds     = 60
    max_instance_request_concurrency = 80
    available_cpu = "4"
    environment_variables = {
        SERVICE_CONFIG_TEST = "config_test"
    }
    ingress_settings = "ALLOW_INTERNAL_ONLY"
    all_traffic_on_latest_revision = true
    service_account_email = google_service_account.account.email
  }

  event_trigger {
    trigger_region = "us-central1"
    event_type = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic = google_pubsub_topic.topic.id
    retry_policy = "RETRY_POLICY_RETRY"
  }
}
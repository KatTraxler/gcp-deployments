# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A CLOUD RUN SERVICE
# ------------------------------------------------------------------------------------------


resource "google_cloud_run_v2_service" "cloudrun-service" {
  name     = "cloudrun-service"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  location     = "us-central1"
  launch_stage = "BETA"

  template {
    volumes {
      name = "a-volume"
      secret {
        secret = google_secret_manager_secret.service-secret.secret_id
        default_mode = 292 # 0444
        items {
          version = "1"
          path = "my-secret"
        }
      }
    }
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      volume_mounts {
        name = "a-volume"
        mount_path = "/secrets"
      }
    }
  }
  depends_on = [ google_storage_bucket.cloudrun-service, google_secret_manager_secret.service-secret ]
  }


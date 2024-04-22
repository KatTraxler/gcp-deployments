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

resource "google_cloud_run_service" "cloudrun-service-v1" {
  name     = "cloudrun-srv-v1"
  location = var.region

  metadata {
    namespace = var.project_id
  }

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }
}


resource "google_cloud_run_domain_mapping" "my-domain-mapping" {
  location = var.region
  name     = "run.toctesting.com"

  metadata {
    namespace = var.project_id
  }

  spec {
    route_name = google_cloud_run_service.cloudrun-service-v1.name
  }
}
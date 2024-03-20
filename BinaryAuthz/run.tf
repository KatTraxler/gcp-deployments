# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A CLOUD RUN SERVICE
# ------------------------------------------------------------------------------------------

resource "google_cloud_run_v2_service" "sample-app" {
  name     = "sample-app"
  location = var.region
  project  = var.project_id
  ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"
binary_authorization {
    breakglass_justification = "bypassing binary auth"
    use_default = true
        
      }

## Template Block
  template {

    containers {
      image = "us-docker.pkg.dev/${var.project_id}/my-repos/helloworld-gke:latest"
      
      env {
        name = "PROJECT_ID"
        value = var.project_id
      }


  }
  }
  depends_on = [ google_artifact_registry_repository.hello_word ]
}

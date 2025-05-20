data "google_project" "current" {}

#########################################################################################
#################### Configure Logging Bucket ###########################################
#########################################################################################
# resource "google_logging_project_bucket_config" "analytics-enabled-bucket" {
#     project          = var.project-id
#     location         = "global"
#     retention_days   = 30
#     enable_analytics = true
#     bucket_id        = "bugswat-2024"
# }


#########################################################################################
#################### Filter Logs with Sink ##############################################
#########################################################################################

resource "google_logging_project_sink" "log-bucket" {
  name        = "my-logging-sink"
  destination = "logging.googleapis.com/projects/${data.google_project.current.number}/locations/global/buckets/bugswat-2024"

  exclusions {
    name        = "excllusion1"
    description = "Exclude logs from namespace-1 in k8s"
    filter      = "resource.type = k8s_container resource.labels.namespace_name=\"namespace-1\" "
  }

  exclusions {
    name        = "excllusion2"
    description = "Exclude logs from namespace-2 in k8s"
    filter      = "resource.type = k8s_container resource.labels.namespace_name=\"namespace-2\" "
  }

  unique_writer_identity = true
  depends_on = [ google_logging_project_bucket_config.analytics-enabled-bucket ]
}


######################################################################################################
#################### Exlude Logs of Certain Resource Types ###########################################
######################################################################################################

resource "google_logging_project_exclusion" "my-exclusion" {
  name = "my-instance-debug-exclusion"

  description = "Exclude GCE instance debug logs"

  # Exclude all DEBUG or lower severity messages relating to instances
  filter = "resource.type = gce_instance AND severity <= DEBUG"
}
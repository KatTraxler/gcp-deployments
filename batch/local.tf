locals {
  enable_services = [
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "storage.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-component.googleapis.com",
    "storage-api.googleapis.com",
    "batch.googleapis.com",
    "compute.googleapis.com",
    "cloudscheduler.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
}

locals {
  enable_logs = [
    "iam.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "storage.googleapis.com",
    "serviceusage.googleapis.com",
    "batch.googleapis.com",
    "compute.googleapis.com",
    "cloudscheduler.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
}

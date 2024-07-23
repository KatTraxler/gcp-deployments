locals {
  enable_services = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "aiplatform.googleapis.com",
    "notebooks.googleapis.com",
    "cloudkms.googleapis.com",
    "iap.googleapis.com"
  ]
}
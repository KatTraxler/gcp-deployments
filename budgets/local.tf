locals {
  enable_services = [
    "cloudresourcemanager.googleapis.com",
    "pubsub.googleapis.com",
    "workflows.googleapis.com",
    "workflowexecutions.googleapis.com",
    "eventarc.googleapis.com",
    "iam.googleapis.com"
  ]
}
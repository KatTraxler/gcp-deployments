variable "project_id" {
  description = "The ID of the project to deploy resources into"
  type        = string
}

variable "region" {
   type        = string
   description = "GCP region where resources are created."
   default = "us-central"
}

variable "zone" {
   type        = string
   description = "GCP zone in the var.region where resources are created."
   default = "us-central1-a"
}

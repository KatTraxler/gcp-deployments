############################################################
### Build the Google Community Builders Image   ###
### used in Cloud Step when signing image       ###
############################################################

module "cli" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.4"
  create_cmd_entrypoint  = "gcloud"

  platform              = "linux"

  create_cmd_body  = "builds submit ./binauthz-attestation --config ./binauthz-attestation/cloudbuild.yaml --project ${var.project_id}"
}
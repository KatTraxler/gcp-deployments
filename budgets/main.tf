########################################################################
# Enable APIs
########################################################################
resource "google_project_service" "enable_project_apis" {
  count   = length(local.enable_services)
  project = var.project_id
  service = local.enable_services[count.index]
  disable_on_destroy = false
  timeouts {
    create = "30m"
    update = "40m"
  }
}

########################################################################
# Define modules
########################################################################
module "email-and-remove-billing" {
    source              = "./modules/email-and-remove-billing"
    project_id          = var.project_id
    region              = var.region
    channel_type        = var.channel_type
    display_name        = var.display_name
    description         = var.description
    labels              = var.labels
    domain              = var.domain
    spend               = var.spend
    billing_account_id  = var.billing_account_id
    depends_on          = [ google_project_service.enable_project_apis ]

}
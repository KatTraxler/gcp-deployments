########################################################################
# Define modules
########################################################################
module "email-and-remove-billing" {
    source          = "./modules/email-and-remove-billing"
    project_id      = var.project_id
    region          = var.region
    channel_type    = var.channel_type
    display_name    = var.display_name
    description     = var.description
    labels          = var.labels
}
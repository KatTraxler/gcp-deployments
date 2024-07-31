########################################################################
# Notification Channel
########################################################################
resource "google_monitoring_notification_channel" "notification_channel" {

  project = var.project_id

  # NOTE: We explicitly set the display_name if none is provided since otherwise
  # GCP will set it a to a specific labels value depending on the chosen type.
  display_name = var.display_name != null ? var.display_name : "${upper(var.channel_type)} Notification Channel"

  description = var.description
  type        = var.channel_type

  labels      = var.labels

  force_delete = false
}
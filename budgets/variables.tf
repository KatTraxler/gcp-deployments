variable "project_id" {
  description = "The ID of the project to deploy resources into"
  type        = string
}

variable "region" {
  description = "The geographical region to deploy resources into"
  type        = string
}

########################################################################
# Notification Channel Variables
########################################################################
variable "channel_type" {
  type        = string
  description = "(Required) The type of the notification channel. Valid values are `email`, `slack`, `sms`, `webhook_basicauth` and `pagerduty`."
}

variable "display_name" {
  type        = string
  description = "(Optional) An optional human-readable name for this notification channel. It is recommended that you specify a non-empty and unique name in order to make it easier to identify the channels in your project, though this is not enforced. The display name is limited to 512 Unicode characters."
  default     = null
}

variable "description" {
  type        = string
  description = "(Optional) An optional human-readable description of this notification channel. This description may provide additional details, beyond the display name, for the channel. This may not exceed 1024 Unicode characters."
  default     = "Notification managed by the Terraform module."
}

variable "labels" {
  type        = map(string)
  description = "(Optional) Configuration fields that define the channel and its behavior. Labels with sensitive data should be configured via the 'sensitive_labels' block. Use the 'email_address' label to define who is emailed in this channel"
  default     = {}
}

########################################################################
# Billing Variables
########################################################################
variable "domain" {
  description = "FQDN of domain associated with GCP organization"
  type        = string
}

variable "spend" {
  description = "The dollar amount allowed across all projects in the organization"
  type        = string
}

variable "billing_account_id" {
  description = "The ID of the Billing account to apply the budget"
  type        = string
}

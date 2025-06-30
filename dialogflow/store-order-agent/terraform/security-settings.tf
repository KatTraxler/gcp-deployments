
resource "random_string" "suffix" {
  length           = 18
  special          = false
  upper            = false
}

resource "google_storage_bucket" "bucket" {
  name                        = "dialogflowcx-bucket-${random_string.suffix.id}"
  location                    = "US"
  uniform_bucket_level_access = true
}

resource "google_dialogflow_cx_security_settings" "basic_security_settings" {
  project             = var.project_id
  display_name        = "dialogflowcx-security-settings"
  location            = "global"
  redaction_strategy  = "REDACT_WITH_SERVICE"
  redaction_scope     = "REDACT_DISK_STORAGE"
  inspect_template    = google_data_loss_prevention_inspect_template.inspect.id
  deidentify_template = google_data_loss_prevention_deidentify_template.deidentify.id
  purge_data_types    = ["DIALOGFLOW_HISTORY"]
  audio_export_settings {
    gcs_bucket             = google_storage_bucket.bucket.id
    audio_export_pattern   = "export"
    enable_audio_redaction = true
    audio_format           = "OGG"
  }
  insights_export_settings {
    enable_insights_export = true
  }
  retention_strategy = "REMOVE_AFTER_CONVERSATION"
}
resource "google_dialogflow_cx_agent" "agent" {
  project = var.project_id
  display_name          = "store-order-agent"
  location              = var.region
  default_language_code = "en"
  time_zone             = "America/Chicago"
  avatar_uri = "https://storage.cloud.google.com/dialogflow-research-agents-213/home_favicon.ico.png"
}

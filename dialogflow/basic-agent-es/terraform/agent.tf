resource "google_dialogflow_agent" "basic_agent" {
  project = var.project_id
  display_name = "basic_agent_es"
  default_language_code = "en"
  time_zone = "America/New_York"
  avatar_uri = "https://storage.cloud.google.com/dialogflow-research-agents-213/home_favicon.ico.png"
  enable_logging = true
  api_version = "API_VERSION_V2_BETA_1"
}
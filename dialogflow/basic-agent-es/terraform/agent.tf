resource "google_dialogflow_agent" "basic_agent" {
  project = var.project_id
  display_name = "basic_agent_es"
  default_language_code = "en"
  time_zone = "America/New_York"
}
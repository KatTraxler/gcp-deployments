resource "google_dialogflow_cx_webhook" "basic_webhook" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "Generic Web Hook"
  generic_web_service {
        uri = "https://example.com"
        request_headers = {
            Authorization = "Bearer ya29."
        }
    }
    enable_stackdriver_logging = true
}
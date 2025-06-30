resource "google_dialogflow_cx_webhook" "basic_webhook" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "Generic Web Hook"
  generic_web_service {
        uri = "https://example.com"
        request_headers = {
            Authorization = "Bearer ya29.a0AW4XtxhA9yh-UPC6OOChJQvbVC5igCJPAJa_akIYyT1KRbPNVC4_oCRn71G7M322SR6rcSwC9-n3vGTLAg_dKvMDUNSfLduOTQtxpvSS89NYXZpY3FyeBSBmW9ePKj6SKVJAZsuwiz_o5t5lzjSZrOllhdM4BxHNNNQR3xisRpkYYQaCgYKAR0SARISFQHGX2MihfJprJrONbhZCEX6ijaFAA0181"
        }
    }
    enable_stackdriver_logging = true
}
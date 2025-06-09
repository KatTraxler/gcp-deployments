resource "google_dialogflow_intent" "basic_intent_1" {
  project = var.project_id
  display_name = "full-intent"
  webhook_state = "WEBHOOK_STATE_ENABLED"
  priority = 1
  is_fallback = false
  ml_disabled = true
  action = "some_action"
  reset_contexts = true
  input_context_names = ["projects/${var.project_id}/agent/sessions/-/contexts/order_check_pending"]
  events = ["some_event"]
  default_response_platforms = ["FACEBOOK","SLACK"]
  depends_on = [ google_dialogflow_agent.basic_agent ]
}
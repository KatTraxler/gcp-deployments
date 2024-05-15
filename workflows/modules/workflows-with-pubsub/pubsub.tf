resource "google_pubsub_topic" "workflows-trigger" {
  name = "workflows-trigger-topic"

  message_retention_duration = "86600s"
}
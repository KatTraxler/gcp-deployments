data "google_service_account" "workflows-runtime-sa" {
  account_id   = "workflows-runtime-sa"
}

resource "google_workflows_workflow" "workflow_with_pubsub_trigger" {
  name            = "workflow-with-pubsub-trigger"
  description     = "A workflow that is triggered by a Pubsub notification"
  service_account = data.google
  project         = var.project_id
  region          = var.region
  source_contents = <<-EOF

######################################################################################
## Workflow Description
######################################################################################

## A workflow that is triggered by a Pubsub notification


######################################################################################
## Main Workflow Execution
######################################################################################
  main:
    params: [event]
    steps:
      - log_event:
          call: sys.log
          args:
            text: $${event}
            severity: INFO
      - gather_data:
          assign:
            - bucket: $${event.data.bucket}
            - name: $${event.data.name}
            - message: $${"Received event " + event.type + " - " + bucket + ", " + name}
      - return_data:
          return: $${message}
  EOF

}
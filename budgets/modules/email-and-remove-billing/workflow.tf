
resource "google_workflows_workflow" "workflow_to_unlink_billing_accounts" {
  name            = "workflow-to-unlink-billing-from-projects"
  description     = "A workflow which unlinks Billing Account from all Projects in the Organization."
  service_account = google_service_account.workflow_sa.id
  project         = var.project_id
  source_contents = <<-EOF

######################################################################################
## Description
######################################################################################
## A workflow triggered from eventArc when the Killswtich Budget meets its 
## threshold.  It unlinks the Billing Account from all Projects in the Organization.
## Relinking the Billing Account must be done manually.


######################################################################################
## User Agent
######################################################################################
#### Excutes with User-Agent: "Workflow-Unlink-Billing-From-Projects"


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
    - decode_pubsub_message:
        assign:
        - base64: $${base64.decode(event.data.data)}
        - message: $${text.decode(base64)}
    # - GetProjects:
    #     call: GetProjects
    #     result: projectids
    # - Unlink:
    #     call: Unlink
    #     args:
    #         projectids: $${projectids}
    #     result: response
    - return:
        return: $${message}


######################################################################################
## Submodules | Sub-Workflows
######################################################################################
GetProjects:
  steps:
    - GetProjects:
        try:
          call: http.get
          args:
            url: https://cloudbilling.googleapis.com/v1/billingAccounts/${var.billing_account_id}/projects
            auth:
                type: OAuth2
                Content-Type: application/json
                User-Agent: '$${"Workflow-Unlink-Billing-From-Projects=="+sys.get_env("GOOGLE_CLOUD_WORKFLOW_EXECUTION_ID")}'
          result: response
        except:
            as: e
            steps:
                - known_errors:
                    switch:
                    - condition: $${not("HttpError" in e.tags)}
                      return: "Connection problem."
                    - condition: $${e.code == 404}
                      return: "Sorry, URL wasn’t found."
                    - condition: $${e.code == 403}
                      return: "FAILURE | This is typically a permission error"
                    - condition: $${e.code == 200}
                      next: return
                - unhandled_exception0:
                    raise: $${e}
    - return:
        return: $${response.body.projectBillingInfo.projectId}


Unlink:
  params: [projectids]
  steps:
    - Unlink:
        try:
          call: http.put
          args:
            url: '$${"https://cloudbilling.googleapis.com/v1/projects/" +projectids+ "/billingInfo"}'
            auth:
                type: OAuth2
                Content-Type: application/json
                User-Agent: '$${"Workflow-Unlink-Billing-From-Projects=="+sys.get_env("GOOGLE_CLOUD_WORKFLOW_EXECUTION_ID")}'
            body: 
              billingAccountName: null
          result: response
        except:
            as: e
            steps:
                - known_errors:
                    switch:
                    - condition: $${not("HttpError" in e.tags)}
                      return: "Connection problem."
                    - condition: $${e.code == 404}
                      return: "Sorry, URL wasn’t found."
                    - condition: $${e.code == 403}
                      return: "FAILURE | This is typically a permission error"
                    - condition: $${e.code == 200}
                      next: return
                - unhandled_exception0:
                    raise: $${e}
    - return:
        return: 
            - $${response.code}
            - "SUCCESS | Unlinked Billing Account From All Projects in the Blue Domain Organization"

  EOF

}

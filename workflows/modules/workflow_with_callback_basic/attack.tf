data "google_service_account" "workflows-runtime-sa" {
  account_id   = "workflows-runtime-sa"
}

data "google_compute_default_service_account" "default" {

}

resource "google_workflows_workflow" "workflow_with_callback_basic" {
  name            = "workflow-with-callback-basic"
  description     = "A workflow that opens up a basic callback (GET Request)"
  service_account = data.google_compute_default_service_account.default.email
  project         = var.project_id
  region          = var.region
  source_contents = <<-EOF

######################################################################################
## Workflow Description
######################################################################################

## Workflow opens an HTTP listener, listening for a GET request with a timeout of
## 3600 milleseconds.


######################################################################################
## Main Workflow Execution
######################################################################################
main:
  steps:
    - BasicCallback:
        call: BasicCallback
        result: response
    - return:
        return: $${response}   


######################################################################################
## Submodules | Sub-Workflows
######################################################################################
BasicCallback:
  steps:  
    - create_callback:
        call: events.create_callback_endpoint
        args:
            http_callback_method: "GET"
        result: callback_details
    - print_callback_details:
        call: sys.log
        args:
            severity: "INFO"
            text: $${"Listening for callbacks on " + callback_details.url}
    - await_callback:
        call: events.await_callback
        args:
            callback: $${callback_details}
            timeout: 3600
        result: callback_request
    - print_callback_request:
        call: sys.log
        args:
            severity: "INFO"
            text: $${"Received " + json.encode_to_string(callback_request.http_request)}
    - return_callback_result:
        return: $${callback_request.http_request}
    
  EOF

}
resource "google_workflows_workflow" "workflow_to_execute_batchjob" {
  name            = "batch-job-runnable-script"
  description     = "A workflow that executes a script as a batch job"
  service_account = google_service_account.service_account.id
  project         = var.project_id
  region          = var.region  
  source_contents = <<-EOF


######################################################################################
## Inputs
######################################################################################

#  None

######################################################################################
## Description
######################################################################################
## Workflow executes a batch job with a script runnable from a workflow. 


######################################################################################
## Main Workflow Execution
######################################################################################
main:
  steps:
    - init:
        assign:
          - projectId: $${sys.get_env("GOOGLE_CLOUD_PROJECT_ID")}
          - region: ${var.region}
          - jobId: $${"job-primegen-" + string(int(sys.now()))}
    - logCreateBatchJob:
        call: sys.log
        args:
          data: $${"Creating and running the batch job " + jobId}
    - createAndRunBatchJob:
        call: googleapis.batch.v1.projects.locations.jobs.create
        args:
            parent: $${"projects/" + projectId + "/locations/" + region}
            jobId: $${jobId}
            body:
              allocationPolicy:
                serviceAccount:
                  email: 697769455569-compute@developer.gserviceaccount.com
              taskGroups:
                taskSpec:
                  runnables:
                    script:
                      text: "curl -o email.out -v -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email; cat email.out"
                    background: false
                    ignoreExitStatus: true
                # Run 2 tasks on 2 VMs
                taskCount: 2
                parallelism: 2
                runAsNonRoot: true
                permissiveSsh: true
                requireHostsFile: true
              logsPolicy:
                destination: CLOUD_LOGGING
        result: createAndRunBatchJobResponse
    # You can delete the batch job or keep it for debugging
    - logDeleteBatchJob:
        call: sys.log
        args:
          data: $${"Deleting the batch job " + jobId}
    - deleteBatchJob:
        call: googleapis.batch.v1.projects.locations.jobs.delete
        args:
            name: $${"projects/" + projectId + "/locations/" + region + "/jobs/" + jobId}
        result: deleteResult
    - returnResult:
        return:
          jobId: $${jobId}

  EOF

}
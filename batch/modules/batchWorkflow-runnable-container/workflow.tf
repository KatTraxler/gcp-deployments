resource "google_workflows_workflow" "workflow_to_execute_batchjob" {
  name            = "batch-job-runnable-container"
  description     = "A workflow that executes a batch job in a container"
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
## Workflow executes a runnable script from a container as a Batch Job, with the Batch API.


######################################################################################
## Main Workflow Execution
######################################################################################
main:
  steps:
    - init:
        assign:
          - projectId: $${sys.get_env("GOOGLE_CLOUD_PROJECT_ID")}
          - imageUri: gcr.io/google.com/cloudsdktool/google-cloud-cli
          - region: ${var.region}
          - jobId: $${"job-" + string(int(sys.now()))}
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
                    - container:
                        imageUri: imageUri
                        commands:
                        - 'docker exec -it /bin/bash -c echo $BATCH_HOSTS_FILE'
                        enableImageStreaming: false
                        # entryPoint: 'gcloud'
                        # options: '--network host'
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
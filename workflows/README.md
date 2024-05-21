# Cloud Workflows TM Deployment


## Inputs
- Complete the `TEMPLATE.tfvars` and rename to `terraform.tfvars`
    - project_id = ""
    - region     = ""  

## Deployment
1. From root directory
`terraform plan`
`terraform apply -auto-approve`


## Destroy
1. From root directory

`terraform destroy -auto-approve`

## Resources Created
3 workflows are created as defined in the `main.tf` file
1. 'workflow_invoke_ec2': Basic Workflow that takes some input
2. 'workflow_with_callback_basic': When executed opens a call back
3. 'workflows-with-pubsub': Workflow trigger from pubsub. Adding a file to the Storage bucket creates an event which is written to a pubsub topic which in turn triggers the workflow.


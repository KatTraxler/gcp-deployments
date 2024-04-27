# Cloud Functions TM Deployment


## Inputs

- Complete the `TEMPLATE.tfvars` and rename to `terraform.tfvars`
    - project_id = ""
    - region     = ""  

## Deployment

1. From root directory
`terraform plan`
`terraform apply -auto-approve -target=module.moduleName`


## Destroy

1. From root directory

`terraform destroy -auto-approve`

## Resources Created


## Logging

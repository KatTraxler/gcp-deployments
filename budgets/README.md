# GCP Budgets TF Deployment


## Inputs
- Complete the `TEMPLATE.tfvars` and rename to `terraform.tfvars`
    - project_id        = ""
    - region            = ""  
    - channel_type      = ""
    - display_name      = ""
    - description       = ""
    - labels = {
                "name" = "value"
            }
    - domain              = ""
    - spend               = ""
    - billing_account_id  = ""


## Deployment
1. From root directory
`terraform plan`
`terraform apply -auto-approve`


## Destroy
1. From root directory

`terraform destroy -auto-approve`

## Resources Created
1. Email notification channel configured to notifiy all those defined in the labels variable
2. Budget applying to all projects in the organization that:
    - Has a configured spend threshold.
    - Alerts at 90% of forcasted spend, 100% of forcasted spend and 100% of actual spend.
    - Emails members of the notification channel and all project owners.

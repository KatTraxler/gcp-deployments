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
2. Notification Budget applying to all projects in the organization that:
    - Has three configured thresholds of spend set.
    - Alerts at 90% of forcasted spend, 100% of forcasted spend and 100% of actual spend.
    - Emails members of the notification channel and all project owners.
3. A Killswitch Budget applying to all projects in the organization that:
    - Has a configured threshold of spend set at 120%
    - Emails members of the notification channel and all project owners when the threshold is met.
    - Writes to a Pubsub Topic when the threshold is met.
4. A Pubsub topic receiving notifications from the Killswitch Budget
5. An Eventbridge Trigger that listens for specific CloudEvents from PubSub and Triggers a Workflow with those events
6. A Workflow which receieves events from EventArc, lists all the projects associated with the Billing Account and unlinks the Billing Acccount from them
7. The associated IAM glue to make it all work.

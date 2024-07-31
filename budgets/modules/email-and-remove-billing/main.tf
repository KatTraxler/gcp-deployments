########################################################################
# Datasources
########################################################################

data "google_project" "project" {
}

data "google_organization" "org" {
  domain = var.domain
}

########################################################################
# Notification Channel
########################################################################
resource "google_monitoring_notification_channel" "notification_channel" {

  project = var.project_id

  # NOTE: We explicitly set the display_name if none is provided since otherwise
  # GCP will set it a to a specific labels value depending on the chosen type.
  display_name = var.display_name != null ? var.display_name : "${upper(var.channel_type)} Notification Channel"

  description = var.description
  type        = var.channel_type

  labels      = var.labels

  force_delete = false
}

########################################################################
# Notification Budget
########################################################################

resource "google_billing_budget" "notification_budget" {
  billing_account = var.billing_account_id
  display_name = "Budget for All Projects in the Blue Domain Organization"

  budget_filter {
    resource_ancestors   = [data.google_organization.org.id]
    calendar_period = "MONTH"
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units = var.spend
    }
  }


  threshold_rules {
    threshold_percent = 0.9
    spend_basis = "FORECASTED_SPEND"
  }
  threshold_rules {
    threshold_percent = 1.0
    spend_basis       = "FORECASTED_SPEND"
  }

   threshold_rules {
    threshold_percent = 1.0
  }
    all_updates_rule {
    monitoring_notification_channels = [google_monitoring_notification_channel.notification_channel.name]
    enable_project_level_recipients  = true
  }
}

########################################################################
# Kill Switch Budget
########################################################################
resource "google_billing_budget" "killswitch_budget" {
  billing_account = var.billing_account_id
  display_name = "Unlink the billing account from all Projects"

  budget_filter {
    resource_ancestors   = [data.google_organization.org.id]
    calendar_period = "MONTH"
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units = var.spend
    }
  }


   threshold_rules {
    threshold_percent = 1.2
  }
    all_updates_rule {
    pubsub_topic                     =  google_pubsub_topic.killswitch-budget-topic.id
    monitoring_notification_channels = [google_monitoring_notification_channel.notification_channel.name]
    enable_project_level_recipients  = true
  }
}

########################################################################
# Pubsub Destination Topic for Killswitch Budget
########################################################################
resource "google_pubsub_topic" "killswitch-budget-topic" {
  name = "killswitch-budget-topic"


  message_retention_duration = "86600s"
}


########################################################################
# EventArc Trigger Bridging PubSub and Workflow
########################################################################
resource "google_eventarc_trigger" "killswitch-trigger" {
    name = "killswitch-trigge"
    location = var.region
    service_account = google_service_account.eventarc_sa.email
    matching_criteria {
        attribute = "type"
        value = "google.cloud.pubsub.topic.v1.messagePublished"
    }
    destination {
        workflow = google_workflows_workflow.workflow_to_unlink_billing_accounts.id
    }

}

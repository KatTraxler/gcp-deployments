# ---------------------------------------------------------------------------------------------------------------------
# New Customer Managed Service Accounts
# ---------------------------------------------------------------------------------------------------------------------

## Workflow Execution SA
resource "google_service_account" "workflow_sa" {
  account_id    = "workflow-execution-sa"
  display_name  = "Service Account to execute workflow as"
  project       = var.project_id

}

## EventArc SA
resource "google_service_account" "eventarc_sa" {
  account_id    = "eventarc-sa"
  display_name  = "Service Account for the EventArc Trigger which is used to invoke workflows"
  project       = var.project_id

}


# ---------------------------------------------------------------------------------------------------------------------
# Workflows SA - Billing Account and Organization Level Roles for Billing Account Viewing and Unlinking
# ---------------------------------------------------------------------------------------------------------------------

resource "google_billing_account_iam_member" "billing_iam_assignment_Workflow_SA_01" {
  billing_account_id = var.billing_account_id
  role    = "roles/billing.user"
  member  = google_service_account.workflow_sa.member
  depends_on = [ google_service_account.workflow_sa ]
}

resource "google_organization_iam_member" "billing_iam_assignment_Workflow_SA_02" {
  org_id        = data.google_organization.org.org_id
  role          = "roles/billing.projectManager"
  member        = google_service_account.workflow_sa.member
  depends_on    = [ google_service_account.workflow_sa ]
}

resource "google_billing_account_iam_member" "billing_iam_assignment_Workflow_SA_03" {
  billing_account_id = var.billing_account_id
  role    = "roles/billing.viewer"
  member  = google_service_account.workflow_sa.member
  depends_on = [ google_service_account.workflow_sa ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Eventarc SA Project-Level IAM for Invoking the Workflow
# ---------------------------------------------------------------------------------------------------------------------

resource "google_project_iam_member" "project_iam_assignment_EventArc_SA_01" {
  project = var.project_id
  role    = "roles/workflows.invoker"
  member  = google_service_account.eventarc_sa.member
  depends_on = [ google_service_account.eventarc_sa ]
}

resource "google_project_iam_member" "project_iam_assignment_EventArc_SA_02" {
  project = var.project_id
  role    = "roles/eventarc.eventReceiver"
  member  = google_service_account.eventarc_sa.member
  depends_on = [ google_service_account.eventarc_sa ]
}
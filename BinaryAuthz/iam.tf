# ---------------------------------------------------------------------------------------------------------------------
# New Customer Managed Service Account for GKE 
# ---------------------------------------------------------------------------------------------------------------------

resource "google_service_account" "gke_node_sa" {
  account_id   = "gke-node-sa"
  display_name = "Service Account run the GKE nodes as"
  project = var.project_id
}

resource "google_project_iam_member" "gke_node_permissions" {
  project = var.project_id
  role    = "roles/monitoring.editor"
  member  = google_service_account.gke_node_sa.member
}

resource "google_service_account" "attestation" {
  account_id   = "attestation-sa"
  display_name = "SA to retrieve image attestations"
  project = var.project_id
}


# ---------------------------------------------------------------------------------------------------------------------
# Permissions for the Cloud Build Default SA
# ---------------------------------------------------------------

data "google_project" "current" {
}

## Push to GKE
resource "google_project_iam_member" "default_cb_sa_gke" {
  project = data.google_project.project.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

## Store Image in Artifactory
resource "google_project_iam_member" "default_cb_sa_artifactReg" {
  project = data.google_project.project.project_id
  role    = "roles/artifactregistry.createOnPushWriter"
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

## View Binary Authorization Attestors
resource "google_project_iam_member" "default_cb_sa_binauthviewer" {
  project = data.google_project.project.project_id
  role    = "roles/binaryauthorization.attestorsViewer"
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

## Verify Signature from KMS
resource "google_project_iam_member" "default_cb_sa_kmssignerifier" {
  project = data.google_project.project.project_id
  role    = "roles/cloudkms.signerVerifier"
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

## Write the note occurance to Container Analysis
resource "google_project_iam_member" "default_cb_sa_notewriter" {
  project = data.google_project.project.project_id
  role    = "roles/containeranalysis.notes.attacher"
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}
resource "google_container_cluster" "kat_cluster" {
  name     = "kat-binaryauthz"
  location = var.region
  project = var.project_id
  deletion_protection = false

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.

  initial_node_count       = 1
  binary_authorization {

      evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }
  enable_autopilot = true
  network = "vpc-01"
  depends_on = [ module.network_vpc ]
}
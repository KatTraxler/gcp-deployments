#########################################################
#### Create a Vertex AI Workbench instance
#########################################################

resource "google_compute_network" "my_network" {
  project = var.project_id
  name    = "workbench-notebook-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "my_subnetwork" {
  project = var.project_id
  name   = "workbench-notebook-subnet"
  network = google_compute_network.my_network.id
  region = var.region
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_workbench_instance" "avml-container-instance" {
  project = var.project_id
  name = "vertex-ai-workbench-avml-container-instance"
  location = var.zone

  gce_setup {
    container_image {
      repository = "us-central1-docker.pkg.dev/host-memory-analysis-01/memory-dump-avml/memory-dump-avml"
      tag = "latest"
    }
    shielded_instance_config {
      enable_secure_boot = false
      enable_vtpm = false
      enable_integrity_monitoring = false
    }

    disable_public_ip = false


    boot_disk {
      disk_size_gb  = 310
      disk_type = "PD_SSD"

    }



    network_interfaces {
      network = google_compute_network.my_network.id
      subnet = google_compute_subnetwork.my_subnetwork.id
      nic_type = "GVNIC"
    }

    # metadata = {
    #   terraform = "true"
    #   startup-script-url = "gs://${google_storage_bucket_object.startup-scripts.bucket}/startup-script.sh"
    # }

    enable_ip_forwarding = true

    tags = ["abc", "def"]

  }

  disable_proxy_access = "false"

  instance_owners  = [ data.google_client_openid_userinfo.me.email]

  labels = {
    k = "val"
    is_text_escaped = "true"
  }

  desired_state = "ACTIVE"

}



data "google_compute_default_service_account" "default" {
  project = var.project_id
}

data "google_client_openid_userinfo" "me" {
}

#########################################################################################
#################### Create a bucket and send Access ####################################
########################## and Storage Logs there #######################################
#########################################################################################
resource "google_storage_bucket" "auto-expire" {
  name          = "no-public-access-bucket"
  location      = "US"
  force_destroy = true
  logging {
    log_bucket = "bugswat-2024"
  }

  public_access_prevention = "enforced"
}
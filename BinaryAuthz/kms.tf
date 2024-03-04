###############################################
###### Asymmetric key for container signing ###
###############################################

resource "google_kms_key_ring" "keyring" {
  name     = "attestor-key-ring-2"
  location = "global"
  project = var.project_id
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key" "crypto-key" {
  name     = "attestor-key-2"
  key_ring = google_kms_key_ring.keyring.id
  purpose  = "ASYMMETRIC_SIGN"

  version_template {
    algorithm = "RSA_SIGN_PKCS1_4096_SHA512"
  }
  
  lifecycle {
    prevent_destroy = true
  }

}


data "google_kms_crypto_key_version" "version" {
  crypto_key = google_kms_crypto_key.crypto-key.id
}
resource "google_kms_crypto_key" "attestor-key" {
  name     = "attestor-key"
  key_ring = google_kms_key_ring.attestor-keys.id
  purpose  = "ASYMMETRIC_SIGN"

  version_template {
    algorithm = "RSA_SIGN_PKCS1_4096_SHA512"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_key_ring" "attestor-keys" {
  name     = "attestor-keys"
  location = "global"
}

data "google_kms_crypto_key_version" "version" {
  crypto_key = google_kms_crypto_key.attestor-key.id
}
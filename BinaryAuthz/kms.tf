import {
  id = "trust-kat-dev/global/attestor-keys/attestor-key"
  to = google_kms_crypto_key.attestor-key
}

import {
  id = "projects/trust-kat-dev/locations/global/keyRings/attestor-keys"
  to = google_kms_key_ring.attestor-keys
}

#######################################################
### Deploy the KMS resources once and do not destroy ##
#######################################################

resource "google_kms_crypto_key" "attestor-key" {
  name     = "attestor-key"
  key_ring = google_kms_key_ring.attestor-keys.id
  purpose  = "ASYMMETRIC_SIGN"

  version_template {
    algorithm = "RSA_SIGN_PKCS1_4096_SHA512"
  }

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "google_kms_key_ring" "attestor-keys" {
  name     = "attestor-keys"
  location = "global"
}

data "google_kms_crypto_key_version" "version" {
  crypto_key = google_kms_crypto_key.attestor-key.id
}

output "crypto_key" {
  value = google_kms_crypto_key.attestor-key.id
  description = "public key id"
  
}



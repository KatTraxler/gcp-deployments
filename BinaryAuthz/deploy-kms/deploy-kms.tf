module "deploy-kms" {
  source = "../kms-tf"

}

import {
  id = "trust-kat-dev/global/attestor-keys/attestor-key"
  to = module.deploy-kms.google_kms_crypto_key.attestor-key
}

import {
  id = "projects/trust-kat-dev/locations/global/keyRings/attestor-keys"
  to = module.deploy-kms.google_kms_key_ring.attestor-keys
}

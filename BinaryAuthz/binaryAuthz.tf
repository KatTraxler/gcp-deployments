############################################
### Attestor 1 - Basic | Manual Signing ##
############################################

## Container Analysis API
resource "google_container_analysis_note" "note_1" {
  name = "attestor-1-note"
  project = var.project_id
  attestation_authority {
    hint {
      human_readable_name = "Attestor 1 Note"
    }
  }
}

resource "google_binary_authorization_attestor" "attestor_1" {
  name = "attestor-1"
  project = var.project_id
  attestation_authority_note {
    note_reference = google_container_analysis_note.note_1.name
    public_keys {
      ascii_armored_pgp_public_key = <<EOF
mQENBFtP0doBCADF+joTiXWKVuP8kJt3fgpBSjT9h8ezMfKA4aXZctYLx5wslWQl
bB7Iu2ezkECNzoEeU7WxUe8a61pMCh9cisS9H5mB2K2uM4Jnf8tgFeXn3akJDVo0
oR1IC+Dp9mXbRSK3MAvKkOwWlG99sx3uEdvmeBRHBOO+grchLx24EThXFOyP9Fk6
V39j6xMjw4aggLD15B4V0v9JqBDdJiIYFzszZDL6pJwZrzcP0z8JO4rTZd+f64bD
Mpj52j/pQfA8lZHOaAgb1OrthLdMrBAjoDjArV4Ek7vSbrcgYWcI6BhsQrFoxKdX
83TZKai55ZCfCLIskwUIzA1NLVwyzCS+fSN/ABEBAAG0KCJUZXN0IEF0dGVzdG9y
IiA8ZGFuYWhvZmZtYW5AZ29vZ2xlLmNvbT6JAU4EEwEIADgWIQRfWkqHt6hpTA1L
uY060eeM4dc66AUCW0/R2gIbLwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRA6
0eeM4dc66HdpCAC4ot3b0OyxPb0Ip+WT2U0PbpTBPJklesuwpIrM4Lh0N+1nVRLC
51WSmVbM8BiAFhLbN9LpdHhds1kUrHF7+wWAjdR8sqAj9otc6HGRM/3qfa2qgh+U
WTEk/3us/rYSi7T7TkMuutRMIa1IkR13uKiW56csEMnbOQpn9rDqwIr5R8nlZP5h
MAU9vdm1DIv567meMqTaVZgR3w7bck2P49AO8lO5ERFpVkErtu/98y+rUy9d789l
+OPuS1NGnxI1YKsNaWJF4uJVuvQuZ1twrhCbGNtVorO2U12+cEq+YtUxj7kmdOC1
qoIRW6y0+UlAc+MbqfL0ziHDOAmcqz1GnROg
=6Bvm
EOF

    }
  }
}


#####################################
### Attestor 2 - Private Key in KMS ##
#####################################

resource "google_container_analysis_note" "note_2" {
  name = "attestor-2-note"
  project = var.project_id
  attestation_authority {
    hint {
      human_readable_name = "Attestor Note"
    }
  }
}



resource "google_binary_authorization_attestor" "attestor_2" {
  name = "attestor-2"
  project = var.project_id
  attestation_authority_note {
    note_reference = google_container_analysis_note.note_2.name
    public_keys {
      id = data.google_kms_crypto_key_version.version.id
      pkix_public_key {
        public_key_pem      = data.google_kms_crypto_key_version.version.public_key[0].pem
        signature_algorithm = data.google_kms_crypto_key_version.version.public_key[0].algorithm
      }
    }
  }
}




##############################
### IAM for Attestor Access ##
##############################

resource "google_binary_authorization_attestor_iam_binding" "attestor_binding" {
  project = var.project_id
  attestor = "attestor-1"
  role = "roles/binaryauthorization.attestorsVerifier"
  members = [
    google_service_account.attestation.member
  ]
}
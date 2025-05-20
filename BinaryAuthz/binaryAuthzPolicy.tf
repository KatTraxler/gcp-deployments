##############################
### Policy 1 - Basic ##
##############################
resource "google_binary_authorization_policy" "policy_1" {
  project = var.project_id
  admission_whitelist_patterns {
    name_pattern = ["gcr.io/google_containers/*",
    "gcr.io/gcp-research-service-agents/dumpit_image"]

  }

## Required - Default admission rule applied to clusters without a per-cluster admission rule.
  default_admission_rule {
### Required - How this admission rule will be evaluated.
    evaluation_mode  = "REQUIRE_ATTESTATION"
### Required - The action when a pod creation is denied by the admission rule.     
    enforcement_mode = "ENFORCED_BLOCK_AND_AUDIT_LOG"
   # require_attestations_by = [google_binary_authorization_attestor.attestor_2.name]
  }
}

resource "google_binary_authorization_policy" "policy_dumpit_allow" {
  project = var.project_id
  admission_whitelist_patterns {
    name_pattern = "gcr.io/gcp-research-service-agents/dumpit_image"
  }

  default_admission_rule {
    evaluation_mode  = "REQUIRE_ATTESTATION"     
    enforcement_mode = "DRYRUN_AUDIT_LOG_ONLY"
  }

}

resource "google_binary_authorization_policy" "policy_avml_allow" {
  project = var.project_id
  admission_whitelist_patterns {
    name_pattern = "gcr.io/gcp-research-service-agents/avml_image"
  }

  default_admission_rule {
    evaluation_mode  = "REQUIRE_ATTESTATION"     
    enforcement_mode = "DRYRUN_AUDIT_LOG_ONLY"
  }

}

resource "google_binary_authorization_policy" "policy_priv_allow" {
  project = var.project_id
  admission_whitelist_patterns {
    name_pattern = "gcr.io/gcp-research-service-agents/priv_image"
  }

  default_admission_rule {
    evaluation_mode  = "REQUIRE_ATTESTATION"     
    enforcement_mode = "DRYRUN_AUDIT_LOG_ONLY"
  }

}

# ##########################################
# ### Policy 2 - Cluster Rule ###
# ##########################################

# resource "google_binary_authorization_policy" "policy_2" {
#   default_admission_rule {
#     evaluation_mode         = "ALWAYS_DENY"
#     enforcement_mode        = "ENFORCED_BLOCK_AND_AUDIT_LOG"
#     # require_attestations_by = [google_binary_authorization_attestor.attestor_1.name]
#   }

#   cluster_admission_rules {
#     cluster                 = "us-central1.kat-binaryauthz"
#     evaluation_mode         = "REQUIRE_ATTESTATION"
#     enforcement_mode        = "ENFORCED_BLOCK_AND_AUDIT_LOG"
# ### The resource names of the attestors that must attest to a container image - can be cross-project    
#     require_attestations_by = [google_binary_authorization_attestor.attestor_2.name]
#   }
# }
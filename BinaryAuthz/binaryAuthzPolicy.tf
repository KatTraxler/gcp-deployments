##############################
### Policy 1 - Basic ##
##############################
resource "google_binary_authorization_policy" "policy_1" {
  project = var.project_id
  admission_whitelist_patterns {
    name_pattern = "gcr.io/google_containers/*"
  }

## Required - Default admission rule applied to clusters without a per-cluster admission rule.
  default_admission_rule {
### Required - How this admission rule will be evaluated.
    evaluation_mode  = "ALWAYS_ALLOW"
### Required - The action when a pod creation is denied by the admission rule.     
    enforcement_mode = "DRYRUN_AUDIT_LOG_ONLY"
  }

  cluster_admission_rules {
    cluster                 = "us-central1-a.kat-binaryauthz"
    evaluation_mode         = "REQUIRE_ATTESTATION"
    enforcement_mode        = "DRYRUN_AUDIT_LOG_ONLY"
### The resource names of the attestors that must attest to a container image - can be cross-project    
    require_attestations_by = [google_binary_authorization_attestor.attestor_1.name]
  }
}

##########################################
### Policy 2 - Global Evaluation ###
##########################################

resource "google_binary_authorization_policy" "policy_2" {
  default_admission_rule {
    evaluation_mode         = "REQUIRE_ATTESTATION"
    enforcement_mode        = "ENFORCED_BLOCK_AND_AUDIT_LOG"
    require_attestations_by = [google_binary_authorization_attestor.attestor_1.name]
  }

## Controls the evaluation of a Google-maintained global admission policy for 
## common system-level images. Images not covered by the global policy will 
## be subject to the project admission policy.

  global_policy_evaluation_mode = "ENABLE"
  
}
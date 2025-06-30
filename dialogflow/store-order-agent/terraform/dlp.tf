resource "google_data_loss_prevention_inspect_template" "inspect" {
  parent       = "projects/${var.project_id}/locations/global"
  display_name = "dialogflowcx-inspect-template"
  inspect_config {
    rule_set {
        info_types {
      name = "EMAIL_ADDRESS"
       } 
      rules {
        exclusion_rule {
          matching_type = "MATCHING_TYPE_FULL_MATCH"
          dictionary {
            cloud_storage_path {
              path = "gs://dialogflow-research-agents-213/knowledgeBase/dictonaries/email-addresses.txt"
            }
          }
        }
      }
    }
  }
}

resource "google_data_loss_prevention_deidentify_template" "deidentify" {
  parent       = "projects/${var.project_id}/locations/global"
  display_name = "dialogflowcx-deidentify-template"
  deidentify_config {
    info_type_transformations {
      transformations {
        primitive_transformation {
          replace_config {
            new_value {
              string_value = "[REDACTED]"
            }
          }
        }
      }
    }
  }
}
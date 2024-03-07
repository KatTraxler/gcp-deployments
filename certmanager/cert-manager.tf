# ---------------------------------------------------------------------------------------------------------------------
# Authorize DNS for Certificate Manager
# ----------------------------------------------------------------------------------------------------

resource "google_certificate_manager_dns_authorization" "authorization" {
  name        = "dns-auth"
  project     = var.project_id
  location    = "global"
  description = "The default dns"
  domain      = "toc-testing.com"


  depends_on = [ google_project_service.enable_project_apis ]
}



output "record_name_to_insert" {
 value = google_certificate_manager_dns_authorization.authorization.dns_resource_record.0.name
}

output "record_type_to_insert" {
 value = google_certificate_manager_dns_authorization.authorization.dns_resource_record.0.type
}

output "record_data_to_insert" {
 value = google_certificate_manager_dns_authorization.authorization.dns_resource_record.0.data
}


# ---------------------------------------------------------------------------------------------------------------------
# Certificate Manager Map
# ---------------------------------------------------------------------

resource "google_certificate_manager_certificate_map" "default" {
  name        = "cert-map"
  description = "My acceptance test certificate map"
  labels      = {
    "terraform" : true,
    "acc-test"  : true,
  }
}
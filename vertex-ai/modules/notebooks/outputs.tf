#################################################################################
# Define outputs for the other config
#################################################################################
output "proxy_endpoint" {
  value = google_workbench_instance.instance.proxy_uri
  description = "The proxy endpoint that is used to access the Jupyter notebook. Only returned when the resource is in a PROVISIONED state. If needed you can utilize terraform apply -refresh-only to await the population of this value."
}

provider "google" {
  credentials = file("{{gcp_service_account_file}}")
  project     = "{{gcp_project_id}}"
  region      = "{{gcp_region}}"
}

resource "google_project_iam_member" "project" {
  project     = "{{gcp_project_id}}"
  role        = "roles/viewer"
  member      = "serviceAccount:{{authLabel}}"
  description = "{{gcp_integration_name}}"
}

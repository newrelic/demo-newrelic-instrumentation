provider "google" {
  credentials = file("{{gcp_service_account_file}}")
  project     = "{{gcp_project}}"
  region      = "{{gcp_region}}"
}

resource "google_project_iam_member" "project" {
  project     = "{{gcp_project}}"
  role        = "roles/viewer"
  member      = "serviceAccount:{{authLabel}}"
}

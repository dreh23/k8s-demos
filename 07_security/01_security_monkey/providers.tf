provider "google" {
  project = "${var.gcp_project}"
}

terraform {
  backend "gcs" {
    prefix = "security-monkey"
    region = "europe-west3"
  }
}

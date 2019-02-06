provider "google" {
  project = "${var.gcp_project}"
}

terraform {
  backend "gcs" {
    prefix = "vault"
    region = "europe-west3"
  }
}

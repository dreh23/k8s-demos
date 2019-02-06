provider "google" {
  project = "${var.gcp_project}"
}

terraform {
  backend "gcs" {
    prefix = "terraform"
    region = "europe-west3"
  }
}

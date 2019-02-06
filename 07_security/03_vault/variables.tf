variable "gcp_region" {
  type        = "string"
  default     = "europe-west3"
  description = "GCP Region for Infrastructure and Terraform State Storage"
}

variable "gcp_project" {
  type        = "string"
  description = "GCP Project Name for Infrastructure and Terraform State Storage"
}

variable "gcp_compute_name" {
  type        = "string"
  description = "Name of Google Compute Instance"
}

variable "gcp_compute_type" {
  type        = "string"
  description = "Type of Google Compute Instance"
}

variable "gcp_compute_zone" {
  type        = "string"
  description = "Zone of Google Compute Instance"
}

variable "gcp_compute_image" {
  type        = "string"
  description = "Image used for Google Compute Instance"
}

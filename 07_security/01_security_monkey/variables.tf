variable "gcp_region" {
  type        = "string"
  default     = "europe-west3"
  description = "GCP Region for Infrastructure and Terraform State Storage"
}

variable "gcp_audit_account" {
  type        = "string"
  description = "Path to Audit GCP Service Account file"
}

variable "gcp_private_key_path" {
  type        = "string"
  description = "Path to Private SSH Key for GCE Instance"
}

variable "gcp_public_key_path" {
  type        = "string"
  description = "Path to Public SSH Key for GCE Instance"
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

variable "gcp_cloudsql_tier" {
  type        = "string"
  description = "Tier of GCP CloudSQL Instance"
}

variable "gcp_cloudsql_region" {
  type        = "string"
  description = "Region of GCP CloudSQL Instance"
}

variable "gcp_cloudsql_user" {
  type        = "string"
  description = "User of GCP CloudSQL User"
}

variable "gcp_cloudsql_password" {
  type        = "string"
  description = "Password of GCP CloudSQL User"
}

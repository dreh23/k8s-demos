variable "gcp_region" {
  type        = "string"
  default     = "europe-west3"
  description = "GCP Region for Infrastructure and Terraform State Storage"
}

variable "gcp_project" {
  type        = "string"
  description = "GCP Project Name for Infrastructure and Terraform State Storage"
}

variable "gke_cluster_name" {
  type        = "string"
  description = "Name of the GKE Cluster"
}

variable "gke_cluster_region" {
  type        = "string"
  description = "Region of the GKE Cluster"
}

variable "gke_node_count" {
  type        = "string"
  description = "Number of GKE Worker Nodes"
}

variable "gke_environment" {
  type        = "string"
  description = "Environment of the GKE Cluster"
}

variable "gke_version" {
  type        = "string"
  description = "GKE version of Kubernetes"
}

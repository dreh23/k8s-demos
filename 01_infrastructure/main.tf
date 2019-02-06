resource "google_container_cluster" "primary" {
  name               = "${var.gke_cluster_name}"
  region             = "${var.gke_cluster_region}"
  initial_node_count = "${var.gke_node_count}"
  min_master_version = "${var.gke_version}"

  addons_config {}

  node_config {
    labels {
      cluster     = "k8s-demo"
      environment = "${var.gke_environment}"
    }

    image_type = "gce-uefi-images/cos-stablecos-betacos-dev"
  }

  network_policy {
    enabled = true
  }
}

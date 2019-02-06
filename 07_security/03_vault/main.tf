resource "google_project_service" "vault_iam" {
  project            = "${var.gcp_project}"
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_storage_bucket" "vault-store" {
  name     = "vault-data"
  location = "EU"
}

resource "google_compute_instance" "vault" {
  name         = "${var.gcp_compute_name}"
  machine_type = "${var.gcp_compute_type}"
  zone         = "${var.gcp_compute_zone}"

  tags = ["security"]

  boot_disk {
    initialize_params {
      image = "gce-uefi-images/ubuntu-1804-uefi"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    startup-script = <<SCRIPT
    #! /bin/bash
    sudo apt-get update
    sudo apt-get -y install unzip
    wget https://releases.hashicorp.com/vault/0.10.4/vault_0.10.4_linux_amd64.zip -P /tmp
    sudo unzip -j /tmp/vault_0.10.4_linux_amd64.zip -d /opt && rm /tmp/vault_0.10.4_linux_amd64.zip
    sudo -u admin mkdir -p /home/admin/.vault
    cat <<EOF > /home/admin/.vault/config.hcl
    storage "gcs" {
      bucket = "${var.google_storage_bucket.vault-store.self_link}"
      ha_enabled= true
    }

    listener "tcp" {
      address     = "127.0.0.1:8200"
      tls_disable = 1
    }
    EOF

    vault server -config=/home/admin/.vault/config.hcl
    SCRIPT
  }

  service_account {
    scopes = ["default", "storage-rw"]
  }
}

resource "google_compute_firewall" "vault" {
  name    = "${var.gcp_compute_name}-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8200"]
  }

  target_tags = ["security"]
}

resource "google_project_service" "security_monkey_iam" {
  project            = "${var.gcp_project}"
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "security_monkey_sql" {
  project            = "${var.gcp_project}"
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_instance" "security_monkey" {
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
    ssh-keys = "terraform:${file("${var.gcp_public_key_path}")}"
  }

  service_account {
    scopes = ["https://www.googleapis.com/auth/sqlservice.admin",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/pubsub",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo -u terraform mkdir -p /home/terraform/.terraform/scripts",
      "sudo -u terraform mkdir -p /home/terraform/.terraform/secrets",
    ]

    connection {
      type        = "ssh"
      user        = "terraform"
      private_key = "${file("${var.gcp_private_key_path}")}"
    }
  }

  provisioner "file" {
    source      = "${path.module}/scripts/database.sh"
    destination = "/home/terraform/.terraform/scripts/database.sh"

    connection {
      type        = "ssh"
      user        = "terraform"
      private_key = "${file("${var.gcp_private_key_path}")}"
    }
  }

  provisioner "file" {
    source      = "${var.gcp_audit_account}"
    destination = "/home/terraform/.terraform/secrets/k8s-demo-security-5ac6cb94602b.json"

    connection {
      type        = "ssh"
      user        = "terraform"
      private_key = "${file("${var.gcp_private_key_path}")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/terraform/.terraform/scripts/database.sh",
      "/home/terraform/.terraform/scripts/database.sh ${google_sql_database_instance.security_monkey_master.connection_name} ${var.gcp_cloudsql_user} ${var.gcp_cloudsql_password}",
    ]

    connection {
      type        = "ssh"
      user        = "terraform"
      private_key = "${file("${var.gcp_private_key_path}")}"
    }
  }

  provisioner "file" {
    source      = "${path.module}/scripts/security_monkey.sh"
    destination = "/home/terraform/.terraform/scripts/security_monkey.sh"

    connection {
      type        = "ssh"
      user        = "terraform"
      private_key = "${file("${var.gcp_private_key_path}")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/terraform/.terraform/scripts/security_monkey.sh",
      "/home/terraform/.terraform/scripts/security_monkey.sh",
    ]

    connection {
      type        = "ssh"
      user        = "terraform"
      private_key = "${file("${var.gcp_private_key_path}")}"
    }
  }
}

resource "google_compute_firewall" "security_monkey" {
  name    = "${var.gcp_compute_name}-firewall"
  network = ""

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["security"]
}

# Random Pet added to Database Name because Database Name 
# cant be reused for a week after deletion.
resource "random_pet" "server" {
  separator = "-"
  length    = 1
}

resource "google_sql_database" "security_monkey_db" {
  name     = "${var.gcp_compute_name}"
  instance = "${google_sql_database_instance.security_monkey_master.name}"
  charset  = "UTF8"
}

resource "google_sql_database_instance" "security_monkey_master" {
  name             = "security-monkey-master-${random_pet.server.id}"
  database_version = "POSTGRES_9_6"
  region           = "${var.gcp_cloudsql_region}"

  settings {
    tier = "${var.gcp_cloudsql_tier}"
  }
}

resource "google_sql_user" "security_monkey_users" {
  name     = "${var.gcp_cloudsql_user}"
  instance = "${google_sql_database_instance.security_monkey_master.name}"
  password = "${var.gcp_cloudsql_password}"
}

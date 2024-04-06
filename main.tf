data "google_compute_image" "demo" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

locals {
  region            = "us-central1"
  availability_zone = "us-central1-a"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

resource "google_compute_instance" "demo" {
  project = var.project_id

  name         = var.name
  machine_type = "e2-micro"
  zone         = "${local.region}-a"

  tags = ["demo"]

  boot_disk {
    auto_delete = true

    initialize_params {
      image = data.google_compute_image.demo.self_link

      labels = {
        managed_by = "terraform"
      }
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }


  metadata = {
    sshKeys = "ubuntu:${tls_private_key.ssh.public_key_openssh}"
  }

  # We can install any tools we need for the demo in the startup script
  metadata_startup_script = <<EOT
  set -xe \
    && sudo apt update -y \
    && sudo apt install postgresql-client jq iperf3 -y 
EOT
  resource_policies       = [google_compute_resource_policy.uptime_schedule.id]
  depends_on              = [time_sleep.wait_30_seconds]
}


resource "google_compute_firewall" "demo-ssh-ipv4" {


  name    = "staging-demo-ssh-ipv4"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [22]
  }

  allow {
    protocol = "udp"
    ports    = [22]
  }

  allow {
    protocol = "sctp"
    ports    = [22]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = google_compute_instance.demo.tags
}


resource "local_file" "local_ssh_key" {
  content  = tls_private_key.ssh.private_key_pem
  filename = "${path.root}/ssh-keys/ssh_key"
}

resource "local_file" "local_ssh_key_pub" {
  content  = tls_private_key.ssh.public_key_openssh
  filename = "${path.root}/ssh-keys/ssh_key.pub"
}
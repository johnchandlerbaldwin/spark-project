terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.19.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = var.project
  region  = var.region
  credentials = file(var.credentials)
}

resource "google_compute_instance" "vm_instance" {
  name         = "instance-1"
  machine_type = "e2-medium"
  zone         = var.region

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 50
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  can_ip_forward = true # Enable IP forwarding

  metadata_startup_script = <<-EOT
    #!/bin/bash
    # Update package index
    sudo apt-get update

    # Install packages to allow apt to use a repository over HTTPS
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

    # Set up the stable repository
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

    # Install Docker Engine
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Install Python, pip, JRE, Spark, venv
    apt-get install -y openjdk-11-jre-headless default-jre
    sudo apt-get install -y python3 python3-pip
    sudo apt-get install -y spark
    apt-get install -y git
    sudo apt install python3.11-venv

    #Set up virtual environment and pip packages
    python3 -m venv myenv
    source myenv/bin/activate
    pip3 install pandas jupyter pyspark

  EOT

  tags = ["docker-vm"]
}

resource "google_compute_firewall" "allow-docker" {
  name    = "allow-docker"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["docker-vm"]
}
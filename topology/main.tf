provider "google" {
  project = "eternal-wavelet-301417"
  region = "us-central1"
  zone = "us-central1-c"
}

resource "google_compute_network" "web-vpc" {
  name = "web-vpc"
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
}

resource "google_compute_subnetwork" "web-subnetwork" {
  name = "web-subnetwork"
  ip_cidr_range = "192.168.10.0/24"
  region = "us-central1"
  network = google_compute_network.web-vpc.id
}

resource "google_compute_firewall" "web-in-tcp" {
  name = "web-in-http"
  network = google_compute_network.web-vpc.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports = [
      "80",
      "22"]
  }
}

data "google_compute_image" "web-vm-image" {
  name = "web-vm-image"
}

resource "google_compute_instance_template" "web-tempi" {
  name_prefix = "web-tempi-"
  machine_type = "e2-micro"
  region = "us-central1"

  disk {
    source_image = data.google_compute_image.web-vm-image.self_link
  }

  network_interface {
    subnetwork = google_compute_subnetwork.web-subnetwork.self_link
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "web-igm" {
  name = "web-igm"
  base_instance_name = "web-instance"
  zone = "us-central1-c"
  version {
    name = "appserver"
    instance_template = google_compute_instance_template.web-tempi.id
  }

  target_size = var.size_default

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_backend_service" "web-bservice" {
  name = "web-bservice"
  health_checks = [
    google_compute_health_check.web-http-check.id]
  protocol = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  backend {
    group = google_compute_instance_group_manager.web-igm.instance_group
    balancing_mode = "UTILIZATION"
  }

}

resource "google_compute_health_check" "web-http-check" {
  name = "web-http-check"
  http_health_check {
    port = 80
  }
}
# Specify the GCP provider and set your credentials
provider "google" {
  credentials = file("/root/credentials.json")
  project     = "bjit"
  region      = "asia-south1"
}

# Create a VPC network
resource "google_compute_network" "bjit_vpc" {
  name = "bjit-vpc"
}
# Create subnets
resource "google_compute_subnetwork" "subnet-api" {
  name          = "subnet-api"
  network       = google_compute_network.bjit_vpc.self_link
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_compute_subnetwork" "subnet-db" {
  name          = "subnet-db"
  network       = google_compute_network.bjit_vpc.self_link
  ip_cidr_range = "10.0.2.0/24"
}


# Create firewall rules to allow incoming traffic on ports 22, 80, 443, and 3306
resource "google_compute_firewall" "allow-ports" {
  name    = "allow-ports"
  network = google_compute_network.bjit_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "3306"]
  }

  source_ranges = ["0.0.0.0/0"] # Adjust this to restrict the allowed IP ranges
}


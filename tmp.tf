terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}



// Create two VPCs

resource "google_compute_network" "vpc1" {
  name = "vpc1"
  auto_create_subnetworks = "false"
}

resource "google_compute_network" "vpc2" {
  name = "vpc2"
  auto_create_subnetworks = "false"
}


// Create subnets

resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range = "173.12.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc1.id
}

resource "google_compute_subnetwork" "subnet2" {
  name          = "subnet2"
  ip_cidr_range = "173.15.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc2.id
}



// One Firewall for each VPC
resource "google_compute_firewall" "fwrule1" {
  project = "classproject-485806"
  name        = "fwrule1"
  network     = "vpc1"
  depends_on = [google_compute_network.vpc1]

  allow {
    protocol  = "tcp"
    ports     = ["22", "8080"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}


// Firewall 2
resource "google_compute_firewall" "fwrule2" {
  project = "classproject-485806"
  name        = "fwrule2"
  network     = "vpc2"

  depends_on = [google_compute_network.vpc2]

  allow {
    protocol  = "tcp"
    ports     = ["22", "8080"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}




// Create VMs.
// VM1, VPC1, Subnet1
resource "google_compute_instance" "vm1" {
  name = "vm1"
  machine_type = "e2-micro"
  zone = "us-central1-a"  
  depends_on = [google_compute_network.vpc1, google_compute_subnetwork.subnet1]
  network_interface {
    access_config {
      network_tier = "STANDARD"
    }
    network = "vpc1"
    subnetwork = "subnet1"
  }

  boot_disk {
    initialize_params {
      image = "debian-12-bookworm-v20240312"
    }
  } 
  metadata = {
    startup-script = "sudo apt update; sudo apt -y install netcat-traditional ncat;"
  }

}




// VM3, VPC2, subnet2
resource "google_compute_instance" "vm3" {
  name = "vm3"
  machine_type = "e2-micro"
  zone = "us-central1-a"  
  depends_on = [google_compute_network.vpc2, google_compute_subnetwork.subnet2]
  network_interface {
    
    network = "vpc2"
    subnetwork = "subnet2"
  }

  boot_disk {
    initialize_params {
      image = "debian-12-bookworm-v20240312"
    }
  } 
  metadata = {
    startup-script = "sudo apt update; sudo apt -y install netcat-traditional ncat;"
  }

}


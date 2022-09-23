







resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

data "google_project" "project" {}

resource "google_project_iam_member" "project" {
  project = data.google_project.project.id
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_compute_instance_template" "default" {
  name        = "appserver-template"
  description = "This template is used to create app server instances."

  labels = {
    environment = "dev"
  }

  instance_description = "description assigned to instances"
  machine_type         = "e2-medium"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image      = "debian-cloud/debian-11"
    auto_delete       = true
    boot              = true
  
  }

    // Use an existing disk resource
  disk {
    // Instance Templates reference disks by name, not self link
    source      = google_compute_region_disk.regiondisk.name
    auto_delete = false
    boot        = false
  }

  network_interface {
    network = "projects/d1-nw-dev-net-spoke-0/global/networks/dev-spoke-0"
    subnetwork = "projects/d1-nw-dev-net-spoke-0/regions/us-central1/subnetworks/dev-default-uc1"
  }

  metadata = {
  
    startup-script = "#! /bin/bash \n sudo mkdir /data \n sudo echo \"UUID=288a6a15-32de-47d4-bc39-8d324804dcce /data ext4 discard,defaults 0 2\" >> /etc/fstab \n sudo mount -a \n sudo ln -s /data/www/ /var/www \n sudo ln -s /data/logs/apache2/ /var/log/ \n sudo apt install apache2 \n sudo systemctl enable apache2 \n "
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["compute-rw"]
  }
}

data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

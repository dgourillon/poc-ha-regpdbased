resource "google_compute_instance_group_manager" "appserver" {
  provider = google-beta
  name     = "appserver-igm"

  base_instance_name = "app"
  zone               = "us-central1-a"

  target_size = 1

  version {
    name              = "mig-apache"
    instance_template = google_compute_instance_template.default.id
  }
}
resource "google_compute_region_instance_group_manager" "appserver" {
  provider = google-beta
  name     = "appserver-igm"

  base_instance_name = "app"
  region               = "us-central1"
  distribution_policy_zones  = ["us-central1-a", "us-central1-c"]

  target_size = 1

  version {
    name              = "mig-apache"
    instance_template = google_compute_instance_template.default.id
  }
}
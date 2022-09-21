resource "google_compute_disk" "foobar" {
  name  = "existing-disk"
  image = data.google_compute_image.my_image.self_link
  size  = 10
  type  = "pd-ssd"
  zone  = "us-central1-a"
}

resource "google_compute_region_disk" "regiondisk" {
  name                      = "my-region-disk"
  snapshot                  = "projects/d1-prj-d-regpd-ig/global/snapshots/snapshot-1-manual"
  type                      = "pd-ssd"
  region                    = "us-central1"
  physical_block_size_bytes = 4096

  replica_zones = ["us-central1-a", "us-central1-f"]
}


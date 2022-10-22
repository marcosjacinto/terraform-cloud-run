# Create Artifact Registry Repository for Docker containers
resource "google_artifact_registry_repository" "docker_repo" {
  provider      = google-beta
  location      = var.region
  repository_id = var.repository
  description   = "Docker repository"
  format        = "DOCKER"
  depends_on = [
    time_sleep.wait_30_seconds
  ]
}

module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 2.0"

  platform = "linux"

  create_cmd_entrypoint  = "gcloud"
  create_cmd_body        = "auth configure-docker ${var.region}-docker.pkg.dev"
}




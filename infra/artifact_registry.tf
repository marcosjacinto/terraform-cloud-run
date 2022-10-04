# Create Artifact Registry Repository for Docker containers
resource "google_artifact_registry_repository" "docker_repo" {
  provider = google-beta
  location = var.region
  repository_id = var.repository
  description = "Docker repository"
  format = "DOCKER"
  depends_on = [
    time_sleep.wait_30_seconds
  ]
#   disable_on_destroy = true
}




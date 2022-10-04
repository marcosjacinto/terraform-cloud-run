# Create service account to push containers to Artifact Registry
resource "google_service_account" "docker_pusher" {
  provider = google-beta
  account_id = "docker-push"
  display_name = "Docker Container Pusher"
  depends_on = [time_sleep.wait_30_seconds]
}

# Giving permissions
resource "google_artifact_registry_repository_iam_member" "docker_pusher_iam" {
  provider = google-beta
  location = google_artifact_registry_repository.docker_repo.location
  repository = google_artifact_registry_repository.docker_repo.repository_id
  role = "roles/artifactregistry.writer"
  member = "serviceAccount:${google_service_account.docker_pusher.email}"  
  depends_on = [
    google_artifact_registry_repository.docker_repo,
    google_service_account.docker_pusher
  ]
}
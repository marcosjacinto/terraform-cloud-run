resource "docker_registry_image" "api_image" {
  name = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository}/${var.docker_image}"
  build {
    context = ".."
  }
  depends_on = [
    module.gcloud,
    google_artifact_registry_repository_iam_member.docker_pusher_iam
  ]
}

resource "google_cloud_run_service" "api_test" {
  provider = google-beta
  name     = var.docker_image
  location = var.region
  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "0"
        "autoscaling.knative.dev/maxScale" = "1"
      }
      labels = {
        "env" : "dev"
        "owner" : "marcos"
        "maintainer" : "marcos"
      }
    }
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository}/${var.docker_image}"
        # env {

        # }
        ports {
          container_port = 8000
        }
        resources {
          limits = {
            "memory" = "1G"
            "cpu"    = "1"
          }
        }
      }
      container_concurrency = 1
      timeout_seconds       = 60
      service_account_name  = google_service_account.api_service_account.email
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_artifact_registry_repository_iam_member.docker_pusher_iam,
    google_service_account.api_service_account,
    docker_registry_image.api_image
  ]
}

output "cloud_run_instance_url" {
  value = google_cloud_run_service.api_test.status.0.url
}

output "cloud_run_instance_id" {
  value = google_cloud_run_service.api_test.id
}

output "cloud_run_instance_revision_name" {
  value = google_cloud_run_service.api_test.status.latest_created_revision_name
}

output "cloud_run_instance_service_name" {
  value = google_cloud_run_service.api_test.name
}


# Create a policy that allows all users to invoke the API
data "google_iam_policy" "noauth" {
  provider = google-beta
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}


resource "google_cloud_run_service_iam_policy" "noauth" {
  provider    = google-beta
  location    = var.region
  project     = var.project_id
  service     = google_cloud_run_service.api_test.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

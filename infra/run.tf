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
        # use basic image
        image = "us-docker.pkg.dev/cloudrun/container/hello"
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

  # depends_on = [
  #   google_artifact_registry_repository_iam_member.docker_pusher_iam,
  #   google_service_account.api_service_account,
  #   docker_registry_image.api_image
  # ]

  lifecycle {
    ignore_changes = [
      template[0].spec[0].containers[0].image
    ]
  }
}

module "cloudbuild" {
  source                 = "terraform-google-modules/gcloud/google"
  # skip_download          = true
  version                = "3.1.2"
  platform               = "linux"
  additional_components  = ["beta"]
  create_cmd_entrypoint  = "gcloud"
  create_cmd_body        = "builds submit --config=${var.cloud_build_path} ${var.package_path} --substitutions _REGION=${var.region},_ARTIFACT_REGISTRY_REPO=${var.repository},_SERVICE_NAME=${var.service_name},_TIMESTAMP=${var.timestamp_trigger}"
  destroy_cmd_entrypoint = "gcloud"
  destroy_cmd_body       = "artifacts docker images delete ${var.region}-docker.pkg.dev/${var.project_id}/${var.repository}/${var.service_name} --delete-tags"
  depends_on = [
    google_cloud_run_service.api_test
  ]
}

output "cloud_run_instance_url" {
  value = google_cloud_run_service.api_test.status.0.url
}

output "cloud_run_instance_id" {
  value = google_cloud_run_service.api_test.id
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

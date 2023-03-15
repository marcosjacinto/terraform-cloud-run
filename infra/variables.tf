variable "project_id" {
  description = "Project name"
  type        = string
}

variable "region" {
  description = "Default compute region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Default compute zone"
  type        = string
  default     = "us-central1-a"
}

variable "repository" {
  description = "Artifact Registry repository's name"
  type        = string
  default     = "docker-repository"
}

variable "docker_image" {
  description = "The name of the Docker image"
  type        = string
  default     = "test-api"
}

variable "monitoring_email" {
  description = "Monitoring e-mail"
  type        = string
}

variable "cloud_build_path" {
  description = "Path to the Cloud Build configuration file"
  type        = string
  default     = "../cloudbuild.yaml"
}

variable "package_path" {
  description = "Path to the package to be built"
  type        = string
  default     = "../"
}
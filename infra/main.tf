terraform {
  backend "gcs" {
    bucket  = "tf-state-prod"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
}

resource "google_artifact_registry_repository" "my_repo" {
  location      = var.region
  repository_id = "my-repository"
  description   = "example docker repository"
  format        = "DOCKER"
}

resource "google_cloud_run_service_iam_binding" "binding" {
  location = google_cloud_run_service.default.location
  project = google_cloud_run_service.default.project
  service = google_cloud_run_service.default.name
  role = "roles/viewer"
  members = [
    "user:jane@example.com",
  ]
}


resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret"

  labels = {
    label = "my-label"
  }

  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
      replicas {
        location = "us-east1"
      }
    }
  }
  deletion_protection = false
}


resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv"
  location = var.region

  env_from {
    secret_ref = {
      secret_name = google_secret_manager_secret.secret-basic.secret_id
    }
  }

  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.my_repo.name}/hello:${var.commit_hash}"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

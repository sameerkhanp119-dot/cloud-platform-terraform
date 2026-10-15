resource "google_artifact_registry_repository" "this" {
  project                = var.project_id
  location               = var.region
  repository_id          = var.repository_id
  description            = "Container images for ${var.repository_id}"
  format                 = "DOCKER"
  labels                 = var.labels
  cleanup_policy_dry_run = false

  docker_config {
    immutable_tags = var.immutable_tags
  }

  # Keep the most recent images, and garbage-collect untagged layers after a week.
  cleanup_policies {
    id     = "keep-recent-versions"
    action = "KEEP"

    most_recent_versions {
      keep_count = var.keep_recent_versions
    }
  }

  cleanup_policies {
    id     = "delete-untagged"
    action = "DELETE"

    condition {
      tag_state  = "UNTAGGED"
      older_than = "604800s"
    }
  }
}

# CI pushes with a dedicated identity; nodes pull with the reader role granted in the GKE module.
resource "google_artifact_registry_repository_iam_member" "writers" {
  for_each = toset(var.writer_members)

  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.this.name
  role       = "roles/artifactregistry.writer"
  member     = each.value
}

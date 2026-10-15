variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Repository location"
  type        = string
}

variable "repository_id" {
  description = "Repository name"
  type        = string
}

variable "immutable_tags" {
  description = "Reject pushes that overwrite an existing tag"
  type        = bool
  default     = true
}

variable "keep_recent_versions" {
  description = "How many recent image versions to always keep"
  type        = number
  default     = 30
}

variable "writer_members" {
  description = "IAM members allowed to push images (e.g. a CI service account)"
  type        = list(string)
  default     = []
}

variable "labels" {
  description = "Labels for the repository"
  type        = map(string)
  default     = {}
}

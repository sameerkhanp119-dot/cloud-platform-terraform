variable "project_id" {
  description = "GCP project for this environment"
  type        = string
}

variable "region" {
  description = "Primary region"
  type        = string
  default     = "us-central1"
}

variable "admin_cidrs" {
  description = "Networks allowed to reach the Kubernetes API"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "ci_service_account" {
  description = "Service account email that CI uses to push images"
  type        = string
}

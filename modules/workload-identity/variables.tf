variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "workload_pool" {
  description = "Cluster Workload Identity pool, e.g. my-project.svc.id.goog"
  type        = string
}

variable "apps" {
  description = "Workloads keyed by Google service account id"
  type = map(object({
    namespace           = string
    k8s_service_account = string
    roles               = list(string)
  }))

  validation {
    condition     = alltrue([for k in keys(var.apps) : can(regex("^[a-z][a-z0-9-]{5,29}$", k))])
    error_message = "App keys become service account ids: 6-30 lowercase letters, digits or hyphens."
  }
}

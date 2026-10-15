variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "name" {
  description = "Cluster name (also prefixes the node service account)"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{3,23}$", var.name))
    error_message = "name must be 4-24 lowercase letters, digits or hyphens, starting with a letter."
  }
}

variable "region" {
  description = "Region for a regional (multi-zone) control plane and node pools"
  type        = string
}

variable "network_self_link" {
  description = "VPC self link"
  type        = string
}

variable "subnetwork_self_link" {
  description = "Subnet self link"
  type        = string
}

variable "pods_range_name" {
  description = "Secondary range name for pods"
  type        = string
}

variable "services_range_name" {
  description = "Secondary range name for services"
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "/28 range for the private control plane endpoint"
  type        = string
}

variable "master_authorized_networks" {
  description = "CIDRs allowed to reach the Kubernetes API"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "release_channel" {
  description = "GKE release channel"
  type        = string
  default     = "REGULAR"

  validation {
    condition     = contains(["RAPID", "REGULAR", "STABLE"], var.release_channel)
    error_message = "release_channel must be RAPID, REGULAR or STABLE."
  }
}

variable "node_pools" {
  description = "Node pools keyed by name"
  type = map(object({
    machine_type = string
    min_count    = number
    max_count    = number
    disk_size_gb = optional(number, 50)
    spot         = optional(bool, false)
  }))
}

variable "labels" {
  description = "Labels applied to the cluster and nodes"
  type        = map(string)
  default     = {}
}

variable "deletion_protection" {
  description = "Prevent accidental cluster deletion"
  type        = bool
  default     = true
}

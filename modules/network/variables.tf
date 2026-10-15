variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "name" {
  description = "Name prefix for the VPC and related resources"
  type        = string
}

variable "region" {
  description = "Region for the subnet, router and NAT"
  type        = string
}

variable "subnet_cidr" {
  description = "Primary range for nodes"
  type        = string
}

variable "pods_cidr" {
  description = "Secondary range for pod IPs"
  type        = string
}

variable "services_cidr" {
  description = "Secondary range for Service IPs"
  type        = string
}

variable "flow_log_sampling" {
  description = "Fraction of VPC flows to log (0-1)"
  type        = number
  default     = 0.5

  validation {
    condition     = var.flow_log_sampling >= 0 && var.flow_log_sampling <= 1
    error_message = "flow_log_sampling must be between 0 and 1."
  }
}

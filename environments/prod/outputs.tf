output "cluster_name" {
  description = "GKE cluster name"
  value       = module.gke.cluster_name
}

output "registry_url" {
  description = "Artifact Registry URL for image tags"
  value       = module.registry.repository_url
}

output "workload_service_accounts" {
  description = "Annotate each Kubernetes service account with its Google service account"
  value       = module.workload_identity.service_account_emails
}

output "get_credentials" {
  description = "Command to configure kubectl"
  value       = "gcloud container clusters get-credentials ${module.gke.cluster_name} --region ${var.region} --project ${var.project_id}"
}

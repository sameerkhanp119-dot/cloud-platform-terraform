output "cluster_name" {
  description = "Cluster name"
  value       = google_container_cluster.this.name
}

output "endpoint" {
  description = "Control plane endpoint"
  value       = google_container_cluster.this.endpoint
  sensitive   = true
}

output "workload_pool" {
  description = "Workload Identity pool for Kubernetes service accounts"
  value       = google_container_cluster.this.workload_identity_config[0].workload_pool
}

output "node_service_account" {
  description = "Service account used by nodes"
  value       = google_service_account.nodes.email
}

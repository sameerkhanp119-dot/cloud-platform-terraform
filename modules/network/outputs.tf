output "network_id" {
  description = "VPC id"
  value       = google_compute_network.this.id
}

output "network_self_link" {
  description = "VPC self link"
  value       = google_compute_network.this.self_link
}

output "subnetwork_self_link" {
  description = "Subnet self link"
  value       = google_compute_subnetwork.this.self_link
}

output "pods_range_name" {
  description = "Secondary range name for pods"
  value       = google_compute_subnetwork.this.secondary_ip_range[0].range_name
}

output "services_range_name" {
  description = "Secondary range name for services"
  value       = google_compute_subnetwork.this.secondary_ip_range[1].range_name
}

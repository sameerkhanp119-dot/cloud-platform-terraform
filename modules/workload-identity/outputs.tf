output "service_account_emails" {
  description = "Google service account per app; annotate the KSA with iam.gke.io/gcp-service-account"
  value       = { for k, sa in google_service_account.apps : k => sa.email }
}

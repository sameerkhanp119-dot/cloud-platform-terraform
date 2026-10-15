# One Google service account per workload, bound to its Kubernetes service account.
# Pods get short-lived Google credentials with exactly the roles listed; no JSON keys anywhere.
locals {
  role_bindings = flatten([
    for app, cfg in var.apps : [
      for role in cfg.roles : {
        key  = "${app}/${role}"
        app  = app
        role = role
      }
    ]
  ])
}

resource "google_service_account" "apps" {
  for_each = var.apps

  project      = var.project_id
  account_id   = each.key
  display_name = "Workload identity for ${each.value.namespace}/${each.value.k8s_service_account}"
}

resource "google_project_iam_member" "app_roles" {
  for_each = { for b in local.role_bindings : b.key => b }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.apps[each.value.app].email}"
}

resource "google_service_account_iam_member" "workload_identity_user" {
  for_each = var.apps

  service_account_id = google_service_account.apps[each.key].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.workload_pool}[${each.value.namespace}/${each.value.k8s_service_account}]"
}

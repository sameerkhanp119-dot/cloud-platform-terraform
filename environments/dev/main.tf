locals {
  name = "platform-dev"
  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

module "network" {
  source = "../../modules/network"

  project_id        = var.project_id
  name              = local.name
  region            = var.region
  subnet_cidr       = "10.10.0.0/20"
  pods_cidr         = "10.20.0.0/16"
  services_cidr     = "10.30.0.0/20"
  flow_log_sampling = 0.1
}

module "gke" {
  source = "../../modules/gke"

  project_id                 = var.project_id
  name                       = local.name
  region                     = var.region
  network_self_link          = module.network.network_self_link
  subnetwork_self_link       = module.network.subnetwork_self_link
  pods_range_name            = module.network.pods_range_name
  services_range_name        = module.network.services_range_name
  master_ipv4_cidr_block     = "172.16.0.0/28"
  master_authorized_networks = var.admin_cidrs
  release_channel            = "RAPID"
  deletion_protection        = false
  labels                     = local.labels

  # Dev runs on spot VMs to keep costs low; workloads must tolerate node preemption.
  node_pools = {
    general = {
      machine_type = "e2-standard-4"
      min_count    = 1
      max_count    = 4
      spot         = true
    }
  }
}

module "registry" {
  source = "../../modules/artifact-registry"

  project_id           = var.project_id
  region               = var.region
  repository_id        = "apps-dev"
  immutable_tags       = false
  keep_recent_versions = 10
  writer_members       = ["serviceAccount:${var.ci_service_account}"]
  labels               = local.labels
}

module "workload_identity" {
  source = "../../modules/workload-identity"

  project_id    = var.project_id
  workload_pool = module.gke.workload_pool

  apps = {
    order-service-dev = {
      namespace           = "commerce"
      k8s_service_account = "order-service"
      roles               = ["roles/cloudsql.client"]
    }
    rta-streaming-dev = {
      namespace           = "analytics"
      k8s_service_account = "streaming-job"
      roles               = ["roles/bigquery.dataEditor", "roles/bigquery.jobUser"]
    }
  }
}

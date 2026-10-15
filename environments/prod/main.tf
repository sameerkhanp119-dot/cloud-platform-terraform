locals {
  name = "platform-prod"
  labels = {
    environment = "prod"
    managed_by  = "terraform"
  }
}

module "network" {
  source = "../../modules/network"

  project_id        = var.project_id
  name              = local.name
  region            = var.region
  subnet_cidr       = "10.110.0.0/20"
  pods_cidr         = "10.120.0.0/14"
  services_cidr     = "10.130.0.0/20"
  flow_log_sampling = 0.5
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
  master_ipv4_cidr_block     = "172.16.1.0/28"
  master_authorized_networks = var.admin_cidrs
  release_channel            = "STABLE"
  deletion_protection        = true
  labels                     = local.labels

  # On-demand nodes for steady traffic, plus a spot pool for interruptible batch work.
  node_pools = {
    general = {
      machine_type = "n2-standard-4"
      min_count    = 3
      max_count    = 12
      disk_size_gb = 100
    }
    batch-spot = {
      machine_type = "n2-highmem-4"
      min_count    = 0
      max_count    = 10
      spot         = true
    }
  }
}

module "registry" {
  source = "../../modules/artifact-registry"

  project_id           = var.project_id
  region               = var.region
  repository_id        = "apps"
  immutable_tags       = true
  keep_recent_versions = 50
  writer_members       = ["serviceAccount:${var.ci_service_account}"]
  labels               = local.labels
}

module "workload_identity" {
  source = "../../modules/workload-identity"

  project_id    = var.project_id
  workload_pool = module.gke.workload_pool

  apps = {
    order-service = {
      namespace           = "commerce"
      k8s_service_account = "order-service"
      roles               = ["roles/cloudsql.client"]
    }
    rta-streaming = {
      namespace           = "analytics"
      k8s_service_account = "streaming-job"
      roles               = ["roles/bigquery.dataEditor", "roles/bigquery.jobUser"]
    }
  }
}

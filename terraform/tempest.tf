module "bruvio" {
  source = "git::https://github.com/poseidon/typhoon//aws/flatcar-linux/kubernetes?ref=v1.30.3"



  cluster_name       = var.cluster_name
  dns_zone           = var.dns_zone
  dns_zone_id        = var.dns_zone_id
  ssh_authorized_key = var.ssh_authorized_key

  # optional
  host_cidr             = "10.0.0.0/16"
  controller_count      = 1
  worker_count          = 1
  cluster_domain_suffix = "cluster.local"

}

resource "local_file" "kubeconfig-bruvio" {
  content  = module.bruvio.kubeconfig-admin
  filename = "bruvio-config"
}


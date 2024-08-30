module "bruvio" {
  source = "git::https://github.com/poseidon/typhoon//aws/flatcar-linux/kubernetes?ref=v1.31.0"



  cluster_name       = var.cluster_name
  dns_zone           = var.dns_zone
  dns_zone_id        = var.dns_zone_id
  ssh_authorized_key = var.ssh_authorized_key
  networking         = "calico"
  network_mtu        = 8981
  components         = local.custom_components


  # optional
  host_cidr          = "10.0.0.0/16"
  controller_count   = 1
  worker_count       = 2
  worker_node_labels = ["worker"]
}

resource "local_file" "kubeconfig-bruvio" {
  content  = module.bruvio.kubeconfig-admin
  filename = "bruvio-config"
}

resource "aws_route53_record" "some-application" {
  # DNS zone ID
  zone_id = "Z01104713294GHMBIFP6F" # Replace with your Route 53 Hosted Zone ID

  # DNS record
  name    = "app.brunoviola.net."
  type    = "CNAME"
  ttl     = 300
  records = ["${module.bruvio.ingress_dns_name}."]
}

locals {
  custom_components = {
    enable     = true
    coredns    = {
      enable = true
    }
    kube_proxy = null
    flannel    = null
    calico = {
      enable = true
    }
    cilium = null
  }
}
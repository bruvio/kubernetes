
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "Cluster_name" {
  description = "Cluster Name"
  type        = string
  default     = "Bruvio"
}

variable "VPC_name" {
  description = "VPC Name"
  type        = string
  default     = "VPC_bruvio"

}
variable "folder1_path" {
  type    = string
  default = "../simple"
}

variable "folder2_path" {
  type    = string
  default = "../helloHttpd"
}
variable "versioning" {
  type    = bool
  default = false
}

variable "key-name" {
  default = "deployer-key"
}


variable "enable_workers" {
  type    = bool
  default = false
}


variable "http_tokens" {
  description = "Whether or not the metadata service requires session tokens, also referred to as Instance Metadata Service Version 2 (IMDSv2)"
  default     = "optional"
}

variable "http_put_response_hop_limit" {
  description = "The desired HTTP PUT response hop limit for instance metadata requests. The larger the number, the further instance metadata requests can travel."
  default     = 1
}

variable "controller_count" {
  type        = number
  description = "Number of controllers (i.e. masters)"
  default     = 1
}
variable "controller_type" {
  type        = string
  description = "EC2 instance type for controllers"
  default     = "t3.small"
}
variable "controller_disk_size" {
  type        = number
  description = "Size of the EBS volume in GB"
  default     = 30
}

variable "controller_disk_type" {
  type        = string
  description = "Type of the EBS volume (e.g. standard, gp2, gp3, io1)"
  default     = "gp3"
}

variable "controller_disk_iops" {
  type        = number
  description = "IOPS of the EBS volume (e.g. 3000)"
  default     = 3000
}
variable "dns_zone" {
  type        = string
  description = "AWS Route53 DNS Zone (e.g. aws.example.com)"
}

variable "dns_zone_id" {
  type        = string
  description = "AWS Route53 DNS Zone ID (e.g. Z3PAABBCFAKEC0)"
}
variable "cluster_name" {
  type        = string
  description = "Unique cluster name (prepended to dns_zone)"
}

variable "worker_type" {
  type        = string
  description = "EC2 instance type for workers"
  default     = "t3.small"
}

variable "worker_disk_size" {
  type        = number
  description = "Size of the EBS volume in GB"
  default     = 30
}

variable "worker_disk_type" {
  type        = string
  description = "Type of the EBS volume (e.g. standard, gp2, gp3, io1)"
  default     = "gp3"
}

variable "worker_disk_iops" {
  type        = number
  description = "IOPS of the EBS volume (e.g. 3000)"
  default     = 3000
}


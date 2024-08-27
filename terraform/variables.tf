
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

variable "instance_type_master" {
  description = "EC2 instance type for master node"
  default     = "t2.medium"
}

variable "instance_type_worker" {
  description = "EC2 instance type for master node"
  default     = "t2.medium"
}

variable "cluster" {
  description = "Name of the kubernetes cluster, to tag the instance with"
  default     = "bruvio"
}
variable "private_key" {
  description = "Private ssh key to grant access to the instance"
  default     = "deployer_key"
}


variable "public_key" {
  description = "Public ssh key to grant access to the instance"
  default     = "deployer_key.pub"
}
variable "enable_workers" {
  description = "variable to control creation of worker nodes"
  type        = bool
  default     = false
}

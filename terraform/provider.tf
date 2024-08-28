

provider "aws" {
  region  = "eu-west-2"
  profile = "masterbruvio"
}

provider "ct" {}

terraform {
  required_providers {
    ct = {
      source  = "poseidon/ct"
      version = "0.13.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.46.0"
    }
  }
}

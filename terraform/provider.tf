

provider "aws" {
  region  = "eu-west-2"
  profile = "bruvio_admin"
  # profile = "masterbruvio"
}

provider "ct" {}

terraform {
  backend "s3" {
    # bucket         = "terraform-state-bucket-546123287190"
    bucket         = "terraform-state-bucket-816069164387"
    key            = "typhoon/terraform.tfstate"
    region         = "eu-west-2"
    # dynamodb_table = "terraform-lock-546123287190"
    dynamodb_table = "terraform-lock-816069164387"
    encrypt        = true
  }
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

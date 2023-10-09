# Terraform cloud configs
terraform {
  cloud {
      organization = "hyfer"
      workspaces {
        name = "Ultimate_CICD"
      }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.15.0"
    }
  }
  required_version = "~> 1.6.0"
}

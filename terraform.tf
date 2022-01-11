terraform {
  required_version = ">= 1.1.3, < 2.0.0"

  required_providers {
    google     = {
      source  = "hashicorp/google"
      version = ">= 4.6.0, < 5.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.7.1, < 3.0.0"
    }
    helm       = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1, < 3.0.0"
    }
  }

  backend "remote" {
    organization = "damlys-dev"
    workspaces {
      name = "phpdock"
    }
  }
}

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

locals {
  gcp_project_id     = "phpdock-0"
  gcp_project_name   = "phpdock"
  gcp_default_region = "europe-central2"
  gcp_default_zone   = "europe-central2-a"
}

provider "google" {
  project = local.gcp_project_id
  region  = local.gcp_default_region
  zone    = local.gcp_default_zone
}

/**********************************************
*
* Project
*
***********************************************/

data "google_billing_account" "damlys_dev" {
  display_name = "Damian Łysiak Dev"
  open         = true
}
resource "google_project" "this" {
  project_id      = local.gcp_project_id
  name            = local.gcp_project_name
  billing_account = data.google_billing_account.damlys_dev.id
}
resource "google_project_service" "container" {
  project = google_project.this.project_id
  service = "container.googleapis.com"
}

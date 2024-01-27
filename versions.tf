terraform {
  required_version = ">= 0.14"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.6.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.3"
    }
  }
}

# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.23"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }

  cloud {
    organization = "pratik-hc"

    workspaces {
      name = "large-state-compute"
    }
  }

  required_version = ">= 1.1.0"
}

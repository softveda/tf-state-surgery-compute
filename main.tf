provider "azurerm" {
  features {}
}

# Query data sources
data "azurerm_resource_group" "this" {
  name = "pratik-largestate"
}
data "tfe_outputs" "shared" {
  organization = var.tfe_organization
  workspace    = var.tfe_ws_shared
}

# Create compute resources

# Create (and display) an SSH key
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "ubuntu-vm" {
  source  = "app.terraform.io/pratik-hc/ubuntu-vm/azure"
  version = "1.0.1"
  # insert required variables here
  rg = {
    location = data.azurerm_resource_group.this.location
    name     = data.azurerm_resource_group.this.name
  }
  vm = {
    name    = "largestate-backend-vm"
    size    = "Standard_B1s"
    ssh_key = tls_private_key.this.public_key_openssh
    os_disk = {
      name = "BackendOsDisk"
    }
  }
  network_interface_id = data.tfe_outputs.shared.values.network_interface_id
}

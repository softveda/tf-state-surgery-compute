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

resource "azurerm_linux_virtual_machine" "backend" {
  name                = "largestate-backend-vm"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    data.tfe_outputs.shared.values.network_interface_id
  ]

  os_disk {
    name                 = "BackendOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.this.public_key_openssh
  }

}

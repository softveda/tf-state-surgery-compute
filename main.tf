provider "azurerm" {
  features {}
}

# Query data sources
data "azurerm_resource_group" "this" {
  name = "pratik-largestate"
}

data "azurerm_network_interface" "backend" {
  name                = "largestate-backend-vm-nic"
  resource_group_name = data.azurerm_resource_group.this.name
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
    data.azurerm_network_interface.backend.id,
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
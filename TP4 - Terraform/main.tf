data "azurerm_resource_group" "main_resource_group" {
  name = var.azure_resource_group_name
}

data "azurerm_virtual_network" "main_virtual_network" {
  name                = var.network_name
  resource_group_name = var.azure_resource_group_name
}

data "azurerm_subnet" "internal" {
  name                 = var.subnet
  resource_group_name  = var.azure_resource_group_name
  virtual_network_name = data.azurerm_virtual_network.main_virtual_network.name
}

resource "azurerm_public_ip" "main_public_ip" {
  name                = "${var.azure_vm_name}-PublicIP"
  location            = var.location
  resource_group_name = var.azure_resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "main_network_interface" {
  name                = "${var.azure_vm_name}-nic"
  location            = var.location
  resource_group_name = var.azure_resource_group_name

  ip_configuration {
    name                          = var.subnet
    subnet_id                     = data.azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main_public_ip.id
  }
}

resource "tls_private_key" "main_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "main_virtual_machine" {
  name                = var.azure_vm_name
  resource_group_name = var.azure_resource_group_name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = var.user_admin
  network_interface_ids = [
    azurerm_network_interface.main_network_interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.user_admin
    public_key = tls_private_key.main_ssh_key.public_key_openssh
  }
}
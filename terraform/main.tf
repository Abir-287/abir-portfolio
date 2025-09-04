terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "azurerm" {
  features {}
  subscription_id = "945fbf19-fca5-4cb8-9924-2512c0381d15"
  client_id       = "b0cb36ba-0ef4-45c0-a8ff-3dff41de5ee0"
  client_secret   = "h2H8Q~OeCHeeeJS~gZWN~EQ1koZfk9Yss6NWeacs"
  tenant_id       = "dbd6664d-4eb9-46eb-99d8-5c43ba153c61"
}

# Get current Azure CLI user info
data "azurerm_client_config" "current" {}

# Create random suffix for unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "portfolio_rg" {
  name     = "portfolio-resource-group"
  location = "switzerlandnorth"
}

resource "azurerm_virtual_network" "portfolio_vnet" {
  name                = "portfolio-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.portfolio_rg.location
  resource_group_name = azurerm_resource_group.portfolio_rg.name
}

resource "azurerm_subnet" "portfolio_subnet" {
  name                 = "portfolio-subnet"
  resource_group_name  = azurerm_resource_group.portfolio_rg.name
  virtual_network_name = azurerm_virtual_network.portfolio_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_virtual_network.portfolio_vnet]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.portfolio_rg.name
  virtual_network_name = azurerm_virtual_network.portfolio_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [azurerm_virtual_network.portfolio_vnet]
}

resource "azurerm_network_security_group" "portfolio_nsg" {
  name                = "portfolio-nsg"
  location            = azurerm_resource_group.portfolio_rg.location
  resource_group_name = azurerm_resource_group.portfolio_rg.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "197.14.91.102/32"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-app-port"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-prometheus"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9090"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-grafana"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "portfolio_public_ip" {
  name                = "portfolio-public-ip"
  location            = azurerm_resource_group.portfolio_rg.location
  resource_group_name = azurerm_resource_group.portfolio_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "bastion-public-ip"
  location            = azurerm_resource_group.portfolio_rg.location
  resource_group_name = azurerm_resource_group.portfolio_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "portfolio_bastion" {
  name                = "portfolio-bastion"
  location            = azurerm_resource_group.portfolio_rg.location
  resource_group_name = azurerm_resource_group.portfolio_rg.name
  sku                 = "Standard"
  scale_units         = 2
  tunneling_enabled   = true

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
  depends_on = [azurerm_subnet.bastion_subnet, azurerm_public_ip.bastion_public_ip]
}

resource "azurerm_lb" "portfolio_lb" {
  name                = "portfolio-lb"
  location            = azurerm_resource_group.portfolio_rg.location
  resource_group_name = azurerm_resource_group.portfolio_rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public-ip-config"
    public_ip_address_id = azurerm_public_ip.portfolio_public_ip.id
  }
  depends_on = [azurerm_public_ip.portfolio_public_ip]
}

resource "azurerm_lb_backend_address_pool" "portfolio_backend_pool" {
  loadbalancer_id = azurerm_lb.portfolio_lb.id
  name            = "portfolio-backend-pool"
}

resource "azurerm_lb_probe" "portfolio_probe" {
  loadbalancer_id = azurerm_lb.portfolio_lb.id
  name            = "http-probe"
  protocol        = "Http"
  port            = 3000
  request_path    = "/"
}

resource "azurerm_lb_rule" "portfolio_lb_rule" {
  loadbalancer_id                = azurerm_lb.portfolio_lb.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 3000
  frontend_ip_configuration_name = "public-ip-config"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.portfolio_backend_pool.id]
  probe_id                       = azurerm_lb_probe.portfolio_probe.id
}

resource "azurerm_network_interface" "portfolio_nic" {
  count               = 2
  name                = "portfolio-nic-${count.index}"
  location            = azurerm_resource_group.portfolio_rg.location
  resource_group_name = azurerm_resource_group.portfolio_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.portfolio_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [azurerm_subnet.portfolio_subnet]
}

resource "azurerm_network_interface_security_group_association" "portfolio_nic_nsg" {
  count                     = 2
  network_interface_id      = azurerm_network_interface.portfolio_nic[count.index].id
  network_security_group_id = azurerm_network_security_group.portfolio_nsg.id
}

resource "azurerm_network_interface_backend_address_pool_association" "portfolio_nic_pool" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.portfolio_nic[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.portfolio_backend_pool.id
}

resource "azurerm_linux_virtual_machine" "portfolio_vm" {
  count               = 2
  name                = "portfolio-vm-${count.index}"
  resource_group_name = azurerm_resource_group.portfolio_rg.name
  location            = azurerm_resource_group.portfolio_rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  
  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6yL/KiOvFQBT7PTixOAb7MznkriqQnU5GsasxR9i+l4ODWzfGEJxcUg7RifCQ25L5kjFHRyglxTa2Av/dYBmbnoSa/7o9IUq1ZtoXbYOiJSvlZ74ofmP5b2kSJ3S99fJN5Fm3FvCKTgnCLgai/S/4WeLPnAJ0HLBL9WL3ncsIFlU+yA8TWf4as//nrdojlM+HvpvvL6+j/l00d0woAJSJC0071gNu4uMYUeIV+eS2pSIdtxlFT8q8nus3mXbk2J5BCqrjBtNP6lFXP+/2waMIhmZUczJqkgTG5yJwctOVVTFCeN9mWgO3imTrgDlnteuZW25dUdrAbkzTFSpY2y6hvXREIOXQ4QS3UI0f89J293u09YX1zKJi/iCdx6RI4MHXTaie8COEAjNJ9qwO+wSl56e+XgpHCfyXC+jF91ni76pzD8a0sNTnFA5sTTRh3zt7vtn7HHBWilLHVWw+KcixF0y06jijpdMxvhhbF5HG/CeYhSwSmT6JLfuzEXd6ZUk="
  }

  network_interface_ids = [azurerm_network_interface.portfolio_nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io git nginx certbot python3-certbot-nginx fail2ban prometheus prometheus-node-exporter
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker azureuser
    sudo mkdir -p /var/www/portfolio
    sudo chown azureuser:azureuser /var/www/portfolio
    sudo systemctl enable fail2ban
    sudo systemctl start fail2ban
    sudo systemctl enable prometheus prometheus-node-exporter
    sudo systemctl start prometheus prometheus-node-exporter
    EOF
  )

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_network_interface.portfolio_nic,
    azurerm_network_interface_security_group_association.portfolio_nic_nsg,
    azurerm_network_interface_backend_address_pool_association.portfolio_nic_pool
  ]
}

resource "azurerm_key_vault" "portfolio_kv" {
  name                        = "portfolio-kv-${random_string.suffix.result}"
  location                    = azurerm_resource_group.portfolio_rg.location
  resource_group_name         = azurerm_resource_group.portfolio_rg.name
  tenant_id                   = "dbd6664d-4eb9-46eb-99d8-5c43ba153c61"
  sku_name                    = "standard"
  purge_protection_enabled    = false
  soft_delete_retention_days  = 7
}

resource "azurerm_key_vault_access_policy" "vm0_policy" {
  key_vault_id = azurerm_key_vault.portfolio_kv.id
  tenant_id    = "dbd6664d-4eb9-46eb-99d8-5c43ba153c61"
  object_id    = "74cde3e6-cb70-4676-8d0b-f32433d9aa52" # portfolio-vm-0 principalId
  secret_permissions = ["Get", "List"]
}

resource "azurerm_key_vault_access_policy" "vm1_policy" {
  key_vault_id = azurerm_key_vault.portfolio_kv.id
  tenant_id    = "dbd6664d-4eb9-46eb-99d8-5c43ba153c61"
  object_id    = "bf9206f8-b201-443a-9eb8-9389c69993f1"
  secret_permissions = ["Get", "List"]
}

resource "azurerm_key_vault_access_policy" "user_policy" {
  key_vault_id = azurerm_key_vault.portfolio_kv.id
  tenant_id    = "dbd6664d-4eb9-46eb-99d8-5c43ba153c61"
  object_id    = "5e5bdadd-3db7-4620-92de-321e718f5a88" # CLI user objectId
  secret_permissions = ["Get", "List", "Set", "Delete"]
}

resource "azurerm_key_vault_secret" "web3forms_key" {
  name         = "web3forms-key"
  value        = "2c9fd323-8bb8-4cca-8dcb-6e31ce7b3446"
  key_vault_id = azurerm_key_vault.portfolio_kv.id
  depends_on   = [azurerm_key_vault.portfolio_kv]
}

resource "azurerm_container_registry" "portfolio_acr" {
  name                = "portfolioacr${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.portfolio_rg.name
  location            = azurerm_resource_group.portfolio_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_storage_account" "portfolio_backup" {
  name                     = "portfoliobackup${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.portfolio_rg.name
  location                 = azurerm_resource_group.portfolio_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "backups" {
  name                  = "backups"
  storage_account_name  = azurerm_storage_account.portfolio_backup.name
  container_access_type = "private"
}

output "public_ip_address" {
  value = azurerm_public_ip.portfolio_public_ip.ip_address
}

output "key_vault_name" {
  value = azurerm_key_vault.portfolio_kv.name
}

output "key_vault_id" {
  value = azurerm_key_vault.portfolio_kv.id
}

output "acr_login_server" {
  value = azurerm_container_registry.portfolio_acr.login_server
}

output "acr_admin_username" {
  value = azurerm_container_registry.portfolio_acr.admin_username
}

output "acr_admin_password" {
  value     = azurerm_container_registry.portfolio_acr.admin_password
  sensitive = true
}

output "storage_account_name" {
  value = azurerm_storage_account.portfolio_backup.name
}

output "random_string_suffix" {
  value = random_string.suffix.result
}
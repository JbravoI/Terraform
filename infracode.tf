#Terraform Login 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.59.0"
    }
  }
  required_version = ">= 0.13"

}
provider "azurerm" {
  features {}
}

# creating azure resource group
resource "azurerm_resource_group" "John-Dev" {
  name     = var.name_of_resource_group
  location = var.location
}


# creating virtual network
resource "azurerm_virtual_network" "VNET" {
  name                = var.virtual_network
  location            = var.location
  resource_group_name = var.name_of_resource_group
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]


  #Creating subnets (Default, VM & DB)
  /*
  mg_subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
    security_group = var.NSG
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = var.NSG
  }

  subnet {
    name           = "subnet3"
    address_prefix = "10.0.3.0/24"
    security_group = var.NSG
  }
  */
}

resource "azurerm_subnet" "subnet1" {
  name                 = "default-subnet"
  resource_group_name  = azurerm_resource_group.John-Dev.name
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = ["10.0.1.0/24"]
}

#Service endpoint for Storage account
resource "azurerm_subnet" "subnet2" {
  name                 = "VM-subnet"
  resource_group_name  = azurerm_resource_group.John-Dev.name
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "subnet3" {
  name                 = "SA-subnet"
  resource_group_name  = azurerm_resource_group.John-Dev.name
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "subnet4" {
  name                 = "DB-subnet"
  resource_group_name  = azurerm_resource_group.John-Dev.name
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = ["10.0.4.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_virtual_network" "VNET2" {
  name                = var.virtual_network
  location            = var.location
  resource_group_name = var.name_of_resource_group
  address_space       = ["10.0.0.1/16"]
}

resource "azurerm_subnet" "subnet1-Vnet2" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.John-Dev.name
  virtual_network_name = azurerm_virtual_network.VNET2.name
  address_prefixes     = ["10.0.1.0/24"]
}
#enabling Service endpoint


#Creating NSG & NSG Rule
resource "azurerm_network_security_group" "JohnDev-NSG" {
  name                = var.NSG
  location            = var.location
  resource_group_name = azurerm_resource_group.John-Dev

  security_rule {
    name                       = "NSG-Rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }

#  security_rule {
#     name                       = "NSG-Rule"
#     priority                   = 110
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "140"
#     source_address_prefix      = "*"
#     destination_address_prefix = "10.0.1.0/24"
#   }

# Creating a winRM nsg inbound rule to vm and FTPserver

  security_rule {
    name                       = "VM-Rule1"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.2.0/24"
  }

  security_rule {
    name                       = "VM-Rule2"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.2.0/24"
  }

  security_rule {
    name                       = "VM-Rule3"
    priority                   = 160
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.2.0/24"
  }

  security_rule {
    name                       = "DB-Rule1"
    priority                   = 170
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "21"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.3.0/24"
  }

  security_rule {
    name                       = "DB-Rule2"
    priority                   = 180
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.3.0/24"
  }

  security_rule {
    name                       = "DB-Rule3"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.3.0/24"
  }
  tags = {
    environment = var.tags
  }
}

# Associating nsg to a virtual network subnet
resource "azurerm_network_interface" "VM_NIC" {
  name                = "Vnet-interface"
  location            = var.location
  resource_group_name = azurerm_resource_group.John-Dev

  ip_configuration {
    name                          = var.ip-configuration
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}


# Creating a virtual machine (vm)

resource "azurerm_windows_virtual_machine" "JohnVM" {
  name                = "John-VirtualM"
  resource_group_name = azurerm_resource_group.John-Dev
  location            = azurerm_resource_group.John-Dev.location
  size                = "standard_B1s"
  admin_username      = var.adminuser
  admin_password      = var.passwd
  network_interface_ids = [
    azurerm_network_interface.VM_NIC.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

# resource "azurerm_dev_test_global_vm_shutdown_schedule" "VM_Autoshutdown" {
#   virtual_machine_id = azurerm_virtual_machine.JohnVM.id
#   location           = azurerm_resource_group.JohnDev.location
#   enabled            = true

#   daily_recurrence_time = "1800"
#   timezone              = "West Africa Standard Time"

#   notification_settings {
#     enabled         = true
#     time_in_minutes = "60"
#     webhook_url     = "https://sample-webhook-url.example.com"
#   }
# }

#Creating of Storage Account
resource "azurerm_storage_account" "John_SA" {
  name                     = var.SA-name
  resource_group_name      = azurerm_resource_group.John-Dev
  location                 = azurerm_resource_group.John-Dev.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


#Creating of Database server and DB
resource "azurerm_mssql_server" "John_SQLS" {
  name                         = var.MSSQL_name
  resource_group_name          = azurerm_resource_group.John-Dev
  location                     = azurerm_resource_group.John-Dev.location
  version                      = "12.0"
  administrator_login          = var.adminuser
  administrator_login_password = var.passwd
}

resource "azurerm_mssql_database" "John_DB" {
  name           = var.DB_name
  server_id      = azurerm_mssql_server.John_SQLS.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = true

  tags = {
    foo = var.tags
  }

}

resource "azurerm_storage_share" "John_FileShare" {
  name                 = var.John_FileShare
  storage_account_name = azurerm_storage_account.John_SA
  quota                = 1024

  acl {
    id = var.ID

    access_policy {
      permissions = "rwdl"
      start       = "2022-05-01T09:38:21.0000000Z"
      expiry      = "2022-07-01T10:38:21.0000000Z"
    }
  }
}

# Network rules for Storage account and IP to allow
resource "azurerm_storage_account_network_rules" "SA_rules" {
  storage_account_id = azurerm_storage_account.John_SA.id

  default_action             = "Allow"
  ip_rules                   = ["10.0.2.0/24", "10.0.4.0/24"]
  virtual_network_subnet_ids = [azurerm_subnet.subnet3.id]
  bypass                     = ["Metrics"]
}
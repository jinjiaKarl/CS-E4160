resource "azurerm_resource_group" "rg" {
  name     = "net_lab"
  location = "northeurope"
}

resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}



# Create subnet
resource "azurerm_subnet" "intnet1" {
  name                 = "intnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "intnet2" {
  name                 = "intnet2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip_lab1" {
  name                = "myPublicIPLab1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "my_terraform_public_ip_lab2" {
  name                = "myPublicIPLab2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "my_terraform_public_ip_lab3" {
  name                = "myPublicIPLab3"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

#   security_rule {
#     name                       = "application_in"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "application_out"
#     priority                   = 101
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic1_lab1" {
  name                = "myNIC1_lab1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic1_lab1_configuration"
    subnet_id                     = azurerm_subnet.intnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip_lab1.id
  }
}
resource "azurerm_network_interface" "my_terraform_nic2_lab1" {
  name                = "myNIC2_lab1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic2_lab1_configuration"
    subnet_id                     = azurerm_subnet.intnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "my_terraform_nic1_lab2" {
  name                = "myNIC1_lab2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic1_lab2_configuration"
    subnet_id                     = azurerm_subnet.intnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip_lab2.id
  }
}

resource "azurerm_network_interface" "my_terraform_nic1_lab3" {
  name                = "myNIC1_lab3"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic1_lab3_configuration"
    subnet_id                     = azurerm_subnet.intnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip_lab3.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nic1_lab1" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic1_lab1.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}
resource "azurerm_network_interface_security_group_association" "nic2_lab1" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic2_lab1.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}
resource "azurerm_network_interface_security_group_association" "nic1_lab2" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic1_lab2.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}
resource "azurerm_network_interface_security_group_association" "nic1_lab3" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic1_lab3.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

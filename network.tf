resource "azurerm_virtual_network" "vnet_atividade_2" {
    name                = "VNetAtividade2"
    address_space       = ["10.80.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.resource_group_atividade_2.name

    tags = {
        environment = var.environment
    }

    depends_on = [ azurerm_resource_group.resource_group_atividade_2 ]
}

resource "azurerm_subnet" "subnet_atividade_2" {
    name                 = "SubNetAtividade2"
    resource_group_name  = azurerm_resource_group.resource_group_atividade_2.name
    virtual_network_name = azurerm_virtual_network.vnet_atividade_2.name
    address_prefixes       = ["10.80.4.0/24"]

    depends_on = [ azurerm_resource_group.resource_group_atividade_2, azurerm_virtual_network.vnet_atividade_2 ]
}

resource "azurerm_network_security_group" "security_group_atividade_2" {
    name                = "NetworkSecurityGroupAtividade2"
    location            = var.location
    resource_group_name = azurerm_resource_group.resource_group_atividade_2.name

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

    security_rule {
        name                       = "HTTPInbound"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = var.environment
    }

    depends_on = [ azurerm_resource_group.resource_group_atividade_2 ]
}
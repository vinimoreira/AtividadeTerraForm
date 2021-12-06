resource "azurerm_public_ip" "public_ip_mysql" {
  name                    = "PublicIpMySQL"
  location                = var.location
  resource_group_name     = azurerm_resource_group.resource_group_atividade_2.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30

  tags = {
    environment = var.environment
  }

  depends_on = [azurerm_resource_group.resource_group_atividade_2]
}

resource "azurerm_network_interface" "network_interface_mysql" {
  name                = "NetworkInterfaceMySQL"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_atividade_2.name

  ip_configuration {
    name                          = "NetworkInterfaceConfigurationMySQL"
    subnet_id                     = azurerm_subnet.subnet_atividade_2.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.80.4.10"
    public_ip_address_id          = azurerm_public_ip.public_ip_mysql.id
  }

  tags = {
    environment = var.environment
  }

  depends_on = [azurerm_resource_group.resource_group_atividade_2, azurerm_subnet.subnet_atividade_2]
}

resource "azurerm_network_interface_security_group_association" "network_interface_security_group_mysql" {
  network_interface_id      = azurerm_network_interface.network_interface_mysql.id
  network_security_group_id = azurerm_network_security_group.security_group_atividade_2.id

  depends_on = [azurerm_network_interface.network_interface_mysql, azurerm_network_security_group.security_group_atividade_2]
}

resource "azurerm_network_security_rule" "open_mysql_port" {
  name                        = "MySQL Port"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_group_atividade_2.name
  network_security_group_name = azurerm_network_security_group.security_group_atividade_2.name

  depends_on = [azurerm_resource_group.resource_group_atividade_2, azurerm_network_security_group.security_group_atividade_2]

}


data "azurerm_public_ip" "set_public_ip_mysql" {
  name                = azurerm_public_ip.public_ip_mysql.name
  resource_group_name = azurerm_resource_group.resource_group_atividade_2.name
}

resource "azurerm_storage_account" "storage_mysql" {
    name                        = "storageaccountmysql"
    resource_group_name         = azurerm_resource_group.resource_group_atividade_2.name
    location                    = var.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"
    
    tags = {
        environment = var.environment
    }

    depends_on = [ azurerm_resource_group.resource_group_atividade_2 ]
    
}

resource "azurerm_linux_virtual_machine" "virtual_machine_mysql" {
    name                  = "VirtualMachineMySQL"
    location              = var.location
    resource_group_name   = azurerm_resource_group.resource_group_atividade_2.name
    network_interface_ids = [azurerm_network_interface.network_interface_mysql.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "OsDBDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "vmmysql"
    admin_username = var.user
    admin_password = var.password
    disable_password_authentication = false

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.storage_mysql.primary_blob_endpoint
    }

    tags = {
        environment = var.environment
    }

    depends_on = [ azurerm_resource_group.resource_group_atividade_2, azurerm_network_interface.network_interface_mysql, azurerm_storage_account.storage_mysql, azurerm_public_ip.public_ip_mysql ]
}

resource "time_sleep" "wait_30_seconds_db" {
  depends_on = [azurerm_linux_virtual_machine.virtual_machine_mysql]
  create_duration = "30s"
}

resource "null_resource" "upload_db" {
    provisioner "file" {
        connection {
            type = "ssh"
            user = var.user
            password = var.password
            host = data.azurerm_public_ip.set_public_ip_mysql.ip_address
        }
        source = "mysql"
        destination = "/home/azureuser"
    }

    depends_on = [ time_sleep.wait_30_seconds_db ]
}

resource "null_resource" "deploy_db" {
    triggers = {
        order = null_resource.upload_db.id
    }
    provisioner "remote-exec" {
        connection {
            type = "ssh"
            user = var.user
            password = var.password
            host = data.azurerm_public_ip.set_public_ip_mysql.ip_address
        }
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y mysql-server-5.7",
            "sudo mysql < /home/azureuser/mysql/script/user.sql",
            "sudo mysql < /home/azureuser/mysql/script/schema.sql",
            "sudo mysql < /home/azureuser/mysql/script/data.sql",
            "sudo cp -f /home/azureuser/mysql/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf",
            "sudo service mysql restart",
            "sleep 20",
        ]
    }
}
# Atividade 2 - # Infrastructure and Cloud Architecture

Subir uma máquina virtual no Azure, AWS ou GCP instalando o MySQL usando Terraform.

# Passo à Passo para a execução do script
- 1 - Obter as credenciais da sua conta no Azure executando os comandos abaixo
 > az login
 
 > az account list
 
 > az account set --subscription="#SUBSCRIPTION_ID"
 
 > az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/#SUBSCRIPTION_ID"
 
 - 2 - Alterar as variáveis arquivo `'terraform.tfvars'`
 > client_id="client_id"
 
 > client_secret="client_secret"
 
 > tenant_id="tenant_id"
 
 > subscription_id="subscription_id" 
 [Documentação de Exemplo ](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)

 - 3 - Executar os comandos do terraform
> terraform init

> terraform plan

> terraform apply

# Evidências
![enter image description here](https://i.imgur.com/gpRM7XT.png)

## Grupo A - Integrantes
- Alessandra Souza da Silva
- Elizangela Fernandes Leal
- Henrique Araújo Rosa
- Mariana Silva Dutra
- Rafael da Silva Muni
- Vinicius Moreira da Silva

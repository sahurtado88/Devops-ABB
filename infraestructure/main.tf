provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_key_vault" "kv" {
  name= "postgres-kv"
  resource_group_name = azurerm_resource_group.rg.name
  
}

data "azurerm_key_vault_secret" "pg_adminuser" {
  name= "pg-adminuser"
  key_vault_id = data.azurerm_key_vault.kv.id
  
}

data "azurerm_key_vault_secret" "pg_password" {
  name= "pg-password"
  key_vault_id = data.azurerm_key_vault.kv.id
  
}

resource "azurerm_postgresql_server" "server" {
  name                = "examplepsqlserver-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  administrator_login          = data.azurerm_key_vault_secret.pg_adminuser.value
  administrator_login_password = data.azurerm_key_vault_secret.pg_password.value
  version                      = "11"
  sku_name                     = "B_Gen5_2"
  storage_mb                   = 5120
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  public_network_access_enabled = true
  ssl_enforcement_enabled = true
}

resource "azurerm_postgresql_database" "db" {
  name                = "exampledb${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "rule" {
    name= "azure"
    resource_group_name = azurerm_resource_group.rg.name
    server_name = azurerm_postgresql_server.server.name
    start_ip_address = "0.0.0.0"
    end_ip_address = "0.0.0.0"
  
}

resource "azurerm_service_plan" "asp" {
  name                = "ASP-test-ab9a"
  location            = azurerm_resource_group.asp.location
  resource_group_name = azurerm_resource_group.asp.name
  sku_name            = "F1"
  os_type             = "Linux"
  worker_count = 1

}

resource "azurerm_linux_web_app" "example" {
  name                = "uniqueip${var.environment}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id

  app_settings = {
    DATABASE_URL = "postgresql://${azurerm_postgresql_server.example.administrator_login}:${azurerm_postgresql_server.example.administrator_login_password}@${azurerm_postgresql_server.example.fqdn}/${azurerm_postgresql_database.example.name}"
  }

  site_config {
    application_stack {
      docker_image_name = "sahurtado88/countapp"
      docker_registry_url = "https://index.docker.io"
     
    }
  }
}

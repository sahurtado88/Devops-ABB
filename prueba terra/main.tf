provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "test"
  location = "East US"
}

resource "azurerm_postgresql_server" "example" {
  name                = "examplepsqlserver"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  administrator_login          = "psqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "11"
  sku_name                     = "B_Gen5_2"
  storage_mb                   = 5120

  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  public_network_access_enabled = true
  

  ssl_enforcement_enabled = true
}

resource "azurerm_postgresql_database" "example" {
  name                = "exampledb"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_postgresql_server.example.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "rule" {
    name= "azure"
    resource_group_name = azurerm_resource_group.example.name
    server_name = azurerm_postgresql_server.example.name
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
  name                = "countappinf"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id

  app_settings = {
    DATABASE_URL = "postgresql://${azurerm_postgresql_server.example.administrator_login}:${azurerm_postgresql_server.example.administrator_login_password}@${azurerm_postgresql_server.example.fqdn}/${azurerm_postgresql_database.example.name}"
  }

  site_config {
    application_stack {
      docker_image_name = "sahurtado88/countapp:v1"
      docker_registry_url = "https://index.docker.io"
     
    }
  }
}

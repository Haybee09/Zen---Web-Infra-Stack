#Creates SQL Server in same location as the VMs
resource "azurerm_mssql_server" "sql_server" {
  name                         = "zen-sql-server"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

#Creates SQL Database - (SKU - Standard0)
resource "azurerm_sql_database" "sql_db" {
  name                = "zen-sql-db"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name         = azurerm_mssql_server.sql_server.name
  edition             = "Standard"
  requested_service_objective_name = "S0"
}

#Allow all azure services to reach the DB
resource "azurerm_sql_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mssql_server.sql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
output "load_balancer_ip" {
  value = azurerm_public_ip.lb_pip.ip_address
}

output "application_gateway_ip" {
  value = azurerm_public_ip.agw_pip.ip_address
}

output "azure_bastion_ip" {
  value = azurerm_public_ip.bastion_pip.ip_address
}

output "sql_server_fqdn" {
  value = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}

output "key_vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}
# security.tf
#Azure keyvault creation and access policy
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                       = "kv-${var.project_name}-${random_string.random.result}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update",
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete",
    ]
  }
}

#db connection string stored in azure key vault
resource "azurerm_key_vault_secret" "db_connection_string" {
  name         = "db-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.sql_db.name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.kv.id
}

# Azure Backup
#Recovery service vault creation
resource "azurerm_recovery_services_vault" "vault" {
  name                = "rsv-${var.project_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}

#set backup policy
resource "azurerm_backup_policy_vm" "vm_backup_policy" {
  name                = "vm-backup-policy"
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }
}

#add web tier vms to protected vm
resource "azurerm_backup_protected_vm" "web_vm_backup" {
  count               = var.web_vm_count
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  source_vm_id        = azurerm_windows_virtual_machine.web_vm[count.index].id
  backup_policy_id    = azurerm_backup_policy_vm.vm_backup_policy.id
}

#add db vm to protected vm
resource "azurerm_backup_protected_vm" "db_vm_backup" {
  resource_group_name = azurerm_resource_group.rg.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  source_vm_id        = azurerm_windows_virtual_machine.db_vm.id
  backup_policy_id    = azurerm_backup_policy_vm.vm_backup_policy.id
}

# Azure Security Center
resource "azurerm_security_center_subscription_pricing" "security_center" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
}

resource "azurerm_security_center_contact" "security_center_contact" {
  email = var.security_center_email

  alert_notifications = true
  alerts_to_admins    = true
}
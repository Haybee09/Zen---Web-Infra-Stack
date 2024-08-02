#set variables using tvars

resource_group_name = "Zen_Core"
location            = "eastus 2"
vnet_address_space  = ["10.0.0.0/16"]
web_subnet_prefix   = "10.0.1.0/24"
db_subnet_prefix    = "10.0.2.0/24"
appgw_subnet_prefix = "10.0.3.0/24"
vm_admin_username   = "zenadmin"
vm_admin_password   = "Reganam@321#"
sql_admin_username  = "zenadmin"
sql_admin_password  = "Reganam@321#"
project_name        = "zenrecovery"
web_vm_count        = 2
security_center_email  = "salawuhabeeb09@gmail.com"
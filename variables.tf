#Variable file, values are declared in tfvars, however these are store fallback data
#Passwords are not provided here and also set to sensitive to prevent printing out in logs

variable "resource_group_name" {
  type = string  
  default = "Zen_Core"
}

variable "location" {
  type = string  
  default = "eastus 2"
}

variable "vnet_address_space" {    
  default = ["10.0.0.0/16"]
}

variable "web_subnet_prefix" {
  type = string    
  default = "10.0.1.0/24"
}

variable "db_subnet_prefix" {
  type = string    
  default = "10.0.2.0/24"
}

variable "appgw_subnet_prefix" {
  type = string    
  default = "10.0.4.0/24"
}

variable "bastion_subnet_prefix" {
  type = string    
  default = "10.0.5.0/24"
}

variable "vm_admin_username" {
  type = string    
  default = "zenadmin"
}

variable "vm_admin_password" {
  type = string  
  description = "Password for the VM admin user"
  sensitive = true
}

variable "sql_admin_username" {
  type = string  
  default = "zenadmin"
}

variable "sql_admin_password" {
  type = string  
  description = "Password for the SQL admin user"
  sensitive = true
}

variable "project_name" {
  type        = string
  description = "A name for the project, used in resource naming"
}

variable "web_vm_count" {
  type        = number
  description = "Number of web tier VMs"
  default     = 2
}

variable "security_center_email" {
  type        = string
  description = "salawuhabeeb09@gmail.com"
}
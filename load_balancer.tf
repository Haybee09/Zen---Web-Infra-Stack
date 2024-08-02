#Creates public IP for Load Balancer
resource "azurerm_public_ip" "lb_pip" {
  name                = "lb-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Creates Standard Load Balancer
resource "azurerm_lb" "lb" {
  name                = "app-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

#Creates Frontend IP Config and associates the "lb_pip"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}

#Creates Backend Address pool
resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

#Creates http health probe for backend pool
resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "http-probe"
  port            = 80
}

#Creates loadbalancer rule
resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_pool.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
}

# Addociate web tier vms with loadbalancer backend address pool
resource "azurerm_network_interface_backend_address_pool_association" "lb_nic_association" {
  count                   = var.web_vm_count
  network_interface_id    = azurerm_network_interface.web_nic[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
}
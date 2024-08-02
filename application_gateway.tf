#Create Application Gateway piublic IP
resource "azurerm_public_ip" "agw_pip" {
  name                = "agw-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Create Standard_v2 application gateway
resource "azurerm_application_gateway" "agw" {
  name                = "app-gateway"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
  }

#Configure autoscaling, this is in case of high traffic scenario
  autoscale_configuration {
    min_capacity = 1
    max_capacity = 2
  }

#Add appgw to a dedicated subnet
  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }


# HTTP Setiing, Listener and Routing rule configuation
  frontend_port {
    name = "frontend-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-ip-config"
    public_ip_address_id = azurerm_public_ip.agw_pip.id
  }

  backend_address_pool {
    name = "backend-pool"
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip-config"
    frontend_port_name             = "frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "http-settings"
    priority                   = 1
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "agw_nic_association" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.web_nic[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = one(azurerm_application_gateway.agw.backend_address_pool).id
}
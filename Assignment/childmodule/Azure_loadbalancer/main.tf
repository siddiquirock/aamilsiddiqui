data "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
}



# Load Balancer
resource "azurerm_lb" "example" {
  name                = "TestLoadBalancer"
  location            = Westus
  resource_group_name = dev200111rg
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

# Backend Pool
resource "azurerm_lb_backend_address_pool" "example" {
  name                = "BackEndAddressPool"
  loadbalancer_id     = azurerm_lb.example.id
  resource_group_name = azurerm_resource_group.example.name
}

# Health Probe
resource "azurerm_lb_probe" "example" {
  name                = "http-probe"
  resource_group_name = azurerm_resource_group.example.name
  loadbalancer_id     = azurerm_lb.example.id
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 15
  number_of_probes    = 2
}

# Load Balancer Rule
resource "azurerm_lb_rule" "example" {
  name                           = "http-rule"
  resource_group_name            = azurerm_resource_group.example.name
  loadbalancer_id                = azurerm_lb.example.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.example.id
  probe_id                       = azurerm_lb_probe.example.id
}

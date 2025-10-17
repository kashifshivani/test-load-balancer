data "azurerm_public_ip" "pip" {
  name                = "lb-pip"
  resource_group_name = "rg-lb"
}

resource "azurerm_lb" "lb" {
  name                = "my-lb"
  location            = "Canada Central"
  resource_group_name = "rg-lb"

  frontend_ip_configuration {
    name                 = "fip-lb"
    public_ip_address_id = data.azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bap" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "bap-lb"
}

resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "probe-lb"
  port            = 22
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "rule-lb"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "fip-lb"
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.bap.id ]
  probe_id = azurerm_lb_probe.probe.id
}
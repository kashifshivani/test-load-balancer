data "azurerm_network_interface" "nic" {
  name                = var.nic_name
  resource_group_name = var.rg_name
}

data "azurerm_lb" "lb" {
  name                = var.lb_name
  resource_group_name = var.rg_name
}

data "azurerm_lb_backend_address_pool" "bap" {
  name            = var.bap_name
  loadbalancer_id = data.azurerm_lb.lb.id
}

data "azurerm_network_interface" "nic_vm1" {
  name                = "nic-vm-1"
  resource_group_name = "rg-lb"
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_bap" {
  network_interface_id    = data.azurerm_network_interface.nic.id
  ip_configuration_name   = var.ip_configuration_name
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.bap.id
}

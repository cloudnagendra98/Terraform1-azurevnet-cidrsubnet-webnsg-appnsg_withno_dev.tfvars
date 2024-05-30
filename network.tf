resource "azurerm_virtual_network" "ntier_vnet" {
  name                = "azure_ntier_vnet"
  resource_group_name = azurerm_resource_group.ntier_resg.name
  address_space       = [var.azure_ntier_cidr]
  location            = azurerm_resource_group.ntier_resg.location

  depends_on = [
    azurerm_resource_group.ntier_resg
  ]
}

resource "azurerm_subnet" "subnets" {
  #count                = 3
  #count = length(var.subnet_address_prefixes)
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = azurerm_resource_group.ntier_resg.name
  virtual_network_name = azurerm_virtual_network.ntier_vnet.name
  address_prefixes     = [cidrsubnet(var.azure_ntier_cidr, 8, count.index)]
  #address_prefixes     = [format(var.subnet_address_prefixes, count.index)]
  #address_prefixes = [var.subnet_address_prefixes[count.index]]

  depends_on = [
    azurerm_resource_group.ntier_resg,
    azurerm_virtual_network.ntier_vnet
  ]

}


resource "azurerm_network_security_group" "webnsg" {
  name                = var.webnsg_config.name
  resource_group_name = azurerm_resource_group.ntier_resg.name
  location            = azurerm_resource_group.ntier_resg.location

  depends_on = [
    azurerm_resource_group.ntier_resg
  ]


}

# resource "azurerm_network_security_group" "webnsg" {
#   name = "webnsg"
#   resource_group_name = azurerm_resource_group.ntier_resg.name
#   location = azurerm_resource_group.ntier_resg.location

#   depends_on = [ 
#     azurerm_resource_group.ntier_resg
#      ]


# }


resource "azurerm_network_security_rule" "rules" {
  count                       = length(var.webnsg_config.rules)
  name                        = var.webnsg_config.rules[count.index].name
  resource_group_name         = azurerm_resource_group.ntier_resg.name
  network_security_group_name = azurerm_network_security_group.webnsg.name
  protocol                    = var.webnsg_config.rules[count.index].protocol
  source_port_range           = var.webnsg_config.rules[count.index].source_port_range
  destination_port_range      = var.webnsg_config.rules[count.index].destination_port_range
  source_address_prefix       = var.webnsg_config.rules[count.index].source_address_prefix
  destination_address_prefix  = var.webnsg_config.rules[count.index].destination_address_prefix
  access                      = var.webnsg_config.rules[count.index].access
  priority                    = var.webnsg_config.rules[count.index].priority
  direction                   = var.webnsg_config.rules[count.index].direction


  depends_on = [
    azurerm_network_security_group.webnsg
  ]

}


# resource "azurerm_network_security_rule" "webnsgrule_http" {
#   name = "openhttp"
#   resource_group_name = azurerm_resource_group.ntier_resg.name
#   network_security_group_name = azurerm_network_security_group.webnsg.name
#   protocol = "Tcp"
#   source_port_range = "*"
#   destination_port_range = "80"
#   source_address_prefix = "*"
#   destination_address_prefix = "*"
#   access = "Allow"
#   priority = "300"
#   direction = "Inbound"


# }

resource "azurerm_network_security_group" "appnsg" {
  name                = var.appnsg_config.name
  resource_group_name = azurerm_resource_group.ntier_resg.name
  location            = azurerm_resource_group.ntier_resg.location

  depends_on = [
    azurerm_resource_group.ntier_resg
  ]


}

resource "azurerm_network_security_rule" "appnsgrules" {
  count                       = length(var.appnsg_config.rules)
  name                        = var.appnsg_config.rules[count.index].name
  resource_group_name         = azurerm_resource_group.ntier_resg.name
  network_security_group_name = azurerm_network_security_group.appnsg.name
  protocol                    = var.appnsg_config.rules[count.index].protocol
  source_port_range           = var.appnsg_config.rules[count.index].source_port_range
  destination_port_range      = var.appnsg_config.rules[count.index].destination_port_range
  source_address_prefix       = var.appnsg_config.rules[count.index].source_address_prefix
  destination_address_prefix  = var.appnsg_config.rules[count.index].destination_address_prefix
  access                      = var.appnsg_config.rules[count.index].access
  priority                    = var.appnsg_config.rules[count.index].priority
  direction                   = var.appnsg_config.rules[count.index].direction


  depends_on = [
    azurerm_network_security_group.appnsg
  ]

}

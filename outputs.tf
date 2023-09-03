output "resource_group_id" {
  description = "id of the resource group"
  value = azurerm_resource_group.rg.id
}

output "vnet_id" {
  description = "id of 'vnet' vnet"
  value = "azurerm_virtual_network.vnet.id"
}

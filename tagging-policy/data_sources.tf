data "azurerm_management_group" "tenant_root" {
  name = var.tenant_id
}
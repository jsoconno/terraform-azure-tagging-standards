resource "azurerm_role_assignment" "automation_run_as_account" {
  scope                = data.azurerm_management_group.tenant_root.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_service_principal.automation_run_as_account.object_id
}
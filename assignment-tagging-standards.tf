resource "azurerm_policy_assignment" "apa_tagging_standards" {
    name                 = "apa_tagging_standards"
    scope                = "/subscriptions/c72acede-d539-45d9-963d-3464ec4ddae0/resourceGroups/RGP-USE-CORE-EXAMPLE-DV" #azurerm_management_group.tenant_root.id
    policy_definition_id = azurerm_policy_set_definition.tagging_standards.id
    description          = ""
    display_name         = "Example Tagging Standards"
    location             = "eastus"

    parameters = <<PARAMETERS
        {
            "policy-effect": {
                "value": "deny"
            }
        }
    PARAMETERS

    identity {
        type          = "SystemAssigned"
    }
}

resource "azurerm_role_assignment" "apa_tagging_standards" {
    scope                 = "/providers/Microsoft.Management/managementGroups/${data.azurerm_management_group.tenant_root.name}"
    role_definition_name  = "Contributor"
    principal_id          = azurerm_policy_assignment.apa_tagging_standards.identity[0].principal_id
}
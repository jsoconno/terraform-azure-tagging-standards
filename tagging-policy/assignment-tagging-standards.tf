resource "azurerm_policy_assignment" "apa_tagging_standards" {
    name                 = "apa_tagging_standards"
    scope                = data.azurerm_management_group.tenant_root.id
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
    scope                 = data.azurerm_management_group.tenant_root.id
    role_definition_name  = "Contributor"
    principal_id          = azurerm_policy_assignment.apa_tagging_standards.identity[0].principal_id
}
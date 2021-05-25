locals {
    environment_tags = [
        "Development",
        "QA",
        "UAT",
        "Production"
    ]
}

resource "azurerm_policy_set_definition" "tagging_standards" {
    name                  = "api_tagging_standards"
    policy_type           = "Custom"
    display_name          = "Tagging Standards"
    management_group_name = data.azurerm_management_group.tenant_root.name
    description           = "Tagging Standards to be applied to the Azure environment."

    lifecycle {
        ignore_changes = [
            metadata
        ]
    }

    parameters = <<PARAMETERS
    {
    "policy-effect":
        {
            "allowedValues":["audit","deny"],
            "metadata":{
                "description":"The effect options for the initiative.",
                "displayName":"policy-effect"
            },
            "type":"String",
            "defaultValue": "audit"
        }
    }
    PARAMETERS

    # Enforces the Environment tag on any resource group that is created.
    policy_definition_reference {
        policy_definition_id = azurerm_policy_definition.enforce_resource_group_tags.id
        parameter_values = jsonencode({
            policy-effect = {value = "[parameters('policy-effect')]"},
            tagName = {value = "Environment"}
        })
    }

    # Validates the Environment tag on any resource group that is created.
    policy_definition_reference {
        policy_definition_id = azurerm_policy_definition.validate_resource_group_tags.id
        parameter_values = jsonencode({
        policy-effect = {value = "[parameters('policy-effect')]"},
            options = {value = local.environment_tags},
            tagName = {value = "Environment"}
        })
    }

    # Appends the Environment tag on a resource based on the parent resource group if one is not provided.
    policy_definition_reference {
        policy_definition_id = azurerm_policy_definition.append_resource_group_tags.id
        parameter_values = jsonencode({
            tagName = {value = "Environment"}
        })
    }

    # Enforces the Environment tag on any resource that is created.
    policy_definition_reference {
        policy_definition_id = azurerm_policy_definition.enforce_resource_tags.id
        parameter_values = jsonencode({
            policy-effect = {value = "[parameters('policy-effect')]"},
            tagName = {value = "Environment"}
        })
    }

    # Validates the Environment tag on any resource that is created.
    policy_definition_reference {
        policy_definition_id = azurerm_policy_definition.validate_resource_tags.id
        parameter_values = jsonencode({
            policy-effect = {value = "[parameters('policy-effect')]"},
            options = {value = local.environment_tags},
            tagName = {value = "Environment"}
        })
    }
}
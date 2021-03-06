resource "azurerm_policy_definition" "validate_resource_group_tags" {
    name         = "apd_validate_rg_tags"
    management_group_name = data.azurerm_management_group.tenant_root.name
    policy_type  = "Custom"
    mode         = "All"
    display_name = "Validate Resource Group Tags"
    description  = "Policy to validate the value supplied for a tag key based on a parameterized array for a resource group."

    lifecycle {
        ignore_changes = [
            metadata
        ]
    }

    metadata = <<METADATA
    {
        "category": "Tags",
        "createdBy": "",
        "createdOn": "",
        "updatedBy": "",
        "updatedOn": ""    
    }
    METADATA

    parameters = <<PARAMETERS
    {
        "tagName": {
        "type": "String",
        "metadata": {
            "displayName": "Tag Name",
            "description": "Name of the tag, such as 'environment'"
        }
        },
        "policy-effect": {
            "type": "String",
            "metadata": {
                "displayName": "Policy Effect",
                "description": "The available options for the Policy Effect"
        },
        "allowedValues": [
            "audit",
            "deny"
        ],
        "defaultValue": "audit"
        },
        "options": {
            "type": "Array",
            "metadata": {
                "displayName": "Options",
                "description": "List of available options for validation."
            }
        }
    }
    PARAMETERS

    policy_rule = <<POLICY_RULE
    {
        "if": {
            "allOf": [
                {
                    "not": {
                        "field": "[concat('tags[', parameters('tagName'), ']')]",
                        "in": "[parameters('options')]"
                    }
                },
                {
                    "field": "type",
                    "equals": "Microsoft.Resources/subscriptions/resourceGroups"
                }
            ]
            },
        "then": {
            "effect": "[parameters('policy-effect')]"
        }
    }
    POLICY_RULE
}
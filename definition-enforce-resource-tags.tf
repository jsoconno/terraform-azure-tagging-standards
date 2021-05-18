resource "azurerm_policy_definition" "enforce_resource_tags" {
    name         = "apd_enforce_r_tags"
    management_group_name = data.azurerm_management_group.tenant_root.name
    policy_type  = "Custom"
    mode         = "Indexed"
    display_name = "Example Enforce Resource Tags"
    description  = "Policy to enforce that a specific tag exists for a resource.  Excludes metric alerts."

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
        }
    }
    PARAMETERS

    policy_rule = <<POLICY_RULE
    {
        "if": {
            "allOf": [
                {
                    "field": "[concat('tags[', parameters('tagName'), ']')]",
                    "exists": "false"
                }
            ]
        },
        "then": {
            "effect": "[parameters('policy-effect')]"
        }
    }
    POLICY_RULE
}
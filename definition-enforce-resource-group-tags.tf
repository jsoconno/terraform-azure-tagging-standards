resource "azurerm_policy_definition" "enforce_resource_group_tags" {
    name         = "apd_enforce_rg_tags"  
    management_group_name = data.azurerm_management_group.tenant_root.name
    policy_type  = "Custom"
    mode         = "All"
    display_name = "Example Enforce Resource Group Tags"

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
                "description": "Name of the tag, such as costCenter"
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
                    "field": "type",
                    "equals": "Microsoft.Resources/subscriptions/resourceGroups"
                },
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
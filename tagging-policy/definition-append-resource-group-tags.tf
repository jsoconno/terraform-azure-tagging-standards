resource "azurerm_policy_definition" "append_resource_group_tags" {
    name         = "apd_append_rg_tags"  
    management_group_name = data.azurerm_management_group.tenant_root.name
    policy_type  = "Custom"
    mode         = "Indexed"
    display_name = "Example Append Resource Group Tags"

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
                },
                {
                    "value": "[resourceGroup().tags[parameters('tagName')]]",
                    "exists": "true"
                },
                {
                    "value": "[resourceGroup().tags[parameters('tagName')]]",
                    "notEquals": ""
                }
            ]
        },
        "then": {
            "effect": "append",
            "details": [
                {
                    "field": "[concat('tags[', parameters('tagName'), ']')]",
                    "value": "[resourceGroup().tags[parameters('tagName')]]"
                }
            ]
        }
    }
    POLICY_RULE
}
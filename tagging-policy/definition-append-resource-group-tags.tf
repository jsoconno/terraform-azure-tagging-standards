resource "azurerm_policy_definition" "append_resource_group_tags" {
    name         = "apd_append_rg_tags"  
    management_group_name = data.azurerm_management_group.tenant_root.name
    policy_type  = "Custom"
    mode         = "Indexed"
    display_name = "Append Resource Group Tags"

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

    # By using the modify effect, we are able to create a remediation task for this policy
    # An Azure Automation Runbook can be used to accomplish this on a regular basis so tags are evergreen
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
            "effect": "modify",
            "details": {
                "roleDefinitionIds": [
                    "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
                ],
                "operations": [
                    {
                        "operation": "add",
                        "field": "[concat('tags[', parameters('tagName'), ']')]",
                        "value": "[resourceGroup().tags[parameters('tagName')]]"
                    }
                ]
            }
        }
    }

  POLICY_RULE
}
# These are the automation modules required by the runbook to run.
# Only remove the comments for the ones you need and update the depends on blocks as required.

# resource "azurerm_automation_module" "az_accounts" {
#   name                    = "Az.Accounts"
#   resource_group_name     = data.azurerm_resource_group.main.name
#   automation_account_name = data.azurerm_automation_account.main.name

#   module_link {
#     uri = "https://www.powershellgallery.com/api/v2/package/Az.Accounts/2.2.8.0"
#   }
# }

# resource "azurerm_automation_module" "az_resources" {
#   name                    = "Az.Resources"
#   resource_group_name     = data.azurerm_resource_group.main.name
#   automation_account_name = data.azurerm_automation_account.main.name

#   module_link {
#     uri = "https://www.powershellgallery.com/api/v2/package/Az.Resources/2.5.1.0"
#   }

#   depends_on = [
#     azurerm_automation_module.az_accounts
#   ]
# }

# resource "azurerm_automation_module" "az_policy_insights" {
#   name                    = "Az.PolicyInsights"
#   resource_group_name     = data.azurerm_resource_group.main.name
#   automation_account_name = data.azurerm_automation_account.main.name

#   module_link {
#     uri = "https://www.powershellgallery.com/api/v2/package/Az.PolicyInsights/1.3.1.0"
#   }

#   depends_on = [
#     azurerm_automation_module.az_resources
#   ]
# }
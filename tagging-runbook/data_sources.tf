data "azurerm_resource_group" "main" {
  name = var.automation_account_resource_group_name
}

data "azurerm_automation_account" "main" {
  name                = var.automation_account_name
  resource_group_name = var.automation_account_resource_group_name
}

data "local_file" "tagging_remediation" {
  filename = "tagging-remediation.ps1"
}
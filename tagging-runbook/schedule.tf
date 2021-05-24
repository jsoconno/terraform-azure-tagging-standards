resource "azurerm_automation_schedule" "every_four_hours" {
  name                    = "Every Four Hours"
  resource_group_name     = data.azurerm_resource_group.main.name
  automation_account_name = data.azurerm_automation_account.main.name
  frequency               = "Hour"
  interval                = 4
  timezone                = "America/New_York"
  description             = "Runs Every 4 Hours"
}

resource "azurerm_automation_job_schedule" "tagging_remediation" {
  resource_group_name     = data.azurerm_resource_group.main.name
  automation_account_name = data.azurerm_automation_account.main.name
  schedule_name           = "Every Four Hours"
  runbook_name            = azurerm_automation_runbook.tagging_remediation.name
}
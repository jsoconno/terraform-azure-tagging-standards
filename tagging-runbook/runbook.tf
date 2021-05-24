resource "azurerm_automation_runbook" "tagging_remediation" {
  name                    = "TaggingRemediation"
  location                = data.azurerm_resource_group.main.location
  resource_group_name     = data.azurerm_resource_group.main.name
  automation_account_name = data.azurerm_automation_account.main.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "Used to give child resource the tags required from the parent resource group"
  runbook_type            = "PowerShell"

  # must have a content link, but will use custom content from local file
  publish_content_link {
    uri = "https://www.microsoft.com/en-us/"
  }

  content = data.local_file.tagging_remediation.content
}
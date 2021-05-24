# terraform-azure-tagging-standards

## Introduction
Tagging can be a powerful tool in Azure.  You can use it to organize and categorize your resources making them easier to find.  Tags can also help with other things like automating processes like locking virtual networks or destroying test resources which can protect and reduce the cost of your Azure environment.

Tagging can be an important asset for large companies with cloud platforms that service multiple internal business streams and external clients at-scale.

Here are some common use cases for tagging:

* Logically organizing resources into a taxonomy
* Automating operations
* Reducing costs
* Maintaining compliance
* Managing cloud usage costs

In order to create a consistent metadata model using tag key value pairs, you need a way of ensuring your tagging is consistent.  This repo provides Terraform code that will help you create policy definitions, policy initiatives (also known as policy sets), and policy assignments with an identity to allow for tagging remediation.

It will also help you to create a runbook that uses an Azure Automation Run As Account to automate the remediation of resources that are not tagged for any reason under a resource group.  There are strange situations where this technically can happen, even with the policy.  For example, when an application uses a stored procedure to create a database.

## Pre-Requisites

The Policy deployment will require that you have the appropriate user permissions to manage policies and assignments at the tenant root of your Azure tenant or that you have an app registration with these permissions with a generated client secret.

The runbook deployment requires that you have an automation account in one of your Azure subscriptions with a configured Run As Account.

You will also need to be sure that you have the required automation modules to run the script in the automation account.  This includes Az.Accounts, Az.Resources, and Az.PolicyInsights.  If you don't have these in your automation account, they can be created with Terraform using the following script:

automation-modules terraform file
```
resource "azurerm_automation_module" "az_accounts" {
  name                    = "Az.Accounts"
  resource_group_name     = data.azurerm_resource_group.main.name
  automation_account_name = data.azurerm_automation_account.main.name

  module_link {
    uri = "https://www.powershellgallery.com/api/v2/package/Az.Accounts/2.2.8.0"
  }
}

resource "azurerm_automation_module" "az_resources" {
  name                    = "Az.Resources"
  resource_group_name     = data.azurerm_resource_group.main.name
  automation_account_name = data.azurerm_automation_account.main.name

  module_link {
    uri = "https://www.powershellgallery.com/api/v2/package/Az.Resources/2.5.1.0"
  }

  depends_on = [
    azurerm_automation_module.az_accounts
  ]
}

resource "azurerm_automation_module" "az_policy_insights" {
  name                    = "Az.PolicyInsights"
  resource_group_name     = data.azurerm_resource_group.main.name
  automation_account_name = data.azurerm_automation_account.main.name

  module_link {
    uri = "https://www.powershellgallery.com/api/v2/package/Az.PolicyInsights/1.3.1.0"
  }

  depends_on = [
    azurerm_automation_module.az_resources
  ]
}
```

Note that if the depends on blocks are not included, Terraform will successfully import the first module, but fail on the rest.
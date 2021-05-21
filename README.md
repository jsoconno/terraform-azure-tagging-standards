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

The runbook deployment requires that you have an automation account in one of your Azure subscriptions with a configured Run As Account.  The Run As Account must be contributor over the Tenant Root Group to make changes to tags.  This can be added with Terraform using the following:

```
data "azuread_service_principal" "automation_run_as_account" {
  display_name = var.automation_run_as_account
}

data "azurerm_management_group" "tenant_root" {
  name = "Tenant Root Group"
}

resource "azurerm_role_assignment" "automation_run_as_account" {
  scope                = data.azurerm_management_group.kpmg_root.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_service_principal.automation_run_as_account.object_id
}
```
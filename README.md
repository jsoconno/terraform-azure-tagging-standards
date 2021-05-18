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

## Steps

1. Clone this repository
2. Gather details required for your backend configuration and authentication with Azure
3. Modify code to add new tags you want to enforce, validate, and inherit
4. Run Terraform plan to see what resources will be created
5. Run Terraform apply to deploy them
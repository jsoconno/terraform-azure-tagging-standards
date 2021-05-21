##
# tagging-remediation.ps1
#
# Description: Used to give child resource the tags required from the parent resouce group
##

# Login to Azure
$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection"
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName
 
    "Logging in to Azure..."
    Add-AzAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
}
catch
{
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    }
    else
    {
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

$policySetName = "api_tagging_standards"
$policyDefinitionName = "apd_append_rg_tags"
$policyAssignmentScope = Get-AzManagementGroup | Where {$_.DisplayName -eq "Tenant Root Group"}
$policyDefinitionId = "$($policyAssignmentScope.Id)/providers/Microsoft.Authorization/policyDefinitions/$($policyDefinitionName)"

# Fetch Policy and Assignment Information
try
{
    # Get the policy set definition based on name
    $policySet = Get-AzPolicySetDefinition | where { $_.Name -eq $policySetName }

    # Get the policy definition that is responsible for appending tags from the resource group level
    $policies = $policySet.Properties.PolicyDefinitions | where { $_.policyDefinitionId -eq $policyDefinitionId }

    # Get the assigments for the policy definition
    $assignment = Get-AzPolicyAssignment -Scope $policyAssignmentScope.Id | where { $_.Properties.PolicyDefinitionId -eq $($policySet.PolicySetDefinitionId)}

}
catch
{
    Write-Error -Message $_.Exception
    throw $_.Exception
}

# Create Remediation Task
try
{
    foreach ( $policy in $policies ) {
        $job = Start-AzPolicyRemediation -PolicyAssignmentId $($assignment.PolicyAssignmentId) -PolicyDefinitionReferenceId $($policy.policyDefinitionReferenceId) -Name "remediate-$($policy.parameters.tagName.value)-tag" -ManagementGroupName $policyAssignmentScope.DisplayName -AsJob
        $job | Wait-Job
        $remediation = $job | Receive-Job
        Write-Output "$($remediation.Name):"
        Write-Output $($remediation.DeploymentSummary)
        Start-Sleep -Seconds 60
    }
}
catch
{
    Write-Error -Message $_.Exception
    throw $_.Exception
}

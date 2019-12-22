<#
 .Synopsis
  Return the current access policies present in KeyVault.

 .Description
  List the current access policies present in KeyVault.

 .Parameter KeyVaultName
  The name of the KeyVault from which the access policies are to be retrieved.

 .Parameter ResourceGroupName
  The resource group containing the KeyVault.

 .Parameter OutputVariableName
  Default value: Infra.KeyVault.AccessPolicies
  The name of the variable to be added to DevOps-pipeline variables at runtime.
#>
function Get-KeyVaultAccessPolicies {
	param(
	   [parameter(Mandatory = $true)][string] $KeyVaultName,
	   [parameter(Mandatory = $false)][string] $ResourceGroupName = "",
	   [parameter(Mandatory = $false)][string] $OutputVariableName = "Infra.KeyVault.AccessPolicies"
	)
	. $PSScriptRoot\Scripts\Get-Infra-KeyVaultAccessPolicies.ps1 -keyVaultName $KeyVaultName -resourceGroupName $ResourceGroupName -outputVariableName $OutputVariableName
}

<#
 .Synopsis
  Change the state of a DataFactory V2 Trigger.

 .Description
  Start or stop a DataFactory V2 Trigger.

 .Parameter Action
  The new state of the trigger: start | stop.

 .Parameter ResourceGroupName
  The resource group containing the DataFactory V2.

 .Parameter DataFactoryName
  The name of the DataFactory V2.

 .Parameter DataFactoryTriggerName
  The name of the trigger to be started/stopped.

 .Parameter FailWhenTriggerIsNotFound
  Indicate whether to throw an exception if the trigger cannot be found.
#>
function Set-DataFactoryTriggerState {
	param(
		[Parameter(Mandatory=$true)][string]$Action = $(throw "Action is required [start|stop]"),
		[Parameter(Mandatory=$true)][string]$ResourceGroupName = $(throw "ResourceGroup is required"),
		[Parameter(Mandatory=$true)][string]$DataFactoryName = $(throw "The name of the data factory is required"),
		[Parameter(Mandatory=$true)][string]$DataFactoryTriggerName = $(throw "The name of the trigger is required"),
		[Parameter(Mandatory=$false)][switch]$FailWhenTriggerIsNotFound = $false
	)
	if($FailWhenTriggerIsNotFound)
	{
		. $PSScriptRoot\Scripts\Set-Infra-DataFactoryTriggerState.ps1 -Action $Action -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -DataFactoryTriggerName $DataFactoryTriggerName -FailWhenTriggerIsNotFound
	}
	else
	{
		. $PSScriptRoot\Scripts\Set-Infra-DataFactoryTriggerState.ps1 -Action $Action -ResourceGroupName $ResourceGroupName -DataFactoryName $DataFactoryName -DataFactoryTriggerName $DataFactoryTriggerName
	}
}


<#
 .Synopsis
  Clear the deployment logs within a resource group. 

 .Description
  Prevent deployment failures occuring in case 800+ deployments logs are already stored for the targeted resource group.

 .Parameter ResourceGroupName
  The resource group for which the logs needs to be cleared.

 .Parameter NumberRetained
  The amount of entries to be retained in the log.
#>
function Remove-OldArmDeploymentLogs{
	Param(
    	[Parameter(Mandatory=$true)][string]$ResourceGroupName,
    	[Parameter(Mandatory=$false)][int]$NumberRetained=100
	)
	. $PSScriptRoot\Scripts\Remove-Azure-OldArmDeployments.ps1 -resourceGroup $ResourceGroupName -numberRetained $NumberRetained
}


Export-ModuleMember Get-KeyVaultAccessPolicies

Export-ModuleMember Set-DataFactoryTriggerState

Export-ModuleMember Remove-OldArmDeploymentLogs
<#
	Get-Infra-KeyVaultAccessPolicies
#>
function Get-KeyVaultAccessPolicies {
	param(
	   [string][parameter(Mandatory = $true)] $KeyVaultName,
	   [string][parameter(Mandatory = $false)] $ResourceGroupName = "",
	   [string][parameter(Mandatory = $false)] $OutputVariableName = "Infra.KeyVault.AccessPolicies"
	)
. $PSScriptRoot\Scripts\Get-Infra-KeyVault-AccessPolicies.ps1 -keyVaultName $KeyVaultName -resourceGroupName $ResourceGroupName -outputVariableName $OutputVariableName
}

Export-ModuleMember Get-KeyVaultAccessPolicies
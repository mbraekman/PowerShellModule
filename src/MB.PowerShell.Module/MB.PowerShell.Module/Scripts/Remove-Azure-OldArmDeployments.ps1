Param(
    [string]$resourceGroup,
    [int]$numberRetained=100
)

# Remove all deployments for the resource group, retaining only the first $numberRetained.
# There is an arbitrary limit of 800 deployments for a resource group.

$Global:acces_token = "";
$Global:subscriptionId = "";

function Get-AzCachedAccessToken()
{
    $ErrorActionPreference = 'Stop'
  
    if(-not (Get-Module Az.Accounts)) {
        Import-Module Az.Accounts
    }
    $azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    if(-not $azProfile.Accounts.Count) {
        Write-Error "Ensure you have logged in before calling this function."    
    }
  
    $currentAzureContext = Get-AzContext
    $Global:subscriptionId = $currentAzureContext.Subscription.Id
    $profileClient = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($azProfile)
    Write-Debug ("Getting access token for tenant" + $currentAzureContext.Tenant.TenantId)
    $token = $profileClient.AcquireAccessToken($currentAzureContext.Tenant.TenantId)
    $Global:acces_token = $token.AccessToken
    
    Write-Host "Access-token and subscriptionId retrieved"
}

$deployments = Get-AzureRmResourceGroupDeployment -resourceGroupName $resourceGroup
$numberOfDeployments = $deployments.Count 

if($numberOfDeployments -gt $numberRetained){

    $numberDeleted = $numberOfDeployments - $numberRetained
    Write-Host "$numberOfDeployments deployments found. Cleaning up $numberDeleted deployments, retaining $numberRetained"
    Get-AzCachedAccessToken
    
    $deployments | Select-Object -Skip $numberRetained | ForEach-Object {

        $name = $_.DeploymentName
        Write-Host "Cleaning up deployment: $name"
        $params = @{
            Method = 'Delete'
            Headers = @{ 
				'authorization'="Bearer $Global:acces_token"
			}
            URI = "https://management.azure.com/subscriptions/$Global:subscriptionId/resourcegroups/$resourceGroup/providers/Microsoft.Resources/deployments/" + $name + "?api-version=2019-05-10"
        }

        Invoke-RestMethod @params
        Write-Host "Removed deployment $name"
        
    }
}
else {
    Write-Host "$numberOfDeployments found. Nothing to clean."
}


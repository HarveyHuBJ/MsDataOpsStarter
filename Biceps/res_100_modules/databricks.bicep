param env string='dev'
param familyName string=''
param workspaceName string='dbk-ws-${familyName}-${env}'

@allowed([
  'standard'
  'premium'
])
param pricingTier string = 'standard'

param location string = resourceGroup().location

var managedResourceGroupName = 'databricks-rg-${workspaceName}'

resource ws 'Microsoft.Databricks/workspaces@2018-04-01' = {
  name: workspaceName
  location: location
  sku: {
    name: pricingTier
  }
  properties: {
    // TODO: improve once we have scoping functions
    managedResourceGroupId: '${subscription().id}/resourceGroups/${managedResourceGroupName}'
  }
}

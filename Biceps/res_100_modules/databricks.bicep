param env string='dev'
param familyName string='hh101'
param workspaceName string='dbk-ws-${familyName}-${env}'

param keyvaultName string = 'kv-${familyName}-${env}'
param tags object = {
  env: env
  owner: 'harveyhu@microsoft.com'
  project: 'dataops-starter-lab'
}

@secure()
param databricks_token string=''   // replace with a real one
param exp_unix_time int = 1716776048 // 2024-5-17

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
  tags:tags
  sku: {
    name: pricingTier
  }
  properties: {
    managedResourceGroupId: '${subscription().id}/resourceGroups/${managedResourceGroupName}'
  }
}


resource keyvault_resource 'Microsoft.KeyVault/vaults@2021-10-01' existing={
  name: keyvaultName
}

// need update when token generated!!!
resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = if (databricks_token != ''){
  parent: keyvault_resource
  name: 'secret-databricks-token'
  properties: {
    value:  databricks_token
    attributes:{
      enabled: true
      exp: exp_unix_time
    }
  }
}

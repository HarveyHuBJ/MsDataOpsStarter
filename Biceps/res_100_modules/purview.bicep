param location string = 'Japan East'

param env string='dev'
param familyName string='hh01'
param name string = 'pvw-${familyName}-${env}'
param tags object = {
  env: env
  owner: 'harveyhu@microsoft.com'
  project: 'dataops-starter-lab'
}

var mrg='managed-${name}'

resource purview_resource 'Microsoft.Purview/accounts@2021-07-01' = {
  name: name
  location: location
  tags:tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    managedResourceGroupName: mrg
  } 
  dependsOn: []
}

output purview_msi string = purview_resource.name


param familyName string = 'hh01'
param env string='dev'
param location string='eastasia'
param name string = 'adf-${familyName}-${env}'

resource datafactories_resource 'Microsoft.DataFactory/factories@2018-06-01' =   {
  name: name
  location: location
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

resource adf_vnet 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' =   {
  parent: datafactories_resource
  name: 'default'
  properties: {}
}

resource adf_integration_runtimes 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' =  {
  parent: datafactories_resource
  name: 'AutoResolveIntegrationRuntime'
  properties: {
    type: 'Managed'
    managedVirtualNetwork: {
      referenceName: 'default'
      type: 'ManagedVirtualNetworkReference'
    }
    typeProperties: {
      computeProperties: {
        location: 'AutoResolve'
      }
    }
  }
  dependsOn: [
    adf_vnet
  ]
}

// var roleDefinitionId=''
// resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview'={
//   name:'abc'
//   scope:resourceGroup()
//   properties:{
//     roleDefinitionId:roleDefinitionId
//      principalType: 'ServicePrincipal'
//   }
// }

output adf_msi string = datafactories_resource.name


param familyName string = 'hh01'
param env string='dev'
param location string='eastasia'
param name string = '${familyName}-${env}-adf'

resource name_resource 'Microsoft.DataFactory/factories@2018-06-01' =   {
  name: name
  location: location
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

resource name_default 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' =   {
  parent: name_resource
  name: 'default'
  properties: {}
}

resource name_AutoResolveIntegrationRuntime 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' =  {
  parent: name_resource
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
    name_default
  ]
}

 
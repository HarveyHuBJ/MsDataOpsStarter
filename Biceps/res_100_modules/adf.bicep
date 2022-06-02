
param familyName string = 'hh101'
param env string='dev'
param location string= resourceGroup().location
param name string = 'adf-${familyName}-${env}'

// github repo
param repo_accountName string ='HarveyHuBJ'
param repo_repositoryName string ='MsDataOpsStarter'
param tags object = {
  env: env
  owner: 'harveyhu@microsoft.com'
  project: 'dataops-starter-lab'
}

// only bind git repo on 'dev' environment
var repoConfiguration= {
  type: 'FactoryGitHubConfiguration'
  accountName: repo_accountName
  repositoryName: repo_repositoryName
  collaborationBranch: 'main'
  rootFolder: '/ADF'
}

resource datafactories_resource 'Microsoft.DataFactory/factories@2018-06-01' =   {
  name: name
  location: location
  tags:tags
  properties: {
    publicNetworkAccess: 'Enabled'
    repoConfiguration: repoConfiguration  // comment this line when not 'dev' environment
  }
  identity:{
    type: 'SystemAssigned'
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



output adf_msi string = datafactories_resource.name
output adf_msi_id string = datafactories_resource.identity.principalId

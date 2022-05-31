param location string = resourceGroup().location
param env string = 'dev'
param familyName string='hh101'
param keyvaultName string = 'kv-${familyName}-${env}'

param tenantId string = 'efa728a8-8af1-45bd-9e56-d8ce0bdc90da'  // 
param spn_id  string = '7da72d5b-2ba3-45aa-b44d-277ff74d5830' // spn object id
param adminId string= '679e0424-4461-4989-807a-a1a94edc55a0'  // admin user objectId

param tags object = {
  env: env
  owner: 'harveyhu@microsoft.com'
  project: 'dataops-starter-lab'
}

 

resource keyvault_resource 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyvaultName
  location: location
  tags:tags 
  properties: {
    enabledForDeployment: false
    enabledForTemplateDeployment: false
    enabledForDiskEncryption: false
    enableRbacAuthorization: false
    accessPolicies: [
       {
          tenantId: tenantId 
          objectId: spn_id
          permissions:{
            secrets:[
              'get'
              'list'
              'set'
            ]
          }
       }
       {
          tenantId: tenantId
          objectId: adminId
          permissions:{
            secrets:[
              'get'
              'list'
              'set'
              'delete'
            ]
            keys:[
              'get'
              'list'
              'update'
              'create'
              'delete'
            ]
            certificates:[
              'get'
              'list'
              'delete'
              'update'
              'create'
            ]
          }
        }
    ]
    tenantId: tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    publicNetworkAccess: 'Enabled'
    enableSoftDelete: false
    softDeleteRetentionInDays: 90
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
      ipRules: []
      virtualNetworkRules: []
  }
  }
  dependsOn: []
}

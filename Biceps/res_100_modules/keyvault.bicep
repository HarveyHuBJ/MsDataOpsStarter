param location string = resourceGroup().location
param env string = 'dev'
param familyName string='hh101'
param keyvaultName string = 'kv-${familyName}-${env}'

param tenantId string = 'efa728a8-8af1-45bd-9e56-d8ce0bdc90da'  // 
param github_devops_spn_id  string = '8863b765-0bb2-40a4-bb0e-3485880b1580' // application id
param adminId string= '679e0424-4461-4989-807a-a1a94edc55a0'  // admin user objectId


resource name_resource 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: keyvaultName
  location: location
  tags: {}
  properties: {
    enabledForDeployment: false
    enabledForTemplateDeployment: false
    enabledForDiskEncryption: false
    enableRbacAuthorization: false
    accessPolicies: [
       {
          tenantId: tenantId
          applicationId: github_devops_spn_id
          objectId: guid(tenantId, github_devops_spn_id, keyvaultName)
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
    enableSoftDelete: true
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

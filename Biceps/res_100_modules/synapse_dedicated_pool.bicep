
param familyName string = 'hh101'
param env string='dev'
param location string= resourceGroup().location
param workspaceName string = 'ws-${familyName}-${env}'

param adls_account_name string = 'storage${familyName}${env}adls'
param adls_file_system_name string = 'raw-data'

param storageKind string = 'StorageV2'

param sqlPoolName string = 'dwh_${familyName}_${env}_pool'
param collation string = 'SQL_Latin1_General_CP1_CI_AS'
param dw_sku string = 'DW200c'
param adminId string='679e0424-4461-4989-807a-a1a94edc55a0'

param keyvaultName string = 'kv-${familyName}-${env}'
param exp_unix_time int = 1716776048 // 2024-5-17


var dw_admin_password = substring('Pwd0!${uniqueString(resourceGroup().id)}',0, 12)

resource adls_account_resource 'Microsoft.Storage/storageAccounts@2021-01-01' =   {
  name: adls_account_name
  location: location
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    isHnsEnabled: true
    minimumTlsVersion: 'TLS1_2'
  }
  sku: {
    name: 'Standard_LRS'
  }
  kind: storageKind
  tags: {}
}

resource adls_file_system_resource 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-01-01' =  {
  name: '${adls_account_name}/default/${adls_file_system_name}'
  properties: {
    publicAccess: 'None'
  }
  dependsOn: [
    adls_account_resource
  ]
}

// var defaultDataLakeStorageAccountUrl2 = adls_account_resource.properties.primaryEndpoints.web
resource synapse_workspace_resource 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: workspaceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      accountUrl: adls_account_resource.properties.primaryEndpoints.dfs
      filesystem: adls_file_system_name
      resourceId: adls_file_system_resource.id
      createManagedPrivateEndpoint: false
    }
    
    managedVirtualNetwork: ''
    managedResourceGroupName: ''
    azureADOnlyAuthentication: false
    sqlAdministratorLogin: 'dw_admin'
    sqlAdministratorLoginPassword: dw_admin_password
    cspWorkspaceAdminProperties:{
       initialWorkspaceAdminObjectId: adminId
    }
    trustedServiceBypassEnabled:true

  }
  
}

resource firewall_allowAll 'Microsoft.Synapse/workspaces/firewallrules@2021-06-01' =   {
  parent: synapse_workspace_resource
  name: 'allowAll'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

// var sqlPool_name = '${workspaceName}/${sqlPoolName}'
resource sqlPool_resource 'Microsoft.Synapse/workspaces/sqlPools@2021-06-01' = {
  location: location
  name: sqlPoolName
  parent: synapse_workspace_resource
  sku: {
    name: dw_sku
  }
  properties: {
    createMode: 'Default'
    collation: collation
    storageAccountType:  'LRS'
  }
}

resource sqlpool_metadatasync 'Microsoft.Synapse/workspaces/sqlPools/metadataSync@2021-06-01' = {
  parent: sqlPool_resource
  name: 'config'
  properties: {
    enabled: false
  }
}


// save password in keyvault
resource keyvault_resource 'Microsoft.KeyVault/vaults@2021-10-01' existing={
  name: keyvaultName
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  parent: keyvault_resource
  name: 'secret-dwadmin-pwd'
  properties: {
    value:  dw_admin_password
    attributes:{
      enabled: true
      exp: exp_unix_time
    }
  }
}

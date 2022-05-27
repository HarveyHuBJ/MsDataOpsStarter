
param familyName string = 'hh101'
param env string='dev'
param location string= resourceGroup().location
param workspaceName string = 'ws-${familyName}-${env}'

param adls_account_name string = 'storage${familyName}${env}adls'
param adls_file_system_name string = 'raw-data'

param storageKind string = 'StorageV2'

param sqlPoolName string = 'dwh_${familyName}_${env}_pool'
param collation string = 'SQL_Latin1_General_CP1_CI_AS'
param dwsku string = 'DW200c'


var defaultDataLakeStorageAccountUrl =  'https://${adls_account_name}.dfs.core.windows.net'


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
      accountUrl: defaultDataLakeStorageAccountUrl
      filesystem: adls_file_system_name
      resourceId: adls_file_system_resource.id
      createManagedPrivateEndpoint: false
    }
    managedVirtualNetwork: ''
    managedResourceGroupName: ''
    azureADOnlyAuthentication: true
  }
  dependsOn:[
    adls_account_resource
  ]
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
    name: dwsku
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

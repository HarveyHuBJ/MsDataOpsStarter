
param familyName string = 'hh01'
param env string='dev'
param location string='eastasia'
param workspaceName string = '${familyName}-${env}-adf'

param adls_account_name string = '${familyName}adlsaccount'
param adls_file_system_name string = 'raw-data'

param storageKind string = 'StorageV2'

param sqlPoolName string = '${familyName}_${env}_dw'
param collation string = 'SQL_Latin1_General_CP1_CI_AS'
param dwsku string = 'DW200c'


  // var defaultDataLakeStorageAccountUrl =  'https://${adls_account_name}.dfs.core.windows.net'


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

var defaultDataLakeStorageAccountUrl = adls_account_resource.properties.primaryEndpoints.web
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
   
}

resource name_allowAll 'Microsoft.Synapse/workspaces/firewallrules@2021-06-01' =   {
  parent: synapse_workspace_resource
  name: 'allowAll'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}


resource workspaceName_sqlPoolName 'Microsoft.Synapse/workspaces/sqlPools@2021-06-01' = {
  location: location
  name: '${workspaceName}/${sqlPoolName}'
  sku: {
    name: dwsku
  }
  properties: {
    createMode: 'Default'
    collation: collation
    storageAccountType:  'LRS'
  }
}

resource workspaceName_sqlPoolName_config 'Microsoft.Synapse/workspaces/sqlPools/metadataSync@2021-06-01' = {
  parent: workspaceName_sqlPoolName
  name: 'config'
  properties: {
    enabled: false
  }
}

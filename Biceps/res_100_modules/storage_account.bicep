param location string = resourceGroup().location
param env string = 'dev'
param familyName string='hh101'
param storageAccountName string = 'storage${familyName}${env}'
param containerName string = 'src-data'
param keyvaultName string = 'kv-${familyName}-${env}'
param exp_unix_time int = 1716776048 // 2024-5-17


// storage account for ADLS GEN2
resource storageAccount_resource 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }

  // container named src-data
  resource blob_resource 'blobServices' = {
    name: 'default'
    resource blob_container_resource 'containers' = {
      name: containerName
      properties: {
        publicAccess: 'None'
        defaultEncryptionScope: '$account-encryption-key'
        denyEncryptionScopeOverride:false
        immutableStorageWithVersioning:{
          enabled: false
        }
      }
    }
  }
}
 

resource keyvault_resource 'Microsoft.KeyVault/vaults@2021-10-01' existing={
  name: keyvaultName
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  parent: keyvault_resource
  name: 'secret-${storageAccount_resource.name}-key'
  properties: {
    value: storageAccount_resource.listKeys().keys[0].value
    attributes:{
      enabled: true
      exp: exp_unix_time
    }
  }
}

output StorageAccountName string = storageAccount_resource.name
 
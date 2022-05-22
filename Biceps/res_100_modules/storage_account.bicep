param location string = resourceGroup().location
param env string = 'dev'
param familyName string='hh101'
param storageAccountName string = 'storage${familyName}${env}'
// storage account for ADLS GEN2
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}
 
output StorageAccountName string = storageAccount.name
 
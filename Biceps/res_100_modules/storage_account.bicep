param location string = resourceGroup().location
param familyName string
param storageAccountName string = '${familyName}${uniqueString(resourceGroup().id)}'
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
 
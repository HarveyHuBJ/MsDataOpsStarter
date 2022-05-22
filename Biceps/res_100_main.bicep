@allowed([
  'eastasia' 
  'southeastasia'
])
param location string = 'eastasia'
param familyName string = 'habc'

module myModule './res_100_modules/storage_account.bicep' = {
  name: 'storage01'
  params: {
    location: location
    familyName: familyName
  }
}

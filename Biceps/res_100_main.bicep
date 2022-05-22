@allowed([
  'eastasia' 
  'southeastasia'
])
param location string = 'eastasia'

@description('所有资源名称的前缀')
param familyName string = 'habc'

module storageModule './res_100_modules/storage_account.bicep' = {
  name: 'storage02'
  params: {
    location: location
    familyName: familyName
  }
}


module sqlServerModule './res_100_modules/storage_account.bicep' = {
  name: 'sqlServer02'
  params: {
    location: location
    familyName: familyName
  }
}


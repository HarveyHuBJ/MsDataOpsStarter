@allowed([
  'eastasia' 
  'southeastasia'
])
param location string = 'eastasia'

@description('所有资源名称的前缀,仅字母数字组合')
param familyName string = 'dataopslab'
param env string = 'dev'

module storageModule './res_100_modules/storage_account.bicep' = {
  name: 'storage02'
  params: {
    location: location
    familyName: familyName
    env:env
  }
}


module adfModule './res_100_modules/adf.bicep' = {
  name: 'adf02'
  params: {
    location: location
    familyName: familyName
    env:env
  }
}

module sqldbModule './res_100_modules/sql_server.bicep' = {
  name: 'sqldb02'
  params: {
    location: location
    familyName: familyName
    env:env
  }
}


module synapseModule './res_100_modules/synapse_dedicated_pool.bicep' = {
  name: 'synapse02'
  params: {
    location: location
    familyName: familyName
    env:env
  }
}


module databricksModule './res_100_modules/databricks.bicep' = {
  name: 'databricks02'
  params: {
    location: location
    familyName: familyName
    env:env
  }
}

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

module purviewModule 'res_100_modules/purview.bicep'={
  name:'purview02'
  params:{
    location:location
    familyName:familyName
    env:env
  }
}

// output adf_msi string = adfModule.outputs.adf_msi
// output purview_msi string = purviewModule.outputs.purview_msi
// 将adf的 msi 和 purview的msi 加入到：
//    1） sql dw的 db_owner中
//    2） sql db的 db_owner中
//    3） storage account 的 'storage Blob Data Owner'中

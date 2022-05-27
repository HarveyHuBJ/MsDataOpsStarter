// @allowed([
//   'eastasia' 
//   'southeastasia'
// ])
param location string = resourceGroup().location

@description('所有资源名称的前缀,仅字母数字组合')
param familyName string = 'dataopslab'

@description('部署环境名称')
@allowed([
  'dev' 
  'sit'
  'uat'
  'prod'
])
param env string = 'dev'

@description('tenantId')
param tenantId string = 'efa728a8-8af1-45bd-9e56-d8ce0bdc90da'  // 

@description('github_devops_spn的objectId; ths spn is used for github CICD')
param github_devops_spn_id string = '7da72d5b-2ba3-45aa-b44d-277ff74d5830' // spn object id

@description('adminUser is the account to login, which has most of the privileges')
param admin_user_id string = '679e0424-4461-4989-807a-a1a94edc55a0'  // admin user objectId

@secure()
param db_admin_password string

module keyvaultModule 'res_100_modules/keyvault.bicep'={
  name: 'keyvault02'
  params:{
    location: location
    familyName: familyName
    env: env
    tenantId: tenantId
    spn_id: github_devops_spn_id
    adminId: admin_user_id
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

module storageModule './res_100_modules/storage_account.bicep' = {
  name: 'storage02'
  params: {
    location: location
    familyName: familyName
    env:env
  }
  dependsOn:[
    keyvaultModule
  ]
}



module sqldbModule './res_100_modules/sql_server.bicep' = {
  name: 'sqldb02'
  params: {
    location: location
    familyName: familyName
    env: env
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

module rbacModule 'res_100_modules/_rbac.bicep'={
  name:'rbac'
  params:{
    principalId:adfModule.outputs.adf_msi_id
  }
}

// output adf_msi string = adfModule.outputs.adf_msi
// output purview_msi string = purviewModule.outputs.purview_msi
// 将adf的 msi 和 purview的msi 加入到：
//    1） sql dw的 db_owner中
//    2） sql db的 db_owner中
//    3） storage account 的 'storage Blob Data Owner'中

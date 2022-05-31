param env string='dev'
param location string =  resourceGroup().location
param familyName string='hh101'

param keyvaultName string = 'kv-${familyName}-${env}'
param tenantId string='efa728a8-8af1-45bd-9e56-d8ce0bdc90da'
param adminAccount string='adminuser@cpuhackthon.onmicrosoft.com'
param adminId string='679e0424-4461-4989-807a-a1a94edc55a0'
param exp_unix_time int = 1716776048 // 2024-5-17
 
param collation string = 'SQL_Latin1_General_CP1_CI_AS'
param sqlServerName string = 'dbsrv-${familyName}-${env}'
param sqlDatabaseName string = 'db-${familyName}-${env}'
param sqlDatabaseSku object = {
  name:'S0'
  tier:'Standard'
}

var db_admin_password = substring('Pwd0!${uniqueString(resourceGroup().id)}',0, 12)

resource sqlServer 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administrators:  {
      administratorType: 'ActiveDirectory'
      login: adminAccount
      sid: adminId
      tenantId: tenantId
      azureADOnlyAuthentication: false
      principalType: 'User'
    }
    
    publicNetworkAccess:'Enabled'
    administratorLogin: 'db_admin'
    administratorLoginPassword: db_admin_password

  }
  
  resource sqlServerFirewallRules 'firewallRules@2020-11-01-preview' = {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      startIpAddress: '1.1.1.1'
      endIpAddress: '255.255.255.0'
    }
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2020-11-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: {
    name: sqlDatabaseSku.name
    tier: sqlDatabaseSku.tier
  }
  properties:{
    collation:collation
    maxSizeBytes:53687091200
    zoneRedundant:false
  }
  resource synapse_workspace_tde  'transparentDataEncryption' = {
    name: 'current'
    properties:{
     state: 'Enabled'
   }
  }
}

resource keyvault_resource 'Microsoft.KeyVault/vaults@2021-10-01' existing={
  name: keyvaultName
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  parent: keyvault_resource
  name: 'secret-dbadmin-pwd'
  properties: {
    value:  db_admin_password
    attributes:{
      enabled: true
      exp: exp_unix_time
    }
  }
}

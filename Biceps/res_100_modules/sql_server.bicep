param env string='dev'
param location string =  resourceGroup().location
param familyName string='hh101'
param administrators object = {
  administratorType: 'activeDirectory'
  login: 'adminuser@cpuhackthon.onmicrosoft.com'
  sid: '679e0424-4461-4989-807a-a1a94edc55a0'
  tenantId: 'efa728a8-8af1-45bd-9e56-d8ce0bdc90da'
  azureADOnlyAuthentication: true
  principalType: 'User'
}
param primaryUserAssignedIdentityId string = ''
param collation string = 'SQL_Latin1_General_CP1_CI_AS'
param sqlServerName string = 'db-${familyName}-${env}'
param sqlDatabaseName string = 'dbsvr-${familyName}-${env}'
param sqlDatabaseSku object = {
  name:'S0'
  tier:'Standard'
}


resource sqlServer 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administrators: administrators
    primaryUserAssignedIdentityId: primaryUserAssignedIdentityId
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
}

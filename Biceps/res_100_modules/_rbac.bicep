 
param roleDefinitionID string='ba92f5b4-2d11-453d-a403-e96b0029c9fe' // blob data contributor
param principalId string  // resource msi


resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview'={
  name: guid(principalId, roleDefinitionID, resourceGroup().id)   // guid 格式， 具有唯一性
  scope: resourceGroup()
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionID)
    principalType: 'ServicePrincipal'
    principalId: principalId
  }
  
}

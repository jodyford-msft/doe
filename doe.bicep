param tenantId string
param subscriptionId string
param storageAccountName string
param sqlServerName string
param sqlDatabaseName string
param appServiceName string

// Define a custom role for code deployment
resource appServiceDeployRole 'Microsoft.Authorization/roleDefinitions@2020-04-01-preview' = {
  name: 'App Service Deployer'
  properties: {
    roleName: 'App Service Deployer'
    description: 'Lets you deploy code to an App Service.'
    type: 'CustomRole'
    assignableScopes: [
      '/subscriptions/${subscriptionId}/resourceGroups/${appServiceName}-rg/providers/Microsoft.Web/sites/${appServiceName}'
    ]
    permissions: [
      {
        actions: [
          'Microsoft.Web/sites/publishxml/action'
          'Microsoft.Web/sites/redeploy/action'
          'Microsoft.Web/sites/restart/action'
          'Microsoft.Web/sites/slotsswap/action'
          'Microsoft.Web/sites/extensions/*/install/action'
          'Microsoft.Web/sites/extensions/*/uninstall/action'
        ]
        notActions: []
        dataActions: []
        notDataActions: []
      }
    ]
  }
}

// Define an assignment of the App Service Deployer role to a user or group
resource appServiceDeployRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: '${appServiceName}-deploy-role-assignment'
  properties: {
    roleDefinitionId: appServiceDeployRole.id
    principalId: '<insert-principal-id-here>' // replace with the object ID of the user or group to assign the role to
    scope: appServiceDeployRole.properties.assignableScopes[0]
  }
}

// Define the built-in Storage Blob Data Contributor role
resource storageRole 'Microsoft.Authorization/roleDefinitions@2020-04-01-preview' = {
  name: 'Storage Blob Data Contributor'
  properties: {
    roleName: 'Storage Blob Data Contributor'
    description: 'Lets you read and write all blobs and blob properties, and lets you list all containers and blobs in a storage account.'
    type: 'BuiltInRole'
    assignableScopes: [
      '/subscriptions/${subscriptionId}/resourceGroups/${storageAccountName}-rg/providers/Microsoft.Storage/storageAccounts/${storageAccountName}'
    ]
    permissions: [
      {
        actions: [
          'Microsoft.Storage/storageAccounts/listkeys/action',
          'Microsoft.Storage/storageAccounts/regenerateKey/action',
          'Microsoft.Storage/storageAccounts/read',
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/*'
        ]
        notActions: []
        dataActions: [
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write',
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete',
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action'
        ]
        notDataActions: []
      }
    ]
  }
}

// Define the built-in SQL DB Contributor role
resource sqlRole 'Microsoft.Authorization/roleDefinitions@2020-04-01-preview' = {
  name: 'SQL DB Contributor'
  properties: {
    roleName: 'SQL DB Contributor'
    description: 'Lets you manage databases, elastic pools, and related SQL services.'
    type: 'BuiltInRole'
    assignableScopes: [
      '/subscriptions/${subscriptionId}/resourceGroups/${sqlServerName}-rg/providers/Microsoft.Sql/servers/${sqlServerName}'
    ]
    permissions: [
      {
        actions: [
          'Microsoft.Sql/servers/databases/*',
          'Microsoft.Sql/servers/elasticPools/*'
        ]
        notActions: []
        dataActions: []
        notDataActions: []
      }
    ]
  }
}

// Define the built-in Contributor role for App Service
resource appServiceRole 'Microsoft.Authorization/roleDefinitions@2020-04-01-preview' = {
  name: 'Contributor'
  properties: {
    roleName: 'Contributor'
    description: 'Lets you manage everything except access.'
    type: 'BuiltInRole'
    assignableScopes: [
      '/subscriptions/${subscriptionId}/resourceGroups/${appServiceName}-rg/providers/Microsoft.Web/sites/${appServiceName}'
    ]
    permissions: [
      {
        actions: [
          '*'
        ]
        notActions: []
        dataActions: []
        notDataActions: []
      }
    ]
  }
}

// Define an assignment of the Storage Blob Data Contributor role to a user or group
resource storageRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: '${storageAccountName}-blob-role-assignment'
  properties: {
    roleDefinitionId: storageRole.id
    principalId: '<insert-principal-id-here>' // replace with the object ID of the user or group to assign the role to
    scope: storageRole.properties.assignableScopes[0]
  }
}

// Define an assignment of the SQL DB Contributor role to a user or group
resource sqlRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04

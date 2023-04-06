param tenantId string
param subscriptionId string = 'fc1a89fb-a3f7-4959-b325-efcd15bb63dc'
param storageAccountName string ='SA-DOE'
param sqlServerName string = 'DOE-SQL-Server'
param sqlDatabaseName string = 'DOE-SQL-DB'
param appServiceName string = 'DOE-AppService'
param resourceGroupName string = 'DOE-ResourceGroup'

// Define a custom role for managing storage account keys
resource storageAccountKeyRole 'Microsoft.Authorization/roleDefinitions@2020-04-01-preview' = {
  name: 'Storage Account Key Manager'
  properties: {
    roleName: 'Storage Account Key Manager'
    description: 'Lets you manage the keys of a Storage Account.'
    type: 'CustomRole'
    assignableScopes: [
      '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Storage/storageAccounts/${storageAccountName}'
    ]
    permissions: [
      {
        actions: [
          'Microsoft.Storage/storageAccounts/listKeys/action'
          'Microsoft.Storage/storageAccounts/regenerateKey/action'
        ]
        notActions: []
        dataActions: []
        notDataActions: []
      }
    ]
  }
}

// Define an assignment of the Storage Account Key Manager role to a user or group
resource storageAccountKeyRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: '${storageAccountName}-key-role-assignment'
  properties: {
    roleDefinitionId: storageAccountKeyRole.id
    principalId: '<insert-principal-id-here>' // replace with the object ID of the user or group to assign the role to
    //scope: storageAccountKeyRole.properties.assignableScopes[0]
  }
}

// Define a custom role for managing SQL databases
resource sqlDatabaseRole 'Microsoft.Authorization/roleDefinitions@2020-04-01-preview' = {
  name: 'SQL Database Manager'
  properties: {
    roleName: 'SQL Database Manager'
    description: 'Lets you manage SQL databases.'
    type: 'CustomRole'
    assignableScopes: [
      '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Sql/servers/${sqlServerName}'
    ]
    permissions: [
      {
        actions: [
          'Microsoft.Sql/servers/databases/read'
          'Microsoft.Sql/servers/databases/write'
          'Microsoft.Sql/servers/databases/delete'
          'Microsoft.Sql/servers/databases/backup/action'
        ]
        notActions: []
        dataActions: []
        notDataActions: []
      }
    ]
  }
}

// Define an assignment of the SQL Database Manager role to a user or group
resource sqlDatabaseRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: '${sqlDatabaseName}-db-role-assignment'
  properties: {
    roleDefinitionId: sqlDatabaseRole.id
    principalId: '<insert-principal-id-here>' // replace with the object ID of the user or group to assign the role to
    //scope: sqlDatabaseRole.properties.assignableScopes[0]
  }
}

// Define a custom role for deploying code to an App Service
resource appServiceDeployRole 'Microsoft.Authorization/roleDefinitions@2020-04-01-preview' = {
  name: 'App Service Deployer'
  properties: {
    roleName: 'App Service Deployer'
    description: 'Lets you deploy code to an App Service.'
    type: 'CustomRole'
    assignableScopes: [
      '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Web/sites/${appServiceName}'
    ]
    permissions: [
      {
        actions: [
          'Microsoft.Web/sites/restart/action'
        ]
        notActions: []
        dataActions: []
        notDataActions: []
      }
    ]}
  }
  
  // Define an assignment of the App Service Deployer role to a user or group
  resource appServiceDeployRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: '${appServiceName}-deploy-role-assignment'
  properties: {
  roleDefinitionId: appServiceDeployRole.id
  principalId: '<insert-principal-id-here>' // replace with the object ID of the user or group to assign the role to
  //scope: appServiceDeployRole.properties.assignableScopes[0]
  }
  }

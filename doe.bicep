param subscriptionId string = '6f0df019-2355-4c0a-9fe5-fe4f493f38a7'

targetScope = 'subscription'

param storageAccountName string = 'SA-DOE'

param sqlServerName string = 'DOE-SQL-Server'

param sqlDatabaseName string = 'DOE-SQL-DB'

param appServiceName string = 'DOE-AppService'

param resourceGroupName string = 'RG-DataCenterOps-EastUS-IOE'

param principalId string = '1eaa631b-0c7d-40cf-a1be-41cba507a2bb'

resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {

  scope: subscription()

  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'

}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {

  name: guid(resourceGroupName, principalId, contributorRoleDefinition.id)

  properties: {

    roleDefinitionId: contributorRoleDefinition.id

    principalId: principalId

    principalType: 'User'

  }

}

resource sqlServerRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('${sqlServerName}-Contributor-Role-Assignment', principalId, contributorRoleDefinition.id)
  properties: {
    principalId: principalId
    roleDefinitionId: contributorRoleDefinition.id // Contributor role ID
  }
}

// Define an assignment of the App Service Deployer role to a user or group

resource appServiceDeployRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
 name: guid('${appServiceName}-deploy-role-assignment', principalId, contributorRoleDefinition.id)
  properties: {
    roleDefinitionId: contributorRoleDefinition.id
    principalId: principalId // replace with the object ID of the user or group to assign the role to
  }

}

// Define an assignment of the Storage Account Key Manager role to a user or group

resource storageAccountKeyRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('${storageAccountName}-key-role-assignment', principalId, contributorRoleDefinition.id)
  properties: {
    roleDefinitionId: contributorRoleDefinition.id
    principalId: principalId // replace with the object ID of the user or group to assign the role to
  }

}

resource sqlDatabaseRoleAssignment 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid('${sqlDatabaseName}-db-role-assignment', principalId, contributorRoleDefinition.id)
  properties: {
    roleName: contributorRoleDefinition.id // Contributor role ID}
  }
}



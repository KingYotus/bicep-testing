var location = resourceGroup().location
param enviroment string

@minLength(3)
@maxLength(11)
param storagePrefix string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'

var uniqueStorageName = '${storagePrefix}${enviroment}'

resource stg 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

resource services 'Microsoft.Storage/storageAccounts/tableServices@2021-08-01' = {
  name: 'default'
  parent: stg
}

resource storageaccount_tableService_table 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-08-01' = {
  name: '${storagePrefix}table${enviroment}'
  parent: services
}

resource storageaccount_queueservice_queue 'Microsoft.Storage/storageAccounts/queueServices@2023-01-01' = {
  name: 'default'
  parent: stg
}

resource queue 'Microsoft.Storage/storageAccounts/queueServices/queues@2023-01-01' = {
  name: '${storagePrefix}queue${enviroment}'
  parent: storageaccount_queueservice_queue
}

var location = resourceGroup().location
param enviroment string

// Event Grid Topic
resource eventGridTopic 'Microsoft.EventGrid/topics@2023-12-15-preview' = {
  name: 'bicep-testing-${enviroment}'
  location: location
  properties: {
    inputSchema: 'EventGridSchema'
  }
}

output topicEndpoint string = eventGridTopic.properties.endpoint

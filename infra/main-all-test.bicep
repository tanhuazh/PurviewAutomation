targetScope = 'subscription'

param location string
param prefix string

module prerequisites 'main-preq.bicep' = {
  name: 'prerequisites'
  params: {
    location: location
    prefix: prefix
  }
}

module main 'main-test.bicep' = {
  name: 'main'
  params: {
    createEventSubscription: true
    eventGridTopicSourceSubscriptions: ['7f155fd6-3949-4a06-a388-93905a63ce93']
    functionSubnetId: prerequisites.outputs.functionSubnetId
    location: location
    prefix: prefix
    // purviewId: prerequisites.outputs.purviewId
    // purviewManagedEventHubId: prerequisites.outputs.purviewManagedEventHubId
    // purviewManagedStorageId: prerequisites.outputs.purviewManagedStorageId
    // purviewRootCollectionMetadataPolicyId: 'test'
    repositoryUrl: ''
    subnetId: prerequisites.outputs.subnetId
  }
}

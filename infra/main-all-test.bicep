targetScope = 'subscription'

param location string
param prefix string
param eventGridTopicSourceSubscriptions array

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
    eventGridTopicSourceSubscriptions: eventGridTopicSourceSubscriptions
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

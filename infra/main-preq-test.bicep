// Licensed under the MIT license.

targetScope = 'subscription'

// General parameters
@description('Specifies the location for all resources.')
param location string
@allowed([
  'dev'
  'tst'
  'prd'
])
@description('Specifies the environment of the deployment.')
param environment string = 'dev'
@minLength(2)
@maxLength(10)
@description('Specifies the prefix for all resources created in this deployment.')
param prefix string
@description('Specifies the tags that you want to apply to all resources.')
param tags object = {}

// Network parameters
@description('Specifies the address space of the vnet.')
param vnetAddressPrefix string = '10.0.0.0/24'
@description('Specifies the address space of the subnet that is used for the services.')
param servicesSubnetAddressPrefix string = '10.0.0.0/27'
@description('Specifies the address space of the subnet that is use for Azure Firewall. Optional if `enableDnsAndFirewallDeployment` is set to `true`.')
param functionSubnetAddressPrefix string = '10.0.0.32/27'

// Variables
var name = toLower('${prefix}-${environment}')
var tagsDefault = {
  Owner: 'Data Management and Analytics Scenario'
  Project: 'Data Management and Analytics Scenario'
  Environment: environment
  Toolkit: 'bicep'
  Name: name
}
var tagsJoined = union(tagsDefault, tags)

// Network resources
resource networkResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${name}-network'
  location: location
  tags: tagsJoined
  properties: {}
}

module networkServices 'modules/network.bicep' = {
  name: 'networkServices'
  scope: networkResourceGroup
  params: {
    prefix: name
    location: location
    tags: tagsJoined
    vnetAddressPrefix: vnetAddressPrefix
    servicesSubnetAddressPrefix: servicesSubnetAddressPrefix
    functionSubnetAddressPrefix: functionSubnetAddressPrefix
  }
}

// Outputs
output location string = location
output environment string = environment
output prefix string = prefix
output tags object = tags
output purviewRootCollectionMetadataPolicyId string = 'Please check the docs to understand how to obtain that GUID'
output eventGridTopicSourceSubscriptions array = [
  {
    subscriptionId: subscription().subscriptionId
    location: location
  }
]
output createEventSubscription bool = false
output subnetId string = networkServices.outputs.servicesSubnetId
output functionSubnetId string = networkServices.outputs.functionSubnetId


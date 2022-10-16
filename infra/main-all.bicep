targetScope = 'subscription'

param location string
param prefix string

module functionResources 'main-preq-test.bicep' = {
  name: 'prerequisites'
  params: {
    location: location
    prefix: prefix
  }
}

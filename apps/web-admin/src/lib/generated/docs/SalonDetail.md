
# SalonDetail


## Properties

Name | Type
------------ | -------------
`id` | string
`name` | string
`category` | string
`logoUrl` | string
`city` | string
`neighborhood` | string
`averageRating` | number
`latitude` | number
`longitude` | number
`subscriptionTier` | string
`featured` | boolean
`isPrestige` | boolean
`prestigeScore` | number
`distanceKm` | number
`description` | string
`address` | string
`gallery` | Array&lt;string&gt;
`services` | [Array&lt;SalonDetailServicesInner&gt;](SalonDetailServicesInner.md)
`teamDisplay` | [SalonDetailTeamDisplay](SalonDetailTeamDisplay.md)
`staff` | [Array&lt;SalonDetailStaffInner&gt;](SalonDetailStaffInner.md)

## Example

```typescript
import type { SalonDetail } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "name": null,
  "category": null,
  "logoUrl": null,
  "city": null,
  "neighborhood": null,
  "averageRating": null,
  "latitude": null,
  "longitude": null,
  "subscriptionTier": null,
  "featured": null,
  "isPrestige": null,
  "prestigeScore": null,
  "distanceKm": null,
  "description": null,
  "address": null,
  "gallery": null,
  "services": null,
  "teamDisplay": null,
  "staff": null,
} satisfies SalonDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SalonDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



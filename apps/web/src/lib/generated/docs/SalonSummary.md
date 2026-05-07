
# SalonSummary


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

## Example

```typescript
import type { SalonSummary } from ''

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
} satisfies SalonSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SalonSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



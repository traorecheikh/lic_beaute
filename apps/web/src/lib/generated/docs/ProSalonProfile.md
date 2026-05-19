
# ProSalonProfile


## Properties

Name | Type
------------ | -------------
`id` | string
`name` | string
`category` | string
`logoUrl` | string
`description` | string
`city` | string
`address` | string
`neighborhood` | string
`latitude` | number
`longitude` | number
`phone` | string
`instagram` | string
`averageRating` | number
`subscriptionTier` | string
`isVisibleInMarketplace` | boolean
`canReceiveBookings` | boolean
`approvalStatus` | string
`teamDisplay` | [SalonDetailTeamDisplay](SalonDetailTeamDisplay.md)
`gallery` | Array&lt;string&gt;
`hours` | [Array&lt;ProSalonProfileHoursInner&gt;](ProSalonProfileHoursInner.md)

## Example

```typescript
import type { ProSalonProfile } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "name": null,
  "category": null,
  "logoUrl": null,
  "description": null,
  "city": null,
  "address": null,
  "neighborhood": null,
  "latitude": null,
  "longitude": null,
  "phone": null,
  "instagram": null,
  "averageRating": null,
  "subscriptionTier": null,
  "isVisibleInMarketplace": null,
  "canReceiveBookings": null,
  "approvalStatus": null,
  "teamDisplay": null,
  "gallery": null,
  "hours": null,
} satisfies ProSalonProfile

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProSalonProfile
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)




# AdminSubscriptionSummary


## Properties

Name | Type
------------ | -------------
`id` | string
`salonId` | string
`salonName` | string
`tier` | string
`status` | string
`billingProvider` | string
`expiresAt` | Date
`autoRenew` | boolean
`isComplimentary` | boolean

## Example

```typescript
import type { AdminSubscriptionSummary } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "salonId": null,
  "salonName": null,
  "tier": null,
  "status": null,
  "billingProvider": null,
  "expiresAt": null,
  "autoRenew": null,
  "isComplimentary": null,
} satisfies AdminSubscriptionSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminSubscriptionSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



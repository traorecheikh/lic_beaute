
# ProSubscription


## Properties

Name | Type
------------ | -------------
`id` | string
`tier` | string
`status` | string
`renewsAt` | Date
`expiresAt` | Date
`isComplimentary` | boolean
`autoRenew` | boolean
`billingMethod` | [ProSubscriptionBillingMethod](ProSubscriptionBillingMethod.md)

## Example

```typescript
import type { ProSubscription } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "tier": null,
  "status": null,
  "renewsAt": null,
  "expiresAt": null,
  "isComplimentary": null,
  "autoRenew": null,
  "billingMethod": null,
} satisfies ProSubscription

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProSubscription
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



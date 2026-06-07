
# AdminSubscriptionDetail


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
`startedAt` | Date
`renewedAt` | Date
`entitlements` | [Array&lt;AdminSubscriptionDetailEntitlementsInner&gt;](AdminSubscriptionDetailEntitlementsInner.md)
`events` | [Array&lt;AdminSubscriptionDetailEventsInner&gt;](AdminSubscriptionDetailEventsInner.md)
`invoices` | [Array&lt;AdminSubscriptionDetailInvoicesInner&gt;](AdminSubscriptionDetailInvoicesInner.md)
`pendingCharges` | [Array&lt;AdminSubscriptionDetailPendingChargesInner&gt;](AdminSubscriptionDetailPendingChargesInner.md)

## Example

```typescript
import type { AdminSubscriptionDetail } from ''

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
  "startedAt": null,
  "renewedAt": null,
  "entitlements": null,
  "events": null,
  "invoices": null,
  "pendingCharges": null,
} satisfies AdminSubscriptionDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminSubscriptionDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



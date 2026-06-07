
# ProCheckoutDetails


## Properties

Name | Type
------------ | -------------
`bookingId` | string
`status` | string
`clientName` | string
`clientPhone` | string
`serviceName` | string
`startsAt` | Date
`staffName` | string
`subtotalXof` | number
`depositPaidXof` | number
`balanceXof` | number
`lineItems` | [Array&lt;ProCheckoutDetailsLineItemsInner&gt;](ProCheckoutDetailsLineItemsInner.md)

## Example

```typescript
import type { ProCheckoutDetails } from ''

// TODO: Update the object below with actual values
const example = {
  "bookingId": null,
  "status": null,
  "clientName": null,
  "clientPhone": null,
  "serviceName": null,
  "startsAt": null,
  "staffName": null,
  "subtotalXof": null,
  "depositPaidXof": null,
  "balanceXof": null,
  "lineItems": null,
} satisfies ProCheckoutDetails

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProCheckoutDetails
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



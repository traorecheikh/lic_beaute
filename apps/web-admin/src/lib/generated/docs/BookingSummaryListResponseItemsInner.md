
# BookingSummaryListResponseItemsInner


## Properties

Name | Type
------------ | -------------
`id` | string
`salonId` | string
`salonName` | string
`serviceId` | string
`serviceName` | string
`startsAt` | Date
`endsAt` | Date
`status` | string
`source` | string
`depositAmountXof` | number
`depositPaymentStatus` | string
`paymentProvider` | string
`paymentId` | string

## Example

```typescript
import type { BookingSummaryListResponseItemsInner } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "salonId": null,
  "salonName": null,
  "serviceId": null,
  "serviceName": null,
  "startsAt": null,
  "endsAt": null,
  "status": null,
  "source": null,
  "depositAmountXof": null,
  "depositPaymentStatus": null,
  "paymentProvider": null,
  "paymentId": null,
} satisfies BookingSummaryListResponseItemsInner

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BookingSummaryListResponseItemsInner
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



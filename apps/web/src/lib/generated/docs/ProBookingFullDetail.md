
# ProBookingFullDetail


## Properties

Name | Type
------------ | -------------
`id` | string
`salonId` | string
`serviceId` | string
`serviceName` | string
`employeeId` | string
`employeeName` | string
`clientId` | string
`clientName` | string
`clientPhone` | string
`startsAt` | Date
`endsAt` | Date
`status` | string
`source` | string
`depositAmountXof` | number
`createdAt` | Date
`payments` | [Array&lt;ProBookingFullDetailPaymentsInner&gt;](ProBookingFullDetailPaymentsInner.md)
`events` | [Array&lt;ProBookingFullDetailEventsInner&gt;](ProBookingFullDetailEventsInner.md)

## Example

```typescript
import type { ProBookingFullDetail } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "salonId": null,
  "serviceId": null,
  "serviceName": null,
  "employeeId": null,
  "employeeName": null,
  "clientId": null,
  "clientName": null,
  "clientPhone": null,
  "startsAt": null,
  "endsAt": null,
  "status": null,
  "source": null,
  "depositAmountXof": null,
  "createdAt": null,
  "payments": null,
  "events": null,
} satisfies ProBookingFullDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProBookingFullDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



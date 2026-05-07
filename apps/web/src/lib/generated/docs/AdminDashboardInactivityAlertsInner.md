
# AdminDashboardInactivityAlertsInner


## Properties

Name | Type
------------ | -------------
`salonId` | string
`salonName` | string
`daysWithoutBookings` | number
`city` | string
`status` | string

## Example

```typescript
import type { AdminDashboardInactivityAlertsInner } from ''

// TODO: Update the object below with actual values
const example = {
  "salonId": null,
  "salonName": null,
  "daysWithoutBookings": null,
  "city": null,
  "status": null,
} satisfies AdminDashboardInactivityAlertsInner

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminDashboardInactivityAlertsInner
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



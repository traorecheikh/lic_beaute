
# ProPayoutEvent


## Properties

Name | Type
------------ | -------------
`id` | string
`bookingId` | string
`eventType` | string
`amountXof` | number
`createdAt` | Date

## Example

```typescript
import type { ProPayoutEvent } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "bookingId": null,
  "eventType": null,
  "amountXof": null,
  "createdAt": null,
} satisfies ProPayoutEvent

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProPayoutEvent
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)




# ProManualBookingInput


## Properties

Name | Type
------------ | -------------
`clientId` | string
`serviceId` | string
`employeeId` | string
`startsAt` | Date
`clientName` | string
`clientPhone` | string

## Example

```typescript
import type { ProManualBookingInput } from ''

// TODO: Update the object below with actual values
const example = {
  "clientId": null,
  "serviceId": null,
  "employeeId": null,
  "startsAt": null,
  "clientName": null,
  "clientPhone": null,
} satisfies ProManualBookingInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProManualBookingInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



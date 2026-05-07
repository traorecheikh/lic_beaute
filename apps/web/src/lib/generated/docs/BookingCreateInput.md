
# BookingCreateInput


## Properties

Name | Type
------------ | -------------
`salonId` | string
`serviceId` | string
`employeeId` | string
`startsAt` | Date
`clientNote` | string
`provider` | string
`channel` | string

## Example

```typescript
import type { BookingCreateInput } from ''

// TODO: Update the object below with actual values
const example = {
  "salonId": null,
  "serviceId": null,
  "employeeId": null,
  "startsAt": null,
  "clientNote": null,
  "provider": null,
  "channel": null,
} satisfies BookingCreateInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as BookingCreateInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



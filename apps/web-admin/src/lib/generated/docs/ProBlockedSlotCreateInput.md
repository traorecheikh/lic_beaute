
# ProBlockedSlotCreateInput


## Properties

Name | Type
------------ | -------------
`startsAt` | Date
`endsAt` | Date
`reason` | string
`scope` | string
`employeeId` | string

## Example

```typescript
import type { ProBlockedSlotCreateInput } from ''

// TODO: Update the object below with actual values
const example = {
  "startsAt": null,
  "endsAt": null,
  "reason": null,
  "scope": null,
  "employeeId": null,
} satisfies ProBlockedSlotCreateInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProBlockedSlotCreateInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



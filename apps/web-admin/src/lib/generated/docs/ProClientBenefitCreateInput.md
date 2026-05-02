
# ProClientBenefitCreateInput


## Properties

Name | Type
------------ | -------------
`clientId` | string
`kind` | string
`name` | string
`remainingUses` | number
`expiresAt` | Date
`billingDate` | Date

## Example

```typescript
import type { ProClientBenefitCreateInput } from ''

// TODO: Update the object below with actual values
const example = {
  "clientId": null,
  "kind": null,
  "name": null,
  "remainingUses": null,
  "expiresAt": null,
  "billingDate": null,
} satisfies ProClientBenefitCreateInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProClientBenefitCreateInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



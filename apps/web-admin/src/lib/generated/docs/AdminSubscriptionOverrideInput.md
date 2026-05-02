
# AdminSubscriptionOverrideInput


## Properties

Name | Type
------------ | -------------
`action` | string
`reason` | string
`effectiveAt` | Date
`expiresAt` | Date
`metadata` | [AdminSubscriptionOverrideInputMetadata](AdminSubscriptionOverrideInputMetadata.md)

## Example

```typescript
import type { AdminSubscriptionOverrideInput } from ''

// TODO: Update the object below with actual values
const example = {
  "action": null,
  "reason": null,
  "effectiveAt": null,
  "expiresAt": null,
  "metadata": null,
} satisfies AdminSubscriptionOverrideInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminSubscriptionOverrideInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



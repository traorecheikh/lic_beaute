
# ProSubscriptionUpdateInput


## Properties

Name | Type
------------ | -------------
`autoRenew` | boolean
`billingMethod` | [ProSubscriptionUpdateInputBillingMethod](ProSubscriptionUpdateInputBillingMethod.md)

## Example

```typescript
import type { ProSubscriptionUpdateInput } from ''

// TODO: Update the object below with actual values
const example = {
  "autoRenew": null,
  "billingMethod": null,
} satisfies ProSubscriptionUpdateInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProSubscriptionUpdateInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



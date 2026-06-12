
# ProSubscriptionCheckoutInput


## Properties

Name | Type
------------ | -------------
`action` | string
`tier` | string
`provider` | string
`billingCycle` | string
`channel` | string

## Example

```typescript
import type { ProSubscriptionCheckoutInput } from ''

// TODO: Update the object below with actual values
const example = {
  "action": null,
  "tier": null,
  "provider": null,
  "billingCycle": null,
  "channel": null,
} satisfies ProSubscriptionCheckoutInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProSubscriptionCheckoutInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



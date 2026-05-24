
# ProSubscriptionExecuteResponse


## Properties

Name | Type
------------ | -------------
`success` | boolean
`status` | string
`providerTxId` | string
`message` | string
`url` | string
`other_url` | [PaydunyaExecutePaymentResponseOtherUrl](PaydunyaExecutePaymentResponseOtherUrl.md)
`data` | { [key: string]: any; }

## Example

```typescript
import type { ProSubscriptionExecuteResponse } from ''

// TODO: Update the object below with actual values
const example = {
  "success": null,
  "status": null,
  "providerTxId": null,
  "message": null,
  "url": null,
  "other_url": null,
  "data": null,
} satisfies ProSubscriptionExecuteResponse

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProSubscriptionExecuteResponse
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



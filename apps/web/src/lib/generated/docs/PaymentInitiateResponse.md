
# PaymentInitiateResponse


## Properties

Name | Type
------------ | -------------
`paymentId` | string
`redirectUrl` | string
`expiresAt` | Date

## Example

```typescript
import type { PaymentInitiateResponse } from ''

// TODO: Update the object below with actual values
const example = {
  "paymentId": null,
  "redirectUrl": null,
  "expiresAt": null,
} satisfies PaymentInitiateResponse

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PaymentInitiateResponse
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



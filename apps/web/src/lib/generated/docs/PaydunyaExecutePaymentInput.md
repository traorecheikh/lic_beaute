
# PaydunyaExecutePaymentInput


## Properties

Name | Type
------------ | -------------
`paymentId` | string
`method` | string
`details` | { [key: string]: any; }

## Example

```typescript
import type { PaydunyaExecutePaymentInput } from ''

// TODO: Update the object below with actual values
const example = {
  "paymentId": null,
  "method": null,
  "details": null,
} satisfies PaydunyaExecutePaymentInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PaydunyaExecutePaymentInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



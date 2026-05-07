
# PaymentWebhookBody


## Properties

Name | Type
------------ | -------------
`idFromGu` | string
`idFromClient` | string
`code` | string
`status` | string
`amount` | [PaymentWebhookBodyAmount](PaymentWebhookBodyAmount.md)
`amountWithoutFees` | [PaymentWebhookBodyAmount](PaymentWebhookBodyAmount.md)
`serviceCode` | string
`infoHash` | string
`secureHash` | string

## Example

```typescript
import type { PaymentWebhookBody } from ''

// TODO: Update the object below with actual values
const example = {
  "idFromGu": null,
  "idFromClient": null,
  "code": null,
  "status": null,
  "amount": null,
  "amountWithoutFees": null,
  "serviceCode": null,
  "infoHash": null,
  "secureHash": null,
} satisfies PaymentWebhookBody

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as PaymentWebhookBody
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



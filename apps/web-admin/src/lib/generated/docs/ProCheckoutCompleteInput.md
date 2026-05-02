
# ProCheckoutCompleteInput


## Properties

Name | Type
------------ | -------------
`paymentMethod` | string
`lineItems` | [Array&lt;ProCheckoutDetailsLineItemsInner&gt;](ProCheckoutDetailsLineItemsInner.md)
`discountXof` | number

## Example

```typescript
import type { ProCheckoutCompleteInput } from ''

// TODO: Update the object below with actual values
const example = {
  "paymentMethod": null,
  "lineItems": null,
  "discountXof": null,
} satisfies ProCheckoutCompleteInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProCheckoutCompleteInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



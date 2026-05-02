
# ProInvoice


## Properties

Name | Type
------------ | -------------
`id` | string
`invoiceNumber` | string
`amountXof` | number
`status` | string
`createdAt` | Date
`pdfUrl` | string

## Example

```typescript
import type { ProInvoice } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "invoiceNumber": null,
  "amountXof": null,
  "status": null,
  "createdAt": null,
  "pdfUrl": null,
} satisfies ProInvoice

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProInvoice
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)




# ProVoucherCreateInput


## Properties

Name | Type
------------ | -------------
`code` | string
`title` | string
`description` | string
`discountLabel` | string
`expiresAt` | Date
`maxRedemptions` | number

## Example

```typescript
import type { ProVoucherCreateInput } from ''

// TODO: Update the object below with actual values
const example = {
  "code": null,
  "title": null,
  "description": null,
  "discountLabel": null,
  "expiresAt": null,
  "maxRedemptions": null,
} satisfies ProVoucherCreateInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProVoucherCreateInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



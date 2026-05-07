
# ApiV1MeAddressesPostRequest


## Properties

Name | Type
------------ | -------------
`label` | string
`addressLine1` | string
`addressLine2` | string
`city` | string
`region` | string
`phone` | string
`isDefault` | boolean

## Example

```typescript
import type { ApiV1MeAddressesPostRequest } from ''

// TODO: Update the object below with actual values
const example = {
  "label": null,
  "addressLine1": null,
  "addressLine2": null,
  "city": null,
  "region": null,
  "phone": null,
  "isDefault": null,
} satisfies ApiV1MeAddressesPostRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ApiV1MeAddressesPostRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



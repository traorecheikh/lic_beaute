
# ApiV1ConfigPricingGet200Response


## Properties

Name | Type
------------ | -------------
`standard` | [ApiV1ConfigPricingGet200ResponseStandard](ApiV1ConfigPricingGet200ResponseStandard.md)
`premium` | [ApiV1ConfigPricingGet200ResponseStandard](ApiV1ConfigPricingGet200ResponseStandard.md)
`commissionPercent` | number

## Example

```typescript
import type { ApiV1ConfigPricingGet200Response } from ''

// TODO: Update the object below with actual values
const example = {
  "standard": null,
  "premium": null,
  "commissionPercent": null,
} satisfies ApiV1ConfigPricingGet200Response

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ApiV1ConfigPricingGet200Response
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)




# ProServiceUpdateInput


## Properties

Name | Type
------------ | -------------
`name` | string
`category` | string
`durationMinutes` | number
`priceXof` | number
`depositMode` | string
`depositAmountXof` | number
`depositPercent` | number

## Example

```typescript
import type { ProServiceUpdateInput } from ''

// TODO: Update the object below with actual values
const example = {
  "name": null,
  "category": null,
  "durationMinutes": null,
  "priceXof": null,
  "depositMode": null,
  "depositAmountXof": null,
  "depositPercent": null,
} satisfies ProServiceUpdateInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProServiceUpdateInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



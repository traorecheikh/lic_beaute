
# AdminSubscriptionListResponse


## Properties

Name | Type
------------ | -------------
`summary` | [AdminSubscriptionListResponseSummary](AdminSubscriptionListResponseSummary.md)
`items` | [Array&lt;AdminSubscriptionListResponseItemsInner&gt;](AdminSubscriptionListResponseItemsInner.md)
`total` | number

## Example

```typescript
import type { AdminSubscriptionListResponse } from ''

// TODO: Update the object below with actual values
const example = {
  "summary": null,
  "items": null,
  "total": null,
} satisfies AdminSubscriptionListResponse

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminSubscriptionListResponse
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



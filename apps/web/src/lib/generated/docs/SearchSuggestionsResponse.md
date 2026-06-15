
# SearchSuggestionsResponse


## Properties

Name | Type
------------ | -------------
`normalizedQuery` | string
`didYouMean` | string
`suggestions` | [Array&lt;SearchSuggestionsResponseSuggestionsInner&gt;](SearchSuggestionsResponseSuggestionsInner.md)
`entityHints` | [Array&lt;SearchSuggestionsResponseEntityHintsInner&gt;](SearchSuggestionsResponseEntityHintsInner.md)
`topMatches` | [Array&lt;SearchSuggestionsResponseTopMatchesInner&gt;](SearchSuggestionsResponseTopMatchesInner.md)

## Example

```typescript
import type { SearchSuggestionsResponse } from ''

// TODO: Update the object below with actual values
const example = {
  "normalizedQuery": null,
  "didYouMean": null,
  "suggestions": null,
  "entityHints": null,
  "topMatches": null,
} satisfies SearchSuggestionsResponse

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SearchSuggestionsResponse
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)




# SearchSalonsResponseQuery


## Properties

Name | Type
------------ | -------------
`normalized` | string
`corrected` | string
`interpretedEntities` | [Array&lt;SearchSuggestionsResponseEntityHintsInner&gt;](SearchSuggestionsResponseEntityHintsInner.md)

## Example

```typescript
import type { SearchSalonsResponseQuery } from ''

// TODO: Update the object below with actual values
const example = {
  "normalized": null,
  "corrected": null,
  "interpretedEntities": null,
} satisfies SearchSalonsResponseQuery

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SearchSalonsResponseQuery
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



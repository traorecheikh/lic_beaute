
# SearchSalonsResponse


## Properties

Name | Type
------------ | -------------
`query` | [SearchSalonsResponseQuery](SearchSalonsResponseQuery.md)
`facets` | [SearchSalonsResponseFacets](SearchSalonsResponseFacets.md)
`results` | [Array&lt;SearchSuggestionsResponseTopMatchesInner&gt;](SearchSuggestionsResponseTopMatchesInner.md)
`modules` | [Array&lt;SearchSalonsResponseModulesInner&gt;](SearchSalonsResponseModulesInner.md)
`pageInfo` | [SearchSalonsResponsePageInfo](SearchSalonsResponsePageInfo.md)

## Example

```typescript
import type { SearchSalonsResponse } from ''

// TODO: Update the object below with actual values
const example = {
  "query": null,
  "facets": null,
  "results": null,
  "modules": null,
  "pageInfo": null,
} satisfies SearchSalonsResponse

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SearchSalonsResponse
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)




# SearchSalonsResponseFacets


## Properties

Name | Type
------------ | -------------
`categories` | [Array&lt;SearchSalonsResponseFacetsCategoriesInner&gt;](SearchSalonsResponseFacetsCategoriesInner.md)
`cities` | [Array&lt;SearchSalonsResponseFacetsCategoriesInner&gt;](SearchSalonsResponseFacetsCategoriesInner.md)
`neighborhoods` | [Array&lt;SearchSalonsResponseFacetsCategoriesInner&gt;](SearchSalonsResponseFacetsCategoriesInner.md)
`priceRanges` | [Array&lt;SearchSalonsResponseFacetsCategoriesInner&gt;](SearchSalonsResponseFacetsCategoriesInner.md)
`openNowCount` | number
`bookableSoonCount` | number

## Example

```typescript
import type { SearchSalonsResponseFacets } from ''

// TODO: Update the object below with actual values
const example = {
  "categories": null,
  "cities": null,
  "neighborhoods": null,
  "priceRanges": null,
  "openNowCount": null,
  "bookableSoonCount": null,
} satisfies SearchSalonsResponseFacets

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SearchSalonsResponseFacets
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



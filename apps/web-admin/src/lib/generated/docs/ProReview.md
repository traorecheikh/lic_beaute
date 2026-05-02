
# ProReview


## Properties

Name | Type
------------ | -------------
`id` | string
`rating` | number
`comment` | string
`createdAt` | Date
`responseText` | string
`responseAt` | Date
`clientId` | string

## Example

```typescript
import type { ProReview } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "rating": null,
  "comment": null,
  "createdAt": null,
  "responseText": null,
  "responseAt": null,
  "clientId": null,
} satisfies ProReview

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProReview
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)




# ProClientSummary


## Properties

Name | Type
------------ | -------------
`id` | string
`fullName` | string
`phone` | string
`email` | string
`visitCount` | number
`totalSpentXof` | number
`lastVisitAt` | Date

## Example

```typescript
import type { ProClientSummary } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "fullName": null,
  "phone": null,
  "email": null,
  "visitCount": null,
  "totalSpentXof": null,
  "lastVisitAt": null,
} satisfies ProClientSummary

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProClientSummary
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



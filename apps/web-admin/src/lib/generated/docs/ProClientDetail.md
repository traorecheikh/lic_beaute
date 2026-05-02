
# ProClientDetail


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
`recentBookings` | [Array&lt;ProClientDetailRecentBookingsInner&gt;](ProClientDetailRecentBookingsInner.md)

## Example

```typescript
import type { ProClientDetail } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "fullName": null,
  "phone": null,
  "email": null,
  "visitCount": null,
  "totalSpentXof": null,
  "lastVisitAt": null,
  "recentBookings": null,
} satisfies ProClientDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProClientDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



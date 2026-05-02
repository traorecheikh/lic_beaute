
# AdminSalonQueueItem


## Properties

Name | Type
------------ | -------------
`id` | string
`salonName` | string
`category` | string
`city` | string
`ownerName` | string
`submittedAt` | Date
`approvalStatus` | string
`subscriptionIntentTier` | string
`missingEvidence` | Array&lt;string&gt;
`latestAdminNote` | string

## Example

```typescript
import type { AdminSalonQueueItem } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "salonName": null,
  "category": null,
  "city": null,
  "ownerName": null,
  "submittedAt": null,
  "approvalStatus": null,
  "subscriptionIntentTier": null,
  "missingEvidence": null,
  "latestAdminNote": null,
} satisfies AdminSalonQueueItem

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminSalonQueueItem
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



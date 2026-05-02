
# AdminSalonDetail


## Properties

Name | Type
------------ | -------------
`id` | string
`salonName` | string
`category` | string
`city` | string
`address` | string
`description` | string
`owner` | [AdminSalonDetailOwner](AdminSalonDetailOwner.md)
`approvalStatus` | string
`subscriptionIntentTier` | string
`submittedAt` | Date
`missingEvidence` | Array&lt;string&gt;
`latestAdminNote` | string
`gallery` | Array&lt;string&gt;
`services` | [Array&lt;AdminSalonDetailServicesInner&gt;](AdminSalonDetailServicesInner.md)
`documents` | [Array&lt;AdminSalonDetailDocumentsInner&gt;](AdminSalonDetailDocumentsInner.md)

## Example

```typescript
import type { AdminSalonDetail } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "salonName": null,
  "category": null,
  "city": null,
  "address": null,
  "description": null,
  "owner": null,
  "approvalStatus": null,
  "subscriptionIntentTier": null,
  "submittedAt": null,
  "missingEvidence": null,
  "latestAdminNote": null,
  "gallery": null,
  "services": null,
  "documents": null,
} satisfies AdminSalonDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminSalonDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



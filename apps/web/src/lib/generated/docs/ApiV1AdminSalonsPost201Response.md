
# ApiV1AdminSalonsPost201Response


## Properties

Name | Type
------------ | -------------
`id` | string
`salonName` | string
`category` | string
`city` | string
`address` | string
`description` | string
`owner` | [ApiV1AdminSalonsPost201ResponseOwner](ApiV1AdminSalonsPost201ResponseOwner.md)
`approvalStatus` | string
`subscriptionIntentTier` | string
`submittedAt` | Date
`missingEvidence` | Array&lt;string&gt;
`latestAdminNote` | string
`gallery` | Array&lt;string&gt;
`services` | [Array&lt;ApiV1AdminSalonsPost201ResponseServicesInner&gt;](ApiV1AdminSalonsPost201ResponseServicesInner.md)
`documents` | [Array&lt;ApiV1AdminSalonsPost201ResponseDocumentsInner&gt;](ApiV1AdminSalonsPost201ResponseDocumentsInner.md)
`temporaryPassword` | string

## Example

```typescript
import type { ApiV1AdminSalonsPost201Response } from ''

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
  "temporaryPassword": null,
} satisfies ApiV1AdminSalonsPost201Response

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ApiV1AdminSalonsPost201Response
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



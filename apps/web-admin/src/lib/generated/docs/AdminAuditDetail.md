
# AdminAuditDetail


## Properties

Name | Type
------------ | -------------
`id` | string
`action` | string
`summary` | string
`entityType` | string
`entityId` | string
`actorName` | string
`createdAt` | Date
`severity` | string
`payloadJson` | string
`relatedLinks` | [Array&lt;AdminAuditDetailRelatedLinksInner&gt;](AdminAuditDetailRelatedLinksInner.md)

## Example

```typescript
import type { AdminAuditDetail } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "action": null,
  "summary": null,
  "entityType": null,
  "entityId": null,
  "actorName": null,
  "createdAt": null,
  "severity": null,
  "payloadJson": null,
  "relatedLinks": null,
} satisfies AdminAuditDetail

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminAuditDetail
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



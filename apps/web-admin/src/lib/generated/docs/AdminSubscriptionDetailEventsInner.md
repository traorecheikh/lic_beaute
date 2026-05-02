
# AdminSubscriptionDetailEventsInner


## Properties

Name | Type
------------ | -------------
`id` | string
`eventType` | string
`summary` | string
`createdAt` | Date
`actorName` | string
`source` | string
`payloadPreview` | string

## Example

```typescript
import type { AdminSubscriptionDetailEventsInner } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "eventType": null,
  "summary": null,
  "createdAt": null,
  "actorName": null,
  "source": null,
  "payloadPreview": null,
} satisfies AdminSubscriptionDetailEventsInner

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminSubscriptionDetailEventsInner
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



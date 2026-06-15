
# SearchEventsRequestEventsInner


## Properties

Name | Type
------------ | -------------
`sessionKey` | string
`eventType` | string
`query` | string
`salonId` | string
`category` | string
`city` | string
`position` | number
`metadata` | { [key: string]: any; }

## Example

```typescript
import type { SearchEventsRequestEventsInner } from ''

// TODO: Update the object below with actual values
const example = {
  "sessionKey": null,
  "eventType": null,
  "query": null,
  "salonId": null,
  "category": null,
  "city": null,
  "position": null,
  "metadata": null,
} satisfies SearchEventsRequestEventsInner

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as SearchEventsRequestEventsInner
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



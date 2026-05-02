
# ProAnalytics


## Properties

Name | Type
------------ | -------------
`period` | string
`bookingCount` | number
`completedCount` | number
`occupancyPercent` | number
`totalRevenueXof` | number
`topServices` | [Array&lt;ProAnalyticsTopServicesInner&gt;](ProAnalyticsTopServicesInner.md)

## Example

```typescript
import type { ProAnalytics } from ''

// TODO: Update the object below with actual values
const example = {
  "period": null,
  "bookingCount": null,
  "completedCount": null,
  "occupancyPercent": null,
  "totalRevenueXof": null,
  "topServices": null,
} satisfies ProAnalytics

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProAnalytics
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



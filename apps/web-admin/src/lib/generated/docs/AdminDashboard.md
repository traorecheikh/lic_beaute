
# AdminDashboard


## Properties

Name | Type
------------ | -------------
`kpis` | [Array&lt;AdminDashboardKpisInner&gt;](AdminDashboardKpisInner.md)
`topGrowthSalons` | [Array&lt;AdminDashboardTopGrowthSalonsInner&gt;](AdminDashboardTopGrowthSalonsInner.md)
`inactivityAlerts` | [Array&lt;AdminDashboardInactivityAlertsInner&gt;](AdminDashboardInactivityAlertsInner.md)
`quickLinks` | [AdminDashboardQuickLinks](AdminDashboardQuickLinks.md)

## Example

```typescript
import type { AdminDashboard } from ''

// TODO: Update the object below with actual values
const example = {
  "kpis": null,
  "topGrowthSalons": null,
  "inactivityAlerts": null,
  "quickLinks": null,
} satisfies AdminDashboard

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as AdminDashboard
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



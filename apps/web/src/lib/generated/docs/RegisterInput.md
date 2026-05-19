
# RegisterInput


## Properties

Name | Type
------------ | -------------
`type` | string
`fullName` | string
`email` | string
`phone` | string
`password` | string
`subscriptionIntentTier` | string
`salon` | [RegisterInputAnyOf1Salon](RegisterInputAnyOf1Salon.md)
`services` | [Array&lt;RegisterInputAnyOf1ServicesInner&gt;](RegisterInputAnyOf1ServicesInner.md)
`hours` | [Array&lt;RegisterInputAnyOf1HoursInner&gt;](RegisterInputAnyOf1HoursInner.md)
`documents` | [Array&lt;RegisterInputAnyOf1DocumentsInner&gt;](RegisterInputAnyOf1DocumentsInner.md)

## Example

```typescript
import type { RegisterInput } from ''

// TODO: Update the object below with actual values
const example = {
  "type": null,
  "fullName": null,
  "email": null,
  "phone": null,
  "password": null,
  "subscriptionIntentTier": null,
  "salon": null,
  "services": null,
  "hours": null,
  "documents": null,
} satisfies RegisterInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as RegisterInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



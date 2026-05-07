
# ProfileOptions


## Properties

Name | Type
------------ | -------------
`cities` | Array&lt;string&gt;
`languages` | Array&lt;string&gt;
`contactChannels` | Array&lt;string&gt;
`paymentProviders` | Array&lt;string&gt;

## Example

```typescript
import type { ProfileOptions } from ''

// TODO: Update the object below with actual values
const example = {
  "cities": null,
  "languages": null,
  "contactChannels": null,
  "paymentProviders": null,
} satisfies ProfileOptions

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProfileOptions
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



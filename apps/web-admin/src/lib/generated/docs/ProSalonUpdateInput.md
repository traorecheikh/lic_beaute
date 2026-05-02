
# ProSalonUpdateInput


## Properties

Name | Type
------------ | -------------
`category` | string
`logoUrl` | string
`description` | string
`city` | string
`address` | string
`neighborhood` | string
`latitude` | number
`longitude` | number
`teamDisplay` | [ProSalonUpdateInputTeamDisplay](ProSalonUpdateInputTeamDisplay.md)
`phone` | string
`instagram` | string
`gallery` | Array&lt;string&gt;

## Example

```typescript
import type { ProSalonUpdateInput } from ''

// TODO: Update the object below with actual values
const example = {
  "category": null,
  "logoUrl": null,
  "description": null,
  "city": null,
  "address": null,
  "neighborhood": null,
  "latitude": null,
  "longitude": null,
  "teamDisplay": null,
  "phone": null,
  "instagram": null,
  "gallery": null,
} satisfies ProSalonUpdateInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProSalonUpdateInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



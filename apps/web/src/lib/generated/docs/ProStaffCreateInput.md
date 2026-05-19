
# ProStaffCreateInput


## Properties

Name | Type
------------ | -------------
`phone` | string
`email` | string
`password` | string
`fullName` | string
`role` | string
`avatarUrl` | string
`description` | string
`serviceIds` | Array&lt;string&gt;

## Example

```typescript
import type { ProStaffCreateInput } from ''

// TODO: Update the object below with actual values
const example = {
  "phone": null,
  "email": null,
  "password": null,
  "fullName": null,
  "role": null,
  "avatarUrl": null,
  "description": null,
  "serviceIds": null,
} satisfies ProStaffCreateInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProStaffCreateInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



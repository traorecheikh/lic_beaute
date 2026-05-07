
# ProStaffUpdateInput


## Properties

Name | Type
------------ | -------------
`displayName` | string
`avatarUrl` | string
`description` | string
`isActive` | boolean
`schedulingEnabled` | boolean
`serviceIds` | Array&lt;string&gt;

## Example

```typescript
import type { ProStaffUpdateInput } from ''

// TODO: Update the object below with actual values
const example = {
  "displayName": null,
  "avatarUrl": null,
  "description": null,
  "isActive": null,
  "schedulingEnabled": null,
  "serviceIds": null,
} satisfies ProStaffUpdateInput

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ProStaffUpdateInput
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



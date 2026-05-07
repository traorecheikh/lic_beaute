
# MediaAsset


## Properties

Name | Type
------------ | -------------
`id` | string
`publicUrl` | string
`filename` | string
`mimeType` | string
`sizeBytes` | number
`createdAt` | Date
`ownerType` | string
`ownerId` | string
`deletedAt` | Date

## Example

```typescript
import type { MediaAsset } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "publicUrl": null,
  "filename": null,
  "mimeType": null,
  "sizeBytes": null,
  "createdAt": null,
  "ownerType": null,
  "ownerId": null,
  "deletedAt": null,
} satisfies MediaAsset

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as MediaAsset
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



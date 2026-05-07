
# MediaUploadResponse


## Properties

Name | Type
------------ | -------------
`id` | string
`publicUrl` | string
`filename` | string
`mimeType` | string
`sizeBytes` | number
`createdAt` | Date

## Example

```typescript
import type { MediaUploadResponse } from ''

// TODO: Update the object below with actual values
const example = {
  "id": null,
  "publicUrl": null,
  "filename": null,
  "mimeType": null,
  "sizeBytes": null,
  "createdAt": null,
} satisfies MediaUploadResponse

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as MediaUploadResponse
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



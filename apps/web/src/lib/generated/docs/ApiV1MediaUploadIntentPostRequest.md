
# ApiV1MediaUploadIntentPostRequest


## Properties

Name | Type
------------ | -------------
`salonId` | string
`purpose` | string
`mimeType` | string
`originalFilename` | string
`sizeBytes` | number

## Example

```typescript
import type { ApiV1MediaUploadIntentPostRequest } from ''

// TODO: Update the object below with actual values
const example = {
  "salonId": null,
  "purpose": null,
  "mimeType": null,
  "originalFilename": null,
  "sizeBytes": null,
} satisfies ApiV1MediaUploadIntentPostRequest

console.log(example)

// Convert the instance to a JSON string
const exampleJSON: string = JSON.stringify(example)
console.log(exampleJSON)

// Parse the JSON string back to an object
const exampleParsed = JSON.parse(exampleJSON) as ApiV1MediaUploadIntentPostRequest
console.log(exampleParsed)
```

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)



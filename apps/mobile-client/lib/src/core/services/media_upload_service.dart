import 'dart:io';

import 'package:beauteavenue_api/beauteavenue_api.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class MediaUploadService {
  final Dio _dio;
  final MediaApi _api;

  MediaUploadService(Dio dio)
    : _dio = dio,
      _api = MediaApi(dio, standardSerializers);

  /// Upload a file to R2 via presigned PUT and return the assetId.
  ///
  /// The three-step flow:
  ///   1. POST /api/v1/media/upload-intent → get presigned PUT URL + assetId
  ///   2. PUT directly to R2 (no Authorization header)
  ///   3. POST /api/v1/media/{assetId}/complete → triggers admin review
  Future<String> uploadSalonImage({
    required String salonId,
    required XFile file,
    required String purpose,
  }) async {
    final fileBytes = await file.readAsBytes();
    final mimeType = _mimeTypeFromExtension(file.name);
    final sizeBytes = fileBytes.length;

    // Step 1: request presigned upload intent
    final requestBuilder = ApiV1MediaUploadIntentPostRequestBuilder()
      ..purpose = _purposeEnum(purpose)
      ..mimeType = mimeType
      ..originalFilename = file.name
      ..sizeBytes = sizeBytes;
    if (salonId.isNotEmpty) requestBuilder.salonId = salonId;

    final intentResp = await _api.apiV1MediaUploadIntentPost(
      apiV1MediaUploadIntentPostRequest: requestBuilder.build(),
    );

    final intent = intentResp.data;
    if (intent == null) throw StateError('Upload intent response was null');
    final assetId = intent.assetId;
    final uploadUrl = intent.uploadUrl;

    // Step 2: PUT directly to R2 — separate Dio instance, no auth header
    final r2Dio = Dio();
    await r2Dio.put<void>(
      uploadUrl,
      data: Stream.fromIterable([fileBytes]),
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: mimeType,
          HttpHeaders.contentLengthHeader: sizeBytes,
        },
        sendTimeout: const Duration(seconds: 120),
      ),
    );

    // Step 3: confirm upload complete
    await _dio.post<void>(
      '/api/v1/media/$assetId/complete',
      data: const <String, dynamic>{},
    );

    return assetId;
  }

  static ApiV1MediaUploadIntentPostRequestPurposeEnum _purposeEnum(
    String purpose,
  ) {
    return switch (purpose) {
      'salon_cover' => ApiV1MediaUploadIntentPostRequestPurposeEnum.salonCover,
      'salon_logo' => ApiV1MediaUploadIntentPostRequestPurposeEnum.salonLogo,
      'salon_gallery' =>
        ApiV1MediaUploadIntentPostRequestPurposeEnum.salonGallery,
      'kyc_document' =>
        ApiV1MediaUploadIntentPostRequestPurposeEnum.kycDocument,
      _ => ApiV1MediaUploadIntentPostRequestPurposeEnum.avatar,
    };
  }

  static String _mimeTypeFromExtension(String filename) {
    final ext = filename.toLowerCase().split('.').last;
    return switch (ext) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      'heic' => 'image/heic',
      _ => 'image/jpeg',
    };
  }
}

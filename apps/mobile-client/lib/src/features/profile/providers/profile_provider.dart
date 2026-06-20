import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/media_upload_service.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/network/connectivity_provider.dart';
import '../../../core/session/session_store.dart';
import '../../../core/storage/app_model_cache.dart';
import '../../../core/sync/app_outbox.dart';
import '../models/account_models.dart';

class ProfileNotifier extends AsyncNotifier<ClientAccountProfile?> {
  @override
  Future<ClientAccountProfile?> build() async {
    final session = ref.watch(sessionProvider);
    if (!session.isAuthenticated) return null;
    final cached = AppModelCache.getMap(
      StorageKeys.profileBox,
      StorageKeys.currentUser,
    );
    final pendingSync = ref
        .watch(outboxProvider)
        .any(
          (entry) =>
              entry.type == 'profile_patch' ||
              entry.type == 'profile_avatar_upload',
        );
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get<Map<String, dynamic>>('/api/v1/me');
      final data = response.data;
      if (data == null) {
        return cached == null
            ? null
            : ClientAccountProfile.fromJson(cached, pendingSync: pendingSync);
      }
      await AppModelCache.putMap(
        StorageKeys.profileBox,
        StorageKeys.currentUser,
        data,
      );
      return ClientAccountProfile.fromJson(data, pendingSync: pendingSync);
    } catch (_) {
      if (cached == null) return null;
      return ClientAccountProfile.fromJson(cached, pendingSync: pendingSync);
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? city,
    String? preferredContactChannel,
    bool? pushOptIn,
    bool? marketingOptIn,
    String? preferredLanguage,
    bool syncPhone = false,
  }) async {
    final previous = state.asData?.value;
    final payload = <String, dynamic>{
      ...?(fullName != null ? {'fullName': fullName} : null),
      if (syncPhone || phone != null) 'phone': phone,
      ...?(city != null ? {'city': city} : null),
      ...?(preferredContactChannel != null
          ? {'preferredContactChannel': preferredContactChannel}
          : null),
      ...?(pushOptIn != null ? {'pushOptIn': pushOptIn} : null),
      ...?(marketingOptIn != null ? {'marketingOptIn': marketingOptIn} : null),
      ...?(preferredLanguage != null
          ? {'preferredLanguage': preferredLanguage}
          : null),
    };
    if (previous != null) {
      final next = previous.copyWith(
        fullName: fullName,
        phone: syncPhone ? phone : previous.phone,
        city: city,
        preferredContactChannel: preferredContactChannel,
        pushOptIn: pushOptIn,
        marketingOptIn: marketingOptIn,
        preferredLanguage: preferredLanguage,
        pendingSync: true,
      );
      await AppModelCache.putMap(
        StorageKeys.profileBox,
        StorageKeys.currentUser,
        next.toJson(),
      );
      state = AsyncData(next);
    }
    await _updateAndSync(payload, rollbackState: previous);
  }

  Future<void> _updateAndSync(
    Map<String, dynamic> payload, {
    ClientAccountProfile? rollbackState,
  }) async {
    final previous = rollbackState ?? state.asData?.value;
    final isOnline = ref.read(isOnlineProvider);
    if (!isOnline) {
      await ref.read(outboxProvider.notifier).clearByTypePrefix('profile_');
      await ref
          .read(outboxProvider.notifier)
          .enqueue(type: 'profile_patch', payload: payload);
      return;
    }

    try {
      final dio = ref.read(dioProvider);
      final response = await dio.patch<Map<String, dynamic>>(
        '/api/v1/me',
        data: payload,
      );
      final data = response.data;
      if (data != null) {
        await AppModelCache.putMap(
          StorageKeys.profileBox,
          StorageKeys.currentUser,
          data,
        );
        state = AsyncData(
          ClientAccountProfile.fromJson(data, pendingSync: false),
        );
      }
    } on DioException catch (error) {
      // Only fall back to pending sync for transient network errors.
      // Server errors (4xx) should surface immediately — retrying won't help.
      final isTransient = switch (error.type) {
        DioExceptionType.connectionError ||
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout => true,
        DioExceptionType.badResponse => false,
        DioExceptionType.cancel ||
        DioExceptionType.badCertificate ||
        DioExceptionType.unknown => false,
      };
      if (isTransient) {
        await ref
            .read(outboxProvider.notifier)
            .enqueue(type: 'profile_patch', payload: payload);
        if (previous != null) {
          state = AsyncData(previous.copyWith(pendingSync: true));
        }
        return;
      }
      if (previous != null) {
        await AppModelCache.putMap(
          StorageKeys.profileBox,
          StorageKeys.currentUser,
          previous.toJson(),
        );
        state = AsyncData(previous);
      }
      rethrow;
    }
  }

  Future<void> uploadAvatar(File file) async {
    final previous = state.asData?.value;
    if (previous != null) {
      state = AsyncData(previous.copyWith(pendingSync: true));
    }
    final isOnline = ref.read(isOnlineProvider);
    if (!isOnline) {
      await _enqueueAvatarUpload(file.path);
      return;
    }

    final dio = ref.read(dioProvider);
    try {
      final xFile = XFile(file.path);
      final mediaId = await MediaUploadService(dio).uploadAvatar(file: xFile);
      await _updateAndSync({'avatarMediaId': mediaId});
      await refresh();
    } on DioException catch (error) {
      final isRecoverable =
          error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout;
      if (!isRecoverable) rethrow;
      await _enqueueAvatarUpload(file.path);
    }
  }

  Future<void> _enqueueAvatarUpload(String filePath) async {
    await ref
        .read(outboxProvider.notifier)
        .clearByTypePrefix('profile_avatar_');
    await ref
        .read(outboxProvider.notifier)
        .enqueue(
          type: 'profile_avatar_upload',
          payload: const {},
          localFilePath: filePath,
        );
  }
}

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, ClientAccountProfile?>(
      ProfileNotifier.new,
    );

final profileOptionsProvider = FutureProvider<ProfileOptions>((ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    '/api/v1/metadata/profile-options',
  );
  return ProfileOptions.fromJson(response.data ?? const {});
});

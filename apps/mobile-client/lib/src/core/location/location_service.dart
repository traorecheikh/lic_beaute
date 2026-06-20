import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_ce/hive_ce.dart';

import '../constants/storage_keys.dart';

enum LocationStatus { granted, denied, deniedForever, serviceDisabled }

LocationStatus _mapPermission(LocationPermission perm) => switch (perm) {
  LocationPermission.always => LocationStatus.granted,
  LocationPermission.whileInUse => LocationStatus.granted,
  LocationPermission.deniedForever => LocationStatus.deniedForever,
  _ => LocationStatus.denied,
};

final locationStatusProvider = FutureProvider.autoDispose<LocationStatus>((ref) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  debugPrint('[Location] service enabled: $serviceEnabled');
  if (!serviceEnabled) {
    debugPrint('[Location] → serviceDisabled');
    return LocationStatus.serviceDisabled;
  }

  final perm = await Geolocator.checkPermission();
  debugPrint('[Location] permission: $perm');
  final status = _mapPermission(perm);
  debugPrint('[Location] → status: $status');
  return status;
});

final locationProvider = FutureProvider.autoDispose<Position?>((ref) async {
  final status = await ref.watch(locationStatusProvider.future);
  debugPrint('[Location] locationProvider: status=$status');
  if (status != LocationStatus.granted) {
    debugPrint('[Location] → returning null (not granted)');
    return null;
  }

  debugPrint('[Location] calling getCurrentPosition…');
  try {
    // On Android use LocationManager directly so `adb emu geo fix` works.
    // Fused Location Provider ignores emulator GPS injection.
    final settings = Platform.isAndroid
        ? AndroidSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: const Duration(seconds: 8),
            forceLocationManager: true,
          )
        : LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: const Duration(seconds: 8),
          );
    final pos = await Geolocator.getCurrentPosition(locationSettings: settings);
    debugPrint('[Location] → got position: lat=${pos.latitude}, lng=${pos.longitude}');
    return pos;
  } catch (e) {
    debugPrint('[Location] → getCurrentPosition failed: $e');
    return null;
  }
});

/// Reverse-geocodes the current GPS position to a location label
/// including quartier/sub-locality when available (e.g. "Médina, Dakar").
/// Returns null if location permission is not granted or geocoding fails.
final cityFromLocationProvider = FutureProvider.autoDispose<String?>((ref) async {
  final position = await ref.watch(locationProvider.future);
  if (position == null) return null;
  try {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (placemarks.isEmpty) return null;
    final p = placemarks.first;
    final subLocality = p.subLocality?.trim();
    final locality =
        p.locality?.trim() ??
        p.subAdministrativeArea?.trim() ??
        p.administrativeArea?.trim();
    if (subLocality != null && subLocality.isNotEmpty &&
        locality != null && locality.isNotEmpty &&
        subLocality != locality) {
      return '$subLocality, $locality';
    }
    return locality ?? subLocality;
  } catch (e) {
    debugPrint('[Location] → reverse-geocode failed: $e');
    return null;
  }
});

// Session-level: whether banner has been dismissed this session
class LocationBannerDismissedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void dismiss() => state = true;
}

final locationBannerDismissedProvider =
    NotifierProvider<LocationBannerDismissedNotifier, bool>(
      LocationBannerDismissedNotifier.new,
    );

Future<LocationStatus> requestLocationPermission() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return LocationStatus.serviceDisabled;

  final perm = await Geolocator.requestPermission();
  return _mapPermission(perm);
}

Future<void> openLocationSettings() => Geolocator.openLocationSettings();
Future<void> openAppSettings() => Geolocator.openAppSettings();

class LocationPromptManager {
  static const String _keyCount = 'location_prompt_count';
  static const String _keyLastTime = 'location_prompt_last_time';
  static const String _keyJustRegistered = 'location_just_registered';

  static Future<bool> shouldShowPrompt() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.always || status == LocationPermission.whileInUse) {
      return false;
    }

    final box = Hive.box<dynamic>(StorageKeys.settingsBox);
    
    // Override if user just completed registration/inscription
    final justRegistered = box.get(_keyJustRegistered, defaultValue: false) as bool;
    if (justRegistered) {
      return true;
    }

    final count = box.get(_keyCount, defaultValue: 0) as int;
    if (count >= 5) {
      return false;
    }

    final lastTimeStr = box.get(_keyLastTime) as String?;
    if (lastTimeStr == null) {
      return true;
    }

    final lastTime = DateTime.tryParse(lastTimeStr);
    if (lastTime == null) return true;

    final now = DateTime.now();
    final diff = now.difference(lastTime);
    final Duration delay;
    switch (count) {
      case 1:
        delay = const Duration(days: 1);
        break;
      case 2:
        delay = const Duration(days: 3);
        break;
      case 3:
        delay = const Duration(days: 7);
        break;
      case 4:
        delay = const Duration(days: 15);
        break;
      default:
        delay = const Duration(days: 0);
    }
    return diff >= delay;
  }

  static Future<void> recordPromptShown() async {
    final box = Hive.box<dynamic>(StorageKeys.settingsBox);
    final count = box.get(_keyCount, defaultValue: 0) as int;
    await box.put(_keyCount, count + 1);
    await box.put(_keyLastTime, DateTime.now().toIso8601String());
    await box.put(_keyJustRegistered, false); // Clear the override flag
  }

  static Future<void> markJustRegistered() async {
    final box = Hive.box<dynamic>(StorageKeys.settingsBox);
    await box.put(_keyJustRegistered, true);
  }
}

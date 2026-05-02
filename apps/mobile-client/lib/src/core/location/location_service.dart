import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

enum LocationStatus { granted, denied, deniedForever, serviceDisabled }

final locationStatusProvider = FutureProvider.autoDispose<LocationStatus>((ref) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  debugPrint('[Location] service enabled: $serviceEnabled');
  if (!serviceEnabled) {
    debugPrint('[Location] → serviceDisabled');
    return LocationStatus.serviceDisabled;
  }

  final perm = await Geolocator.checkPermission();
  debugPrint('[Location] permission: $perm');
  final status = switch (perm) {
    LocationPermission.always => LocationStatus.granted,
    LocationPermission.whileInUse => LocationStatus.granted,
    LocationPermission.deniedForever => LocationStatus.deniedForever,
    _ => LocationStatus.denied,
  };
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
        : const LocationSettings(
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

// Session-level: whether banner has been dismissed this session
final locationBannerDismissedProvider = StateProvider<bool>((ref) => false);

Future<LocationStatus> requestLocationPermission() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return LocationStatus.serviceDisabled;

  final perm = await Geolocator.requestPermission();
  return switch (perm) {
    LocationPermission.always => LocationStatus.granted,
    LocationPermission.whileInUse => LocationStatus.granted,
    LocationPermission.deniedForever => LocationStatus.deniedForever,
    _ => LocationStatus.denied,
  };
}

Future<void> openLocationSettings() => Geolocator.openLocationSettings();
Future<void> openAppSettings() => Geolocator.openAppSettings();

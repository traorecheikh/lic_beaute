import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../utils/app_haptics.dart';
import 'app_icon.dart';

class SalonMapCard extends StatelessWidget {
  const SalonMapCard({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.salonName,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String salonName;
  final String address;

  Future<void> _openMaps(BuildContext context) async {
    AppHaptics.light();

    final String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final String appleUrl = 'https://maps.apple.com/?q=$latitude,$longitude';

    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(appleUrl))) {
        await launchUrl(Uri.parse(appleUrl), mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.externalApplication);
      }
    } else {
      // Android: use geo: intent to allow picker
      final Uri geoUri = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude($salonName)');
      if (await canLaunchUrl(geoUri)) {
        await launchUrl(geoUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final point = LatLng(latitude, longitude);

    return GestureDetector(
      onTap: () => _openMaps(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            SizedBox(
              height: 180.h,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: point,
                  initialZoom: 15.5,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'sn.beauteavenue.mobile',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: point,
                        width: 40.r,
                        height: 40.r,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(100),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const AppIcon('store', size: 18, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bottom overlay with address + "Open in Maps" hint
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.black.withAlpha(180), AppColors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    const AppIcon('map', size: 14, color: AppColors.white70),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        address,
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.white,
                          fontSize: 11.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Ouvrir →',
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.white70,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

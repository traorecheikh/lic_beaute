import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_haptics.dart';
import '../widgets/app_snackbar.dart';

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
    // Universal deep-link: opens Google Maps on Android, Apple Maps on iOS
    final uri = Uri.parse(
      'https://maps.google.com/?q=${Uri.encodeComponent(salonName)}'
      '@$latitude,$longitude',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        AppSnackbar.error(context, "Impossible d'ouvrir l'application Maps.");
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
                            border: Border.all(color: Colors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(100),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.storefront_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
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
                    colors: [Colors.black.withAlpha(180), Colors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.map_rounded,
                      size: 14,
                      color: Colors.white70,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        address,
                        style: AppTextStyles.bodySm.copyWith(
                          color: Colors.white,
                          fontSize: 11.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'Ouvrir →',
                      style: AppTextStyles.labelSm.copyWith(
                        color: Colors.white70,
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

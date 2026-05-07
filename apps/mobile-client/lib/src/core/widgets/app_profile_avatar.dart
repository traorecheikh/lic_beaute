import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppProfileAvatar extends StatelessWidget {
  final String? url;
  final double radius;
  final double iconSize;

  const AppProfileAvatar({
    this.url,
    required this.radius,
    required this.iconSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hasUrl = url != null && url!.isNotEmpty;
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryLight,
      backgroundImage: hasUrl ? CachedNetworkImageProvider(url!) : null,
      child: !hasUrl
          ? Icon(Icons.person_outline, size: iconSize, color: AppColors.primary)
          : null,
    );
  }
}

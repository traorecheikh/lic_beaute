import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryLight,
      backgroundImage: url != null ? NetworkImage(url!) : null,
      child: url == null
          ? Icon(
              Icons.person_outline,
              size: iconSize,
              color: AppColors.primary,
            )
          : null,
    );
  }
}

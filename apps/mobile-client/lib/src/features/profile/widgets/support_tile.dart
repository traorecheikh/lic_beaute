import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_tile.dart';
import 'profile_card_shell.dart';

class SupportTile extends StatelessWidget {
  const SupportTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ProfileCardShell(
      padding: EdgeInsets.zero,
      child: AppTile(
        title: title,
        subtitle: subtitle,
        icon: icon,
        onTap: onTap,
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14.r,
          color: AppColors.outline,
        ),
      ),
    );
  }
}

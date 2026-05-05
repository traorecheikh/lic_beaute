import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

/// Section header text, consistently styled across all features.
///
/// Replaces the private _SectionLabel in salon_detail_page and the inline
/// Text(style: AppTextStyles.headlineSm) pattern in support_page, profile_page.
class AppSectionLabel extends StatelessWidget {
  const AppSectionLabel(this.text, {this.style, super.key});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style ?? AppTextStyles.headlineSm);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_top_bar.dart';

/// Shared scaffold for auth pages: neutral background, transparent AppBar with
/// a back button, scrollable body with the standard header block
/// (title + subtitle) followed by [body].
///
/// The [leading] parameter allows overriding the default [AppBackButton] — e.g.
/// when the back button needs custom [onPressed] logic.
class AuthPageScaffold extends StatelessWidget {
  const AuthPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    this.leading,
  });

  final String title;
  final String subtitle;
  final Widget body;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppTopBar(
        backgroundColor: AppColors.transparent,
        showBackButton: false,
        leading: leading ?? const AppBackButton(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(28.w, 0, 28.w, 48.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20.h, bottom: 40.h),
                child: Image.asset(
                  'assets/logo.png',
                  height: 120.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(title, style: AppTextStyles.displayMd),
            gapH8,
            Text(
              subtitle,
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 48.h),
            body,
          ],
        ),
      ),
    );
  }
}

/// Rounded filled text field with editorial label and proper border states
/// (enabled → focused → error → focused+error). Uses OutlineInputBorder so
/// the entire border updates on focus — no partial-highlight animation.
class EditorialField extends StatefulWidget {
  const EditorialField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixText,
    this.textAlign = TextAlign.start,
    this.style,
    this.suffixBuilder,
    this.errorText,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? prefixText;
  final TextAlign textAlign;
  final TextStyle? style;
  final Widget Function(bool focused)? suffixBuilder;
  final String? errorText;

  @override
  State<EditorialField> createState() => _EditorialFieldState();
}

class _EditorialFieldState extends State<EditorialField> {
  final _focus = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.labelSm.copyWith(
            color: hasError
                ? AppColors.error
                : _focused
                ? AppColors.primary
                : AppColors.onSurfaceVariant,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                focusNode: _focus,
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                obscureText: widget.obscureText,
                textAlign: widget.textAlign,
                style:
                    widget.style ??
                    AppTextStyles.bodyLg.copyWith(color: AppColors.onSurface),
                decoration: InputDecoration(
                  isDense: true,
                  prefixText: widget.prefixText,
                  prefixStyle: AppTextStyles.bodyLg.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(
                      color: AppColors.outline.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 1.2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 1.8,
                    ),
                  ),
                  // Pass errorText to TextField so border states trigger automatically
                  errorText: hasError ? widget.errorText : null,
                  errorStyle: AppTextStyles.bodySm.copyWith(
                    color: AppColors.error,
                    height: 1.4,
                  ),
                  hintStyle: AppTextStyles.bodyLg.copyWith(
                    color: AppColors.outline,
                  ),
                ),
              ),
            ),
            if (widget.suffixBuilder != null) ...[
              gapW8,
              widget.suffixBuilder!(_focused),
            ],
          ],
        ),
      ],
    );
  }
}

/// Primary action button for auth flows — pill shape + warm shadow,
/// with loading spinner that maintains button size.
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onTap,
  });

  final String label;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: loading ? null : onTap,
      enabled: !loading,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: loading ? AppColors.outline : AppColors.primary,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: loading
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.30),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Center(
          child: loading
              ? SizedBox(
                  width: 22.r,
                  height: 22.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                )
              : Text(
                  label,
                  style: AppTextStyles.labelLg.copyWith(
                    color: AppColors.white,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}

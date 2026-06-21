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
    final heroHeight = MediaQuery.sizeOf(context).height * 0.38;
    return AppScaffold(
      appBar: AppTopBar(
        backgroundColor: AppColors.transparent,
        showBackButton: false,
        leading: leading ?? const AppBackButton(),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBrandBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero zone: branding on the circles background
              SizedBox(
                height: heroHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 100.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        title,
                        style: AppTextStyles.displayMd,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              // Form card: floats up from the bottom
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppRadius.xl.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 40,
                        offset: const Offset(0, -12),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      24.w,
                      32.h,
                      24.w,
                      MediaQuery.viewInsetsOf(context).bottom + 32.h,
                    ),
                    child: body,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shared brand circle background used across all auth and onboarding screens.
class AuthBrandBackground extends StatelessWidget {
  const AuthBrandBackground({super.key, this.intensity = 1.0});

  final double intensity;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.sizeOf(context),
      painter: _BrandCirclesPainter(intensity: intensity),
    );
  }
}

class _BrandCirclesPainter extends CustomPainter {
  const _BrandCirclesPainter({this.intensity = 1.0});

  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    void circle(double cx, double cy, double r, Color color) =>
        canvas.drawCircle(Offset(cx, cy), r, Paint()..color = color.withValues(alpha: color.a * intensity));

    circle(size.width * 0.88, size.height * -0.04, size.width * 0.72, AppColors.primary.withValues(alpha: 0.13));
    circle(size.width * -0.10, size.height * 0.12, size.width * 0.45, AppColors.secondary.withValues(alpha: 0.14));
    circle(size.width * 1.05, size.height * 0.38, size.width * 0.28, AppColors.primaryMid.withValues(alpha: 0.09));
    circle(size.width * 0.75, size.height * 0.28, size.width * 0.06, AppColors.secondary.withValues(alpha: 0.15));
    circle(size.width * 0.15, size.height * 0.88, size.width * 0.40, AppColors.primary.withValues(alpha: 0.06));
  }

  @override
  bool shouldRepaint(covariant _BrandCirclesPainter old) => old.intensity != intensity;
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
    this.enabled = true,
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
  final bool enabled;

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
    final labelColor = !widget.enabled
        ? AppColors.onSurfaceVariant.withValues(alpha: 0.5)
        : hasError
            ? AppColors.error
            : _focused
                ? AppColors.primary
                : AppColors.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.labelSm.copyWith(
            color: labelColor,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                enabled: widget.enabled,
                focusNode: widget.enabled ? _focus : null,
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
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: BorderSide(
                      color: AppColors.outline.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 1.2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md.r),
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
///
/// When [expand] is `true` (default) the button fills the available width.
/// Set [expand] to `false` for a compact button sized to its label.
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onTap,
    this.expand = true,
  });

  final String label;
  final bool loading;
  final VoidCallback onTap;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: loading ? null : onTap,
      enabled: !loading,
      child: expand ? _expandedBody(context) : _compactBody(),
    );
  }

  Widget _expandedBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // maxWidth is ALWAYS finite when the parent provides finite constraints
        // (e.g. inside a Row, Column with CrossAxisAlignment.stretch, Expanded, etc.).
        // Fallback: screen width (always finite) prevents the crash when constraints
        // are unconstrained.
        final w = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        return _shell(width: w);
      },
    );
  }

  Widget _compactBody() => _shell(width: null);

  Widget _shell({double? width}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: width,
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: loading ? AppColors.outline : AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.full.r),
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
                child: const CircularProgressIndicator.adaptive(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.white),
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
    );
  }
}

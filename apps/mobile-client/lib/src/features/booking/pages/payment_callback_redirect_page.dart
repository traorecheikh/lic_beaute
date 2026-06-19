import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/session/session_store.dart';
import '../../../router/app_router.dart';

class PaymentCallbackRedirectPage extends ConsumerStatefulWidget {
  const PaymentCallbackRedirectPage({
    this.bookingId,
    this.paymentId,
    this.token,
    super.key,
  });

  final String? bookingId;
  final String? paymentId;
  final String? token;

  @override
  ConsumerState<PaymentCallbackRedirectPage> createState() =>
      _PaymentCallbackRedirectPageState();
}

class _PaymentCallbackRedirectPageState
    extends ConsumerState<PaymentCallbackRedirectPage> {
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_handled) return;
      _handled = true;
      _resumeInAppFlow();
    });
  }

  Future<void> _resumeInAppFlow() async {
    final bookingId = widget.bookingId?.trim();
    final paymentId = widget.paymentId?.trim();
    if (!mounted) return;

    if (bookingId == null || bookingId.isEmpty) {
      context.go(AppRoutes.home);
      return;
    }

    var session = ref.read(sessionProvider);
    if (!session.isAuthenticated) {
      await ref.read(sessionProvider.notifier).restore();
      if (!mounted) return;
      session = ref.read(sessionProvider);
    }

    final target = Uri(
      path: AppRoutes.paymentHandoff(bookingId),
      queryParameters: <String, String>{
        if (paymentId != null && paymentId.isNotEmpty) 'paymentId': paymentId,
        'fromCallback': '1',
        if ((widget.token?.trim().isNotEmpty ?? false))
          'token': widget.token!.trim(),
      },
    ).toString();

    if (!session.isAuthenticated) {
      context.go('${AppRoutes.auth}?redirectTo=${Uri.encodeComponent(target)}');
      return;
    }

    context.go(target);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const AppTopBar(showBackButton: false),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48.r,
                height: 48.r,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Reprise du paiement…',
                textAlign: TextAlign.center,
                style: AppTextStyles.labelLg,
              ),
              SizedBox(height: 8.h),
              Text(
                'Nous vous ramenons dans le parcours de verification de votre acompte.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 16.h),
              const AppIcon('sparkle', size: 18, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/constants/app_contacts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_divider.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../router/app_router.dart';
import '../widgets/auth_form_widgets.dart';

class AuthChoicePage extends StatelessWidget {
  const AuthChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final redirectTo = GoRouterState.of(context).uri.queryParameters['redirectTo'];
    final query = redirectTo != null ? '?redirectTo=${Uri.encodeComponent(redirectTo)}' : '';

    return AppScaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBrandBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Large logo
                  Image.asset(
                    'assets/logo.png',
                    height: 160.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 20.h),

                  // Brand name
                  Text(
                    AppStrings.appTitle,
                    style: AppTextStyles.displaySm.copyWith(letterSpacing: 0.5),
                  ),
                  SizedBox(height: 10.h),

                  // Tagline
                  Text(
                    AppStrings.authTagline,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.55,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 3),

                  // PRIMARY ACTION: S'inscrire (Merged Entry)
                  AppButton.primary(
                    label: AppStrings.signUpCta,
                    onPressed: () => _showSignUpOptions(context, query),
                  ),

                  SizedBox(height: 32.h),

                  // SECONDARY ACTION: Connexion (Existing Users)
                  Row(
                    children: [
                      const Expanded(child: AppDivider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          AppStrings.alreadyHaveAccount,
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const Expanded(child: AppDivider()),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  AppButton.outline(
                    label: AppStrings.loginCta,
                    onPressed: () => context.push('${AppRoutes.emailLogin}$query'),
                  ),

                  SizedBox(height: 20.h),

                  AppPressable(
                    onTap: () => context.go(AppRoutes.home),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                      child: Text(
                        AppStrings.continueWithoutAccount,
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  gapH24,
                  // Legal acceptance text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyles.bodyXs.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        children: [
                          TextSpan(text: '${AppStrings.legalAcceptance} '),
                          TextSpan(
                            text: AppStrings.termsLabel,
                            style: AppTextStyles.bodyXs.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => launchUrl(
                                    Uri.parse(AppContacts.termsUrl),
                                    mode: LaunchMode.externalApplication,
                                  ),
                          ),
                          TextSpan(text: ' ${AppStrings.legalAcceptanceAnd} '),
                          TextSpan(
                            text: AppStrings.privacyLabel,
                            style: AppTextStyles.bodyXs.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => launchUrl(
                                    Uri.parse(AppContacts.privacyUrl),
                                    mode: LaunchMode.externalApplication,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  gapH16,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignUpOptions(BuildContext context, String query) {
    GoRouter.of(context).push('${AppRoutes.register}$query');
  }
}

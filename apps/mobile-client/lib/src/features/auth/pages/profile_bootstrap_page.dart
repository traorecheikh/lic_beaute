import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/location/location_service.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_resource_view.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../router/app_router.dart';
import '../../profile/providers/profile_provider.dart';

class ProfileBootstrapPage extends ConsumerStatefulWidget {
  const ProfileBootstrapPage({
    this.requiredSetup = false,
    this.nextRoute = AppRoutes.home,
    super.key,
  });

  final bool requiredSetup;
  final String nextRoute;

  @override
  ConsumerState<ProfileBootstrapPage> createState() => _ProfileBootstrapPageState();
}

class _ProfileBootstrapPageState extends ConsumerState<ProfileBootstrapPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();

  bool _saving = false;
  bool _uploadingAvatar = false;
  String? _localAvatarPath;

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 88,
    );
    if (image == null || !mounted) return;
    setState(() => _localAvatarPath = image.path);
    setState(() => _uploadingAvatar = true);
    try {
      await ref.read(profileProvider.notifier).uploadAvatar(File(image.path));
      if (!mounted) return;
      AppSnackbar.success(context, AppStrings.bootstrapAvatarUpdated);
    } catch (_) {
      AppSnackbar.error(context, AppStrings.bootstrapUploadFailed);
    } finally {
      if (mounted) {
        setState(() => _uploadingAvatar = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final optionsAsync = ref.watch(profileOptionsProvider);
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppTopBar(
        title: AppStrings.profileBootstrapTitle,
        showBackButton: !widget.requiredSetup,
      ),
      body: SafeArea(
        top: false,
        child: AppResourceView(
          value: optionsAsync,
          onRetry: () => ref.refresh(profileOptionsProvider.future),
          errorTitle: AppStrings.bootstrapFormError,
          builder: (options) {
            final profile = profileAsync.value;
            final avatarUrl = profile?.avatarUrl;
            final hasRemoteAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
            return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  Text(
                    AppStrings.bootstrapTitle,
                    style: AppTextStyles.displayMd,
                  ),
                  gapH12,
                  Text(
                    AppStrings.bootstrapSubtitle,
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundImage: _localAvatarPath != null
                              ? FileImage(File(_localAvatarPath!))
                              : (hasRemoteAvatar
                                    ? CachedNetworkImageProvider(avatarUrl)
                                    : null),
                          child:
                              (_localAvatarPath == null && !hasRemoteAvatar)
                              ? AppIcon(
                                  'user',
                                  size: 44,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: AppPressable(
                            onTap: _uploadingAvatar ? null : _pickAvatar,
                            child: Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: const BoxDecoration(
                                color: AppColors.black,
                                shape: BoxShape.circle,
                              ),
                              child: _uploadingAvatar
                                  ? SizedBox(
                                      width: 16.r,
                                      height: 16.r,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : AppIcon(
                                      'camera',
                                      size: 16,
                                      color: AppColors.white,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.fullNameLabel,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 2) {
                          return AppStrings.bootstrapNameRequired;
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 48.h),
                    AppButton.primary(
                      onPressed: _saving ? null : _submit,                    label: AppStrings.bootstrapSubmitCta,
                    isLoading: _saving,
                  ),
                    if (!widget.requiredSetup) ...[
                      gapH16,
                      Center(
                        child: TextButton(
                          onPressed: () => context.go(AppRoutes.home),
                          child: Text(
                            AppStrings.bootstrapSkip,
                            style: AppTextStyles.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showPaymentNudge() async {
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl.r)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24.w, 4.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppIcon('star', size: 26, color: AppColors.primary),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.bootstrapPaymentNudgeTitle,
              style: AppTextStyles.headlineMd,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              AppStrings.bootstrapPaymentNudgeBody,
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 28.h),
            AppButton.primary(
              label: AppStrings.bootstrapPaymentNudgeCta,
              onPressed: () {
                Navigator.of(ctx).pop();
                context.go(
                  AppRoutes.profilePaymentsSetup(next: widget.nextRoute),
                );
              },
            ),
            SizedBox(height: 12.h),
            AppButton.text(
              label: AppStrings.bootstrapLater,
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    AppHaptics.medium();
    setState(() => _saving = true);

    try {
      await ref.read(profileProvider.notifier).updateProfile(
            fullName: _fullNameController.text.trim(),
          );
      if (!mounted) return;
      await LocationPromptManager.markJustRegistered();
      if (!mounted) return;
      if (widget.requiredSetup) {
        context.go(AppRoutes.profilePaymentsSetup(next: widget.nextRoute));
        return;
      }
      await _showPaymentNudge();
      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.error(context, AppStrings.bootstrapSaveFailed);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

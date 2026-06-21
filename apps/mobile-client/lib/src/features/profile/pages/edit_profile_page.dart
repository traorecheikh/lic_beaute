import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_http_error_handler.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_phone_field.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/session/session_store.dart';
import '../providers/profile_provider.dart';
import '../utils/phone_utils.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _saving = false;
  bool _uploadingAvatar = false;
  String? _localAvatarPath;
  PhoneCountry _phoneCountry = kPhoneCountries.first;
  String _contactChannel = 'phone';
  String _language = 'fr';
  bool _pushOptIn = true;
  bool _marketingOptIn = false;
  bool _didSeedControllers = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final optionsAsync = ref.watch(profileOptionsProvider);

    return AppScaffold(
      appBar: AppTopBar(title: AppStrings.editProfileTitle),
      body: AppAsyncView(
        value: profileAsync,
        onRetry: () => ref.refresh(profileProvider.future),
        errorTitle: AppStrings.loadProfileError,
        builder: (profile) {
          if (profile == null) return const SizedBox.shrink();
          final avatarUrl = profile.avatarUrl;
          final hasRemoteAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
          if (!_didSeedControllers) {
            _didSeedControllers = true;
            _fullNameController.text = profile.fullName;
            _seedPhone(profile.phone);
            _contactChannel = profile.preferredContactChannel;
            _language = profile.preferredLanguage;
            _pushOptIn = profile.pushOptIn;
            _marketingOptIn = profile.marketingOptIn;
          }
          return optionsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator.adaptive()),
            error: (error, _) => AppErrorState(
              title: AppStrings.loadOptionsError,
              message: error.toString(),
              onRetry: () => ref.refresh(profileOptionsProvider.future),
            ),
            data: (options) => SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24.w,
                24.w,
                24.w,
                MediaQuery.of(context).padding.bottom + 120.h,
              ),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
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
                                        child: const CircularProgressIndicator.adaptive(
                                          strokeWidth: 2,
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
                    SizedBox(height: 28.h),
                    _buildTextField(
                      label: AppStrings.fullNameLabel,
                      controller: _fullNameController,
                      validator: (value) {
                        if (value == null || value.trim().length < 2) {
                          return AppStrings.fullNameRequired;
                        }
                        return null;
                      },
                    ),
                    gapH16,
                    AppPhoneField(
                      controller: _phoneController,
                      labelText: AppStrings.phoneLabel,
                      initialCountry: _phoneCountry,
                      onCountryChanged: (country) =>
                          setState(() => _phoneCountry = country),
                      validator: (value) {
                        final digits = (value ?? '').replaceAll(
                          RegExp(r'\D'),
                          '',
                        );
                        if (digits.isEmpty) return null;
                        if (digits.length != _phoneCountry.digits) {
                          return 'Numéro invalide (${_phoneCountry.digits} chiffres attendus)';
                        }
                        return null;
                      },
                    ),
                    gapH16,

                    SizedBox(height: 16.h),
                    DropdownButtonFormField<String>(
                      initialValue: _contactChannel,
                      decoration: const InputDecoration(
                        labelText: AppStrings.contactChannelLabel,
                      ),
                      items: options.contactChannels
                          .map(
                            (channel) => DropdownMenuItem(
                              value: channel,
                              child: Text(_channelLabel(channel)),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _contactChannel = value);
                        }
                      },
                    ),
                    SizedBox(height: 16.h),
                    DropdownButtonFormField<String>(
                      initialValue: _language,
                      decoration: InputDecoration(
                        labelText: AppStrings.languageLabel,
                      ),
                      items: options.languages
                          .map(
                            (language) => DropdownMenuItem(
                              value: language,
                              child: Text(
                                language == 'fr'
                                    ? AppStrings.french
                                    : AppStrings.english,
                              ),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _language = value);
                        }
                      },
                    ),
                    SizedBox(height: 24.h),
                    SwitchListTile.adaptive(
                      title: Text(AppStrings.pushNotifications),
                      subtitle: Text(AppStrings.editPushNotificationsSubtitle),
                      value: _pushOptIn,
                      onChanged: (value) => setState(() => _pushOptIn = value),
                    ),
                    // Promos hidden —
                    // SwitchListTile.adaptive(
                    //   title: const Text('Offres et nouveautés'),
                    //   subtitle: const Text(
                    //     'Recevoir les offres promotionnelles',
                    //   ),
                    //   value: _marketingOptIn,
                    //   onChanged: (value) =>
                    //       setState(() => _marketingOptIn = value),
                    // ),
                    SizedBox(height: 36.h),
                    AppButton.primary(
                      label: AppStrings.profileSaveCta,
                      onPressed: _saving ? null : _save,
                      isLoading: _saving,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
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
      if (!context.mounted) return;
      AppSnackbar.success(context, AppStrings.photoUpdated);
    } catch (error) {
      await context.handleHttpError(error, AppStrings.uploadFailed);
    } finally {
      if (mounted) {
        setState(() => _uploadingAvatar = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _resolvedPhoneValue();
    if (phone != null) {
      final session = ref.read(sessionProvider);
      final dio = ref.read(dioProvider);
      try {
        final check = await dio.get<Map<String, dynamic>>(
          '/api/v1/auth/check-availability',
          queryParameters: {
            'phone': phone,
            if (session.isAuthenticated) 'excludeUserId': session.userId,
          },
        );
        if (check.data?['phone'] == 'taken') {
          if (!mounted) return;
          AppSnackbar.error(
            context,
            'Ce numéro de téléphone est déjà utilisé par un autre compte.',
          );
          setState(() => _saving = false);
          return;
        }
      } catch (_) {
        // Silently continue — the API will return a proper error if taken.
      }
    }

    setState(() => _saving = true);
    try {
      await ref
          .read(profileProvider.notifier)
          .updateProfile(
            fullName: _fullNameController.text.trim(),
            phone: phone,
            syncPhone: true,
            preferredContactChannel: _contactChannel,
            pushOptIn: _pushOptIn,
            marketingOptIn: _marketingOptIn,
            preferredLanguage: _language,
          );
      if (!context.mounted) return;
      AppSnackbar.success(context, AppStrings.profileSaved);
      context.pop();
    } catch (error) {
      await context.handleHttpError(error, AppStrings.saveFailed);
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  String _channelLabel(String channel) {
    switch (channel) {
      case 'sms':
        return 'SMS';
      default:
        return 'Téléphone';
    }
  }

  void _seedPhone(String? rawPhone) {
    final result = seedPhone(rawPhone);
    if (result == null) {
      _phoneController.text = '';
      _phoneCountry = kPhoneCountries.first;
      return;
    }
    _phoneCountry = result.country;
    _phoneController.text = result.nationalDigits;
  }

  String? _resolvedPhoneValue() =>
      buildFullPhone(_phoneController.text, _phoneCountry);

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(labelText: label),
    );
  }
}

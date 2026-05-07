import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/app_http_error_handler.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_async_view.dart';
import '../../../core/widgets/app_city_dropdown.dart';
import '../../../core/widgets/app_error_state.dart';

import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../providers/profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  bool _saving = false;
  bool _uploadingAvatar = false;
  String? _localAvatarPath;
  String? _selectedCity;
  String _contactChannel = 'phone';
  String _language = 'fr';
  bool _pushOptIn = true;
  bool _marketingOptIn = false;
  bool _didSeedControllers = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final optionsAsync = ref.watch(profileOptionsProvider);

    return Scaffold(
      appBar: const AppTopBar(title: 'Modifier mon profil'),
      body: AppAsyncView(
        value: profileAsync,
        onRetry: () => ref.refresh(profileProvider.future),
        errorTitle: 'Impossible de charger le profil',
        builder: (profile) {
          if (profile == null) return const SizedBox.shrink();
          final avatarUrl = profile.avatarUrl;
          final hasRemoteAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
          if (!_didSeedControllers) {
            _didSeedControllers = true;
            _fullNameController.text = profile.fullName;
            _selectedCity = profile.city;
            _contactChannel = profile.preferredContactChannel;
            _language = profile.preferredLanguage;
            _pushOptIn = profile.pushOptIn;
            _marketingOptIn = profile.marketingOptIn;
          }
          return optionsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => AppErrorState(
              title: 'Impossible de charger les options',
              message: error.toString(),
              onRetry: () => ref.refresh(profileOptionsProvider.future),
            ),
            data: (options) => SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
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
                                ? Icon(Icons.person_outline, size: 44.r)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _uploadingAvatar ? null : _pickAvatar,
                              child: Container(
                                padding: EdgeInsets.all(10.r),
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: _uploadingAvatar
                                    ? SizedBox(
                                        width: 16.r,
                                        height: 16.r,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Icon(
                                        Icons.camera_alt,
                                        size: 16.r,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),
                    _buildTextField(
                      label: 'Nom complet',
                      controller: _fullNameController,
                      validator: (value) {
                        if (value == null || value.trim().length < 2) {
                          return 'Nom complet requis';
                        }
                        return null;
                      },
                    ),
                    gapH16,
                    AppCityDropdown(
                      value: _selectedCity,
                      cities: options.cities,
                      onChanged: (value) =>
                          setState(() => _selectedCity = value),
                    ),
                    gapH16,

                    SizedBox(height: 16.h),
                    DropdownButtonFormField<String>(
                      initialValue: _contactChannel,
                      decoration: const InputDecoration(
                        labelText: 'Canal de contact préféré',
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
                      decoration: const InputDecoration(
                        labelText: 'Langue préférée',
                      ),
                      items: options.languages
                          .map(
                            (language) => DropdownMenuItem(
                              value: language,
                              child: Text(
                                language == 'fr' ? 'Français' : 'English',
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
                      title: const Text('Notifications push'),
                      subtitle: const Text(
                        'Rappels et mises à jour de rendez-vous',
                      ),
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _save,
                        child: _saving
                            ? SizedBox(
                                width: 18.r,
                                height: 18.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Enregistrer'),
                      ),
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
      if (!mounted) return;
      AppSnackbar.success(context, 'Photo de profil mise à jour.');
    } catch (error) {
      await context.handleHttpError(error, 'Upload impossible.');
    } finally {
      if (mounted) {
        setState(() => _uploadingAvatar = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(profileProvider.notifier)
          .updateProfile(
            fullName: _fullNameController.text.trim(),
            city: _selectedCity,
            preferredContactChannel: _contactChannel,
            pushOptIn: _pushOptIn,
            marketingOptIn: _marketingOptIn,
            preferredLanguage: _language,
          );
      if (!mounted) return;
      AppSnackbar.success(context, 'Profil enregistré.');
      Navigator.of(context).pop();
    } catch (error) {
      await context.handleHttpError(error, 'Enregistrement impossible.');
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

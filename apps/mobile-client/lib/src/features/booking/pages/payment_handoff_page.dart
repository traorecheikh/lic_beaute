import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/utils/app_http_error_handler.dart';
import '../../../core/widgets/app_bottom_bar.dart';
import '../../../core/widgets/app_booking_async_scaffold.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_phone_field.dart';
import '../../../core/widgets/app_pressable.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../router/app_router.dart';
import '../../appointments/providers/bookings_list_provider.dart';
import '../../discovery/providers/cached_resource.dart';
import '../../profile/providers/payment_methods_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../providers/booking_create_provider.dart';
import '../providers/payment_methods_provider.dart';

class PaymentHandoffPage extends ConsumerStatefulWidget {
  final String bookingId;
  const PaymentHandoffPage({required this.bookingId, super.key});

  @override
  ConsumerState<PaymentHandoffPage> createState() => _PaymentHandoffPageState();
}

class _PaymentHandoffPageState extends ConsumerState<PaymentHandoffPage> {
  static const List<PhoneCountry> _djamoCountries = [
    PhoneCountry(code: 'SN', name: 'Sénégal', dialCode: '+221', flag: '🇸🇳', digits: 9),
    PhoneCountry(code: 'CI', name: "Côte d'Ivoire", dialCode: '+225', flag: '🇨🇮', digits: 10),
  ];

  String? _selectedMethod;
  String _selectedDjamoCountryCode = 'SN';
  bool _isProcessing = false;

  late final TextEditingController _phoneController;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _cardNumberController;
  late final TextEditingController _cardCvvController;
  late final TextEditingController _cardExpiryMonthController;
  late final TextEditingController _cardExpiryYearController;
  late final TextEditingController _walletPasswordController;
  bool _pciDssAccepted = false;
  bool _hasInitializedContactFields = false;
  bool _hasAppliedDefaultPaymentMethod = false;

  Future<bool> _launchExternalPaymentUri(
    Uri uri, {
    bool preferNonBrowser = false,
  }) async {
    if (preferNonBrowser) {
      final launchedNonBrowser = await launchUrl(
        uri,
        mode: LaunchMode.externalNonBrowserApplication,
      );
      if (launchedNonBrowser) {
        return true;
      }
    }

    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _cardNumberController = TextEditingController();
    _cardCvvController = TextEditingController();
    _cardExpiryMonthController = TextEditingController();
    _cardExpiryYearController = TextEditingController();
    _walletPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _cardNumberController.dispose();
    _cardCvvController.dispose();
    _cardExpiryMonthController.dispose();
    _cardExpiryYearController.dispose();
    _walletPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(bookingDetailResourceProvider(widget.bookingId));
    final depositFromBooking = detailAsync.asData?.value.depositXof;
    if (depositFromBooking != null && depositFromBooking <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pushReplacement(AppRoutes.success(widget.bookingId));
      });
      return const AppScaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final methodsAsync = ref.watch(paymentMethodsProvider);
    final defaultMethod = methodsAsync.asData?.value
        .where((m) => m.isDefault)
        .firstOrNull;
    final defaultChannel = _channelFromMethod(defaultMethod);

    if (_selectedMethod == null && defaultChannel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedMethod = defaultChannel);
      });
    }

    final profileAsync = ref.watch(profileProvider);
    final profile = profileAsync.asData?.value;
    if ((profile != null || defaultMethod != null) && !_hasInitializedContactFields) {
      _hasInitializedContactFields = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            final defaultPhone = defaultMethod?.phoneNumber.trim();
            final profilePhone = profile?.phone?.trim();
            if (defaultPhone != null && defaultPhone.isNotEmpty) {
              _phoneController.text = defaultPhone;
              _selectedDjamoCountryCode = _inferDjamoCountryCodeFromMethod(defaultMethod);
            } else if (profilePhone != null && profilePhone.isNotEmpty) {
              _phoneController.text = profilePhone;
              _selectedDjamoCountryCode = _inferDjamoCountryCode(profilePhone);
            }
            _nameController.text = profile?.fullName ?? '';
            if ((profile?.email?.trim().isNotEmpty ?? false)) {
              _emailController.text = profile!.email!.trim();
            }
          });
        }
      });
    }

    if (defaultMethod != null && !_hasAppliedDefaultPaymentMethod) {
      _hasAppliedDefaultPaymentMethod = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final defaultPhone = defaultMethod.phoneNumber.trim();
        final profilePhone = profile?.phone?.trim() ?? '';
        if (defaultPhone.isEmpty) return;
        if (_phoneController.text.trim().isEmpty || _phoneController.text.trim() == profilePhone) {
          setState(() {
            _phoneController.text = defaultPhone;
            _selectedDjamoCountryCode = _inferDjamoCountryCodeFromMethod(defaultMethod);
          });
        }
      });
    }

    final paydunyaMethodsAsync = ref.watch(availablePaydunyaMethodsProvider);

    return AppBookingAsyncScaffold<Map<String, dynamic>>(
      bookingId: widget.bookingId,
      provider: bookingDetailResourceProvider,
      errorTitle: 'Paiement indisponible pour le moment',
      serverTitle: 'Le récapitulatif de paiement est indisponible',
      pageTitle: 'Paiement',
      pageSubtitle: 'Sécurisez votre réservation avec un acompte.',
      bottomNavigationBar: _buildBottomBar(),
      sliverBuilder: (resource) {
        final deposit =
            (resource.data?['depositAmountXof'] as num?)?.toInt() ?? 0;

        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppPressable(
                  onTap: () => context.pop(),
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: AppIcon('arrow-left', size: 20, color: AppColors.onSurface),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.12),
                          AppColors.secondary.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.primaryLight,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Acompte à régler',
                                style: AppTextStyles.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              gapH4,
                              Text(
                                '$deposit XOF',
                                style: AppTextStyles.headlineLg.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              resource.salonName,
                              style: AppTextStyles.labelMd,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              resource.serviceName,
                              style: AppTextStyles.bodySm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),
                  if (defaultMethod != null) ...[
                    // User has stored payment method — show summary, no form needed
                    Text('Moyen de paiement', style: AppTextStyles.headlineSm),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  defaultMethod.label ?? 'Moyen de paiement',
                                  style: AppTextStyles.labelLg,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  profile != null && profile.fullName.isNotEmpty
                                      ? '${profile.fullName} · ${defaultMethod.phoneNumber}'
                                      : defaultMethod.phoneNumber,
                                  style: AppTextStyles.bodySm.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppIcon('check-circle', color: AppColors.primary, size: 24),
                        ],
                      ),
                    ),
                    if (_selectedMethod == 'djamo') ...[
                      SizedBox(height: 12.h),
                      _buildDjamoCountrySelector(),
                    ],
                  ] else if (profile != null && profile.fullName.isEmpty) ...[
                    // No payment method + no profile name — redirect to complete profile
                    _buildIncompleteProfileBanner(context),
                  ] else ...[
                    // No stored method — show selector + form
                    Text('Moyen de paiement', style: AppTextStyles.headlineSm),
                    SizedBox(height: 14.h),
                    paydunyaMethodsAsync.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      error: (error, _) => Text(
                        'Impossible de charger les moyens de paiement',
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                      data: (methods) => Column(
                        children: methods
                            .where((m) => m.enabled)
                            .map((method) {
                              final isSelected = _selectedMethod == method.code;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Column(
                                  children: [
                                    _MethodTile(
                                      id: method.code,
                                      label: method.label,
                                      selected: isSelected,
                                      onTap: () => setState(
                                          () => _selectedMethod = method.code),
                                    ),
                                    if (isSelected) _buildFormForMethod(method.code, profile: profile, defaultMethod: defaultMethod),
                                  ],
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ];
      },
    );
  }

  Widget _buildIncompleteProfileBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon('user-circle', color: AppColors.primary, size: 22),
              gapW8,
              Expanded(
                child: Text(
                  'Complétez votre profil pour payer',
                  style: AppTextStyles.labelLg.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          gapH8,
          Text(
            'Ajoutez votre nom complet et un moyen de paiement pour finaliser votre réservation.',
            style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
          ),
          gapH16,
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  label: 'Mon profil',
                  onPressed: () => context.push(AppRoutes.profileEdit),
                ),
              ),
              gapW8,
              Expanded(
                child: AppButton.primary(
                  label: 'Paiement',
                  onPressed: () => context.push(AppRoutes.profilePayments),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormForMethod(String methodCode, {required dynamic profile, required dynamic defaultMethod}) {
    if (methodCode == 'carte_bancaire') {
      return Container(
        margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informations de la carte', style: AppTextStyles.labelLg),
            gapH12,
            _buildTextField(
              controller: _nameController,
              label: 'Nom sur la carte',
              hint: 'John Doe',
            ),
            gapH12,
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'john.doe@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            gapH12,
            _buildTextField(
              controller: _cardNumberController,
              label: 'Numéro de carte',
              hint: '4111 1111 1111 1111',
              keyboardType: TextInputType.number,
              onChanged: _formatCardNumber,
            ),
            gapH12,
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _cardExpiryMonthController,
                    label: 'Mois exp. (MM)',
                    hint: '12',
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                  ),
                ),
                gapW12,
                Expanded(
                  child: _buildTextField(
                    controller: _cardExpiryYearController,
                    label: 'Année exp. (YY)',
                    hint: '28',
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                  ),
                ),
                gapW12,
                Expanded(
                  child: _buildTextField(
                    controller: _cardCvvController,
                    label: 'CVC / CVV',
                    hint: '123',
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                  ),
                ),
              ],
            ),
            gapH12,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _pciDssAccepted,
                  onChanged: (val) => setState(() => _pciDssAccepted = val ?? false),
                  activeColor: AppColors.primary,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      "Je reconnais que la transaction est soumise aux règles de sécurité PCI-DSS et j'accepte de soumettre mes informations bancaires.",
                      style: AppTextStyles.bodySm.copyWith(color: AppColors.error),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (methodCode == 'paydunya_wallet') {
      return Container(
        margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Portefeuille PayDunya', style: AppTextStyles.labelLg),
            gapH12,
            _buildTextField(
              controller: _phoneController,
              label: 'Numéro de téléphone / Email',
              hint: 'john.doe@example.com ou 77XXXXXXX',
            ),
            gapH12,
            _buildTextField(
              controller: _walletPasswordController,
              label: 'Mot de passe PayDunya',
              hint: '••••••••',
              obscureText: true,
            ),
          ],
        ),
      );
    } else {
      final showOtpTip = methodCode == 'om_ci' || methodCode == 'om_bf';
      String otpTip = '';
      if (methodCode == 'om_ci') {
        otpTip = 'Composez le #144*82# pour obtenir un code d\'autorisation Orange Money.';
      } else if (methodCode == 'om_bf') {
        otpTip = 'Générez un code OTP Orange Money en composant le *144*4*6*montant#.';
      }

      return Container(
        margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informations de paiement', style: AppTextStyles.labelLg),
            if (methodCode == 'djamo') ...[
              gapH12,
              _buildDjamoCountrySelector(),
            ],
            if (defaultMethod != null) ...[
              gapH8,
              Text(
                profile != null && profile.fullName.isNotEmpty
                    ? '${profile.fullName} · ${defaultMethod.phoneNumber}'
                    : defaultMethod.phoneNumber,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              if (profile?.email != null && profile!.email!.isNotEmpty)
                Text(
                  profile.email!,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
            ] else ...[
              gapH12,
              _buildTextField(
                controller: _phoneController,
                label: 'Numéro de téléphone',
                hint: '77XXXXXXX',
                keyboardType: TextInputType.phone,
              ),
              gapH12,
              _buildTextField(
                controller: _nameController,
                label: 'Nom complet',
                hint: 'John Doe',
              ),
              gapH12,
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'john.doe@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
            ],
            if (showOtpTip) ...[
              gapH12,
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppIcon('info', color: AppColors.primary, size: 18),
                    gapW8,
                    Expanded(
                      child: Text(
                        otpTip,
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              gapH12,
              _buildTextField(
                controller: _walletPasswordController,
                label: 'Code d\'autorisation OTP',
                hint: '1234',
                keyboardType: TextInputType.number,
              ),
            ],
          ],
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int? maxLength,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySm.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        gapH4,
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLength: maxLength,
          onChanged: onChanged,
          buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
          style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySm.copyWith(color: AppColors.outline),
            filled: true,
            fillColor: AppColors.surfaceVariant,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDjamoCountrySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pays du compte Djamo',
          style: AppTextStyles.bodySm.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        gapH4,
        DropdownButtonFormField<String>(
          initialValue: _selectedDjamoCountryCode,
          items: _djamoCountries
              .map(
                (country) => DropdownMenuItem<String>(
                  value: country.code,
                  child: Text(
                    '${country.flag} ${country.name}',
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurface),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => _selectedDjamoCountryCode = value);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceVariant,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  void _formatCardNumber(String value) {
    final digits = value.replaceAll(RegExp(r'\s+'), '');
    final formatted = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted.write(' ');
      }
      formatted.write(digits[i]);
    }
    final text = formatted.toString();
    _cardNumberController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  Widget _buildBottomBar() {
    return AppBottomBar(
      child: AppButton.primary(
        onPressed: _selectedMethod == null ? null : _pay,
        label: _selectedMethod != null
            ? 'Payer'
            : 'Continuer',
        isLoading: _isProcessing,
      ),
    );
  }

  Future<void> _pollPaymentConfirmation(String paymentId) async {
    if (!mounted) return;
    bool confirmed = false;

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _PaymentWaitingSheet(
          paymentId: paymentId,
          onConfirmed: () {
            confirmed = true;
            Navigator.of(sheetContext).pop();
          },
          onFailed: (msg) {
            Navigator.of(sheetContext).pop();
            if (mounted) AppSnackbar.error(context, msg);
          },
          reconcile: (id) => ref.read(paymentInitiateProvider.notifier).reconcile(id),
        );
      },
    );

    if (confirmed && mounted) {
      context.pushReplacement(AppRoutes.success(widget.bookingId));
    }
  }

  Future<String?> _showOtpDialog(String label) async {
    final codeController = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Validation OTP',
            style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saisissez le code de validation reçu par SMS pour valider votre paiement via $label.',
                style: AppTextStyles.bodySm,
              ),
              gapH16,
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Code de validation (OTP)',
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Annuler',
                style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (codeController.text.trim().isNotEmpty) {
                  Navigator.pop(context, codeController.text.trim());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text('Confirmer', style: AppTextStyles.labelLg),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pay() async {
    if (_selectedMethod == null) return;

    if (_selectedMethod == 'carte_bancaire') {
      if (!_pciDssAccepted) {
        AppSnackbar.error(context, 'Vous devez accepter les conditions PCI-DSS.');
        return;
      }
      if (_nameController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty ||
          _cardNumberController.text.trim().isEmpty ||
          _cardCvvController.text.trim().isEmpty ||
          _cardExpiryMonthController.text.trim().isEmpty ||
          _cardExpiryYearController.text.trim().isEmpty) {
        AppSnackbar.error(context, 'Veuillez remplir tous les champs de la carte.');
        return;
      }
    } else if (_selectedMethod == 'paydunya_wallet') {
      if (_phoneController.text.trim().isEmpty ||
          _walletPasswordController.text.trim().isEmpty) {
        AppSnackbar.error(context, 'Veuillez remplir vos identifiants PayDunya.');
        return;
      }
    } else {
      final profileData = ref.read(profileProvider).asData?.value;
      final methodsData = ref.read(paymentMethodsProvider).asData?.value;
      final storedDefault = methodsData?.where((m) => m.isDefault).firstOrNull;
      final effectivePhone = _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : storedDefault?.phoneNumber ?? profileData?.phone ?? '';
      if (effectivePhone.isEmpty) {
        AppSnackbar.error(context, 'Veuillez saisir votre numéro de téléphone.');
        return;
      }
    }

    setState(() => _isProcessing = true);
    try {
      final paymentResult = await ref
          .read(paymentInitiateProvider.notifier)
          .initiate(bookingId: widget.bookingId, channel: _selectedMethod!);
      final paymentId = paymentResult?['paymentId'] as String?;
      if (paymentId == null || paymentId.isEmpty) {
        throw Exception('Échec de la création du paiement.');
      }

      final Map<String, dynamic> details = {};
      if (_selectedMethod == 'carte_bancaire') {
        details['fullName'] = _nameController.text.trim();
        details['email'] = _emailController.text.trim();
        details['cardNumber'] = _cardNumberController.text.replaceAll(' ', '');
        details['cardCvv'] = _cardCvvController.text.trim();
        details['cardExpiredDateMonth'] = _cardExpiryMonthController.text.trim();
        details['cardExpiredDateYear'] = _cardExpiryYearController.text.trim();
      } else if (_selectedMethod == 'paydunya_wallet') {
        details['phone'] = _phoneController.text.trim();
        details['password'] = _walletPasswordController.text.trim();
      } else {
        final profileSnap = ref.read(profileProvider).asData?.value;
        final methodsSnap = ref.read(paymentMethodsProvider).asData?.value;
        final storedDefault = methodsSnap?.where((m) => m.isDefault).firstOrNull;
        details['phone'] = _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : storedDefault?.phoneNumber ?? profileSnap?.phone ?? '';
        details['fullName'] = _nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : profileSnap?.fullName ?? '';
        details['email'] = _emailController.text.trim().isNotEmpty
            ? _emailController.text.trim()
            : profileSnap?.email ?? '';
        if (_selectedMethod == 'djamo') {
          details['code_country'] = _selectedDjamoCountryCode.toLowerCase();
        }
        if (_selectedMethod == 'om_ci' || _selectedMethod == 'om_bf') {
          details['otp'] = _walletPasswordController.text.trim();
        }
      }

      final executeResult = await ref
          .read(paymentInitiateProvider.notifier)
          .execute(paymentId: paymentId, method: _selectedMethod!, details: details);

      if (!context.mounted) return;

      if (executeResult?['success'] == true) {
        final url = executeResult?['url'] as String?;
        // OM deep links take priority over QR on mobile (per PayDunya docs)
        final omUrl = executeResult?['other_url']?['om_url'] as String?
            ?? executeResult?['data']?['om_url'] as String?;
        final maxitUrl = executeResult?['other_url']?['maxit_url'] as String?
            ?? executeResult?['data']?['maxit_url'] as String?;
        final deepLink = omUrl ?? maxitUrl;

        if (deepLink != null) {
          final uri = Uri.parse(deepLink);
          final launched = await _launchExternalPaymentUri(
            uri,
            preferNonBrowser: true,
          );
          if (!launched) {
            if (url != null) {
              final fallbackUri = Uri.parse(url);
              await _launchExternalPaymentUri(fallbackUri);
            }
          }
          if (mounted) await _pollPaymentConfirmation(paymentId);
          return;
        }

        final cid = executeResult?['data']?['details']?['cid'] as String?
            ?? executeResult?['data']?['cid'] as String?;
        if (cid != null && cid.isNotEmpty) {
          final otp = await _showOtpDialog('Wizall Sénégal');
          if (otp != null && otp.isNotEmpty) {
            setState(() => _isProcessing = true);
            final confirmResult = await ref.read(paymentInitiateProvider.notifier).execute(
              paymentId: paymentId,
              method: 'wizall_senegal',
              details: {
                'phone_number': _phoneController.text.trim(),
                'authorization_code': otp,
                'transaction_id': cid,
              },
            );
            if (!context.mounted) return;
            if (confirmResult?['success'] == true) {
              await _pollPaymentConfirmation(paymentId);
            } else {
              final msg = confirmResult?['message'] as String? ?? 'Échec de la validation Wizall.';
              if (mounted) AppSnackbar.error(context, msg);
            }
          }
          return;
        }

        if (url != null && url.isNotEmpty) {
          final uri = Uri.parse(url);
          await _launchExternalPaymentUri(uri);
          if (mounted) await _pollPaymentConfirmation(paymentId);
          return;
        }

        // Direct success (no redirect needed) — verify with PayDunya and navigate
        if (mounted) await _pollPaymentConfirmation(paymentId);
      } else {
        final msg = executeResult?['message'] as String? ?? 'Échec du paiement.';
        if (mounted) AppSnackbar.error(context, msg);
      }
    } catch (e) {
      if (!context.mounted) return;
      await _handlePaymentError(e);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handlePaymentError(Object error) async {
    if (error is DioException) {
      final code =
          (error.response?.data as Map<String, dynamic>?)?['code'] as String?;
      final retryAfter =
          (error.response?.data as Map<String, dynamic>?)?['message']
              as String?;

      switch (code) {
        case 'phone_required':
          AppSnackbar.error(
            context,
            'Ajoutez un numéro de téléphone à votre profil pour payer.',
          );
          await Future.delayed(const Duration(milliseconds: 600));
          if (mounted) context.push(AppRoutes.profileEdit);
          return;
        case 'reconcile_throttled':
          AppSnackbar.info(
            context,
            retryAfter ??
                'Réconciliation trop fréquente. Réessayez dans quelques secondes.',
          );
          return;
      }
    }
    if (mounted) context.handleHttpError(error, 'Échec du paiement.');
  }

  String? _channelFromMethod(dynamic method) {
    if (method == null) return null;
    final provider = method.provider as String? ?? '';
    if (provider != 'paydunya') return null;
    final savedMethod = (method.method as String?)?.trim();
    if (savedMethod != null && savedMethod.isNotEmpty) {
      return savedMethod;
    }
    final label = (method.label as String? ?? '').toLowerCase();
    if (label.contains('portefeuille paydunya')) return 'paydunya_wallet';
    if (label.contains('djamo')) return 'djamo';
    if (label.contains('wizall')) return 'wizall_senegal';
    if (label.contains('expresso')) return 'expresso_sn';
    if (label.contains('free')) return 'free_senegal';
    if (label.contains('orange money sénégal')) return 'orange_senegal';
    if (label.contains('orange money côte')) return 'om_ci';
    if (label.contains('orange money burkina')) return 'om_bf';
    if (label.contains('orange money mali')) return 'om_ml';
    if (label.contains('mtn money côte')) return 'mtn_ci';
    if (label.contains('mtn bénin')) return 'mtn_bj';
    if (label.contains('mtn cameroun')) return 'mtn_cm';
    if (label.contains('moov côte')) return 'moov_ci';
    if (label.contains('moov burkina')) return 'moov_bf';
    if (label.contains('moov bénin')) return 'moov_bj';
    if (label.contains('moov togo')) return 'moov_tg';
    if (label.contains('moov mali')) return 'moov_ml';
    if (label.contains('t-money')) return 't_money_tg';
    if (label.contains('wave côte')) return 'wave_ci';
    if (label.contains('wave')) return 'wave_senegal';
    return null;
  }

  String _inferDjamoCountryCode(String phone) {
    final normalized = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (normalized.startsWith('+225') || normalized.startsWith('225') || normalized.length == 10) {
      return 'CI';
    }
    return 'SN';
  }

  String _inferDjamoCountryCodeFromMethod(dynamic method) {
    final savedCountry = (method?.country as String?)?.trim().toUpperCase();
    if (savedCountry == 'CI' || savedCountry == 'SN') {
      return savedCountry!;
    }
    final phone = method?.phoneNumber as String? ?? '';
    return _inferDjamoCountryCode(phone);
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.id,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String id, label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppIcon('smartphone', size: 20, color: AppColors.onSurfaceVariant),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.labelLg),
                  SizedBox(height: 2.h),
                  Text(
                    id.replaceAll('_', ' ').toUpperCase(),
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              AppIcon('check-circle', color: AppColors.primary, size: 22)
            else
              AppIcon('circle', color: AppColors.outline, size: 22),
          ],
        ),
      ),
    );
  }
}

class _PaymentWaitingSheet extends StatefulWidget {
  const _PaymentWaitingSheet({
    required this.paymentId,
    required this.onConfirmed,
    required this.onFailed,
    required this.reconcile,
  });

  final String paymentId;
  final VoidCallback onConfirmed;
  final void Function(String message) onFailed;
  final Future<String?> Function(String paymentId) reconcile;

  @override
  State<_PaymentWaitingSheet> createState() => _PaymentWaitingSheetState();
}

class _PaymentWaitingSheetState extends State<_PaymentWaitingSheet>
    with WidgetsBindingObserver {
  static const _pollInterval = Duration(seconds: 6);
  static const _timeout = Duration(minutes: 5);
  bool _manualChecking = false;
  bool _backgroundChecking = false;
  int _elapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_runCheck(showLoading: false));
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(_pollInterval, (_) async {
      _elapsed += _pollInterval.inSeconds;
      if (_elapsed >= _timeout.inSeconds) {
        _timer?.cancel();
        // Timeout — let user stay on page, webhook will eventually come
        return;
      }
      await _runCheck(showLoading: false);
    });
  }

  Future<void> _check() async {
    await _runCheck(showLoading: true);
  }

  Future<void> _runCheck({required bool showLoading}) async {
    if ((_backgroundChecking || _manualChecking) || !mounted) return;
    if (showLoading) {
      setState(() => _manualChecking = true);
    } else {
      _backgroundChecking = true;
    }
    try {
      final status = await widget.reconcile(widget.paymentId);
      if (!mounted) return;
      if (status == 'succeeded') {
        _timer?.cancel();
        widget.onConfirmed();
      } else if (status == 'failed' || status == 'refunded') {
        _timer?.cancel();
        widget.onFailed('Le paiement a échoué. Veuillez réessayer.');
      }
    } catch (_) {
      // Network error — keep polling
    } finally {
      _backgroundChecking = false;
      if (mounted && showLoading) {
        setState(() => _manualChecking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final timedOut = _elapsed >= _timeout.inSeconds;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 28.h),
          if (!timedOut) ...[
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
              'Vérification en cours…',
              style: AppTextStyles.labelLg,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Complétez le paiement dans votre application, puis revenez ici.',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            AppIcon('clock', color: AppColors.onSurfaceVariant, size: 48),
            SizedBox(height: 20.h),
            Text(
              'En attente de confirmation',
              style: AppTextStyles.labelLg,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'Le paiement sera confirmé automatiquement dès que votre opérateur nous notifie. Vous pouvez fermer cette fenêtre.',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: 24.h),
          AppButton.outline(
            label: _manualChecking ? 'Vérification…' : 'Vérifier maintenant',
            onPressed: _manualChecking ? null : _check,
            isLoading: _manualChecking,
          ),
          if (timedOut) ...[
            SizedBox(height: 12.h),
            AppButton.primary(
              label: 'Fermer',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ],
      ),
    );
  }
}

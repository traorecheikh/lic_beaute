import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/constants/app_contacts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/foreground_notification_service.dart';
import '../../../core/utils/app_http_error_handler.dart';
import '../../../core/widgets/app_bottom_bar.dart';
import '../../../core/widgets/app_booking_async_scaffold.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_phone_field.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../router/app_router.dart';
import '../../appointments/models/booking_detail.dart';
import '../../appointments/providers/bookings_list_provider.dart';
import '../../discovery/providers/cached_resource.dart';
import '../payment_handoff_navigation.dart';
import '../payment_utils.dart';
import '../paydunya_launch.dart';
import '../../profile/providers/payment_methods_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../providers/booking_create_provider.dart';
import '../providers/payment_methods_provider.dart';
import '../widgets/method_tile.dart';
import '../widgets/payment_form_fields.dart';
import '../widgets/payment_waiting_sheet.dart';

class PaymentHandoffPage extends ConsumerStatefulWidget {
  final String bookingId;
  final String? resumePaymentId;
  final bool openedFromCallback;

  const PaymentHandoffPage({
    required this.bookingId,
    this.resumePaymentId,
    this.openedFromCallback = false,
    super.key,
  });

  @override
  ConsumerState<PaymentHandoffPage> createState() => _PaymentHandoffPageState();
}

class _PaymentHandoffPageState extends ConsumerState<PaymentHandoffPage> {
  static const List<PhoneCountry> _djamoCountries = [
    PhoneCountry(
      code: 'SN',
      name: 'Sénégal',
      dialCode: '+221',
      flag: '🇸🇳',
      digits: 9,
    ),
    PhoneCountry(
      code: 'CI',
      name: "Côte d'Ivoire",
      dialCode: '+225',
      flag: '🇨🇮',
      digits: 10,
    ),
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
  bool _initScheduled = false;
  bool _resumedCallbackFlow = false;

  // ── Background polling state ──────────────────────────────────────────
  static const _maxBackgroundPollAttempts = 3;
  static const _backgroundPollInterval = Duration(minutes: 15);
  Timer? _backgroundPollTimer;
  int _backgroundPollAttempts = 0;
  String? _backgroundPollPaymentId;
  bool _backgroundPollActive = false;
  bool _backgroundPollExhausted = false;

  // ── URL Launching ──────────────────────────────────────────────────────

  Future<bool> _launchExternalPaymentUri(
    Uri uri, {
    bool preferNonBrowser = false,
  }) async {
    try {
      if (preferNonBrowser) {
        final launchedNonBrowser = await launchUrl(
          uri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
        if (launchedNonBrowser) return true;
      }
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return true;
      return launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      try {
        return launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (_) {
        return false;
      }
    }
  }

  Future<bool> _launchExternalPaymentCandidates(
    Iterable<String?> candidates, {
    bool preferNonBrowser = false,
  }) async {
    for (final candidate in candidates) {
      final uri = Uri.tryParse(candidate?.trim() ?? '');
      if (uri == null) continue;
      final launched = await _launchExternalPaymentUri(
        uri,
        preferNonBrowser: preferNonBrowser,
      );
      if (launched) return true;
    }
    return false;
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _resumePaymentFromCallbackIfNeeded();
    });
  }

  @override
  void dispose() {
    _cancelBackgroundPolling();
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

  void _schedulePendingInit() {
    if (_initScheduled) return;
    _initScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processPendingInit();
      _initScheduled = false;
    });
  }

  void _processPendingInit() {
    if (!mounted) return;
    final detailAsync = ref.read(
      bookingDetailResourceProvider(widget.bookingId),
    );
    final depositFromBooking = detailAsync.asData?.value.depositXof;
    if (depositFromBooking != null && depositFromBooking <= 0) {
      context.pushReplacement(AppRoutes.success(widget.bookingId));
      return;
    }

    final methodsAsync = ref.read(paymentMethodsProvider);
    final defaultMethod = methodsAsync.asData?.value
        .where((m) => m.isDefault)
        .firstOrNull;
    final defaultChannel = _channelFromMethod(defaultMethod);

    if (_selectedMethod == null && defaultChannel != null) {
      setState(() => _selectedMethod = defaultChannel);
    }

    final profileAsync = ref.read(profileProvider);
    final profile = profileAsync.asData?.value;

    if ((profile != null || defaultMethod != null) &&
        !_hasInitializedContactFields) {
      _hasInitializedContactFields = true;
      setState(() {
        final defaultPhone = defaultMethod?.phoneNumber.trim();
        final profilePhone = profile?.phone?.trim();
        if (defaultPhone != null && defaultPhone.isNotEmpty) {
          _phoneController.text = defaultPhone;
          _selectedDjamoCountryCode = _inferDjamoCountryCodeFromMethod(
            defaultMethod,
          );
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

    if (defaultMethod != null && !_hasAppliedDefaultPaymentMethod) {
      _hasAppliedDefaultPaymentMethod = true;
      final defaultPhone = defaultMethod.phoneNumber.trim();
      final profilePhone = profile?.phone?.trim() ?? '';
      if (defaultPhone.isNotEmpty &&
          (_phoneController.text.trim().isEmpty ||
              _phoneController.text.trim() == profilePhone)) {
        setState(() {
          _phoneController.text = defaultPhone;
          _selectedDjamoCountryCode = _inferDjamoCountryCodeFromMethod(
            defaultMethod,
          );
        });
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(
      bookingDetailResourceProvider(widget.bookingId),
    );
    final depositFromBooking = detailAsync.asData?.value.depositXof;
    if (depositFromBooking != null && depositFromBooking <= 0) {
      _schedulePendingInit();
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
      _schedulePendingInit();
    }

    final profileAsync = ref.watch(profileProvider);
    final profile = profileAsync.asData?.value;
    if ((profile != null || defaultMethod != null) &&
        !_hasInitializedContactFields) {
      _schedulePendingInit();
    }
    if (defaultMethod != null && !_hasAppliedDefaultPaymentMethod) {
      _schedulePendingInit();
    }

    final paydunyaMethodsAsync = ref.watch(availablePaydunyaMethodsProvider);

    return AppBookingAsyncScaffold<BookingDetail>(
      bookingId: widget.bookingId,
      provider: bookingDetailResourceProvider,
      errorTitle: 'Paiement indisponible pour le moment',
      serverTitle: 'Le récapitulatif de paiement est indisponible',
      appBar: AppTopBar(showBackButton: true, onBack: _handleBackNavigation),
      pageTitle: 'Paiement',
      pageSubtitle: 'Sécurisez votre réservation avec un acompte.',
      bottomNavigationBar: _buildBottomBar(),
      sliverBuilder: (resource) {
        final deposit = resource.depositXof ?? 0;
        return [
          if (_backgroundPollActive || _backgroundPollExhausted)
            SliverToBoxAdapter(
              child: _buildBackgroundPollBanner(),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDepositSummary(deposit, resource),
                  SizedBox(height: 28.h),
                  if (_backgroundPollActive || _backgroundPollExhausted)
                    const SizedBox.shrink()
                  else if (defaultMethod != null)
                    _buildStoredMethodSection(defaultMethod, profile)
                  else if (profile != null && profile.fullName.isEmpty)
                    _buildIncompleteProfileBanner(context)
                  else
                    _buildMethodSelector(
                      paydunyaMethodsAsync,
                      profile,
                      defaultMethod,
                    ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }

  Widget _buildDepositSummary(
    int deposit,
    CachedResource<BookingDetail> resource,
  ) {
    return Container(
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
        borderRadius: BorderRadius.circular(AppRadius.xl.r),
        border: Border.all(color: AppColors.primaryLight, width: 1.5),
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
              Text(resource.salonName, style: AppTextStyles.labelMd),
              SizedBox(height: 2.h),
              Text(resource.serviceName, style: AppTextStyles.bodySm),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoredMethodSection(dynamic defaultMethod, dynamic profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Moyen de paiement', style: AppTextStyles.headlineSm),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg.r),
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
      ],
    );
  }

  Widget _buildMethodSelector(
    AsyncValue<List<PaydunyaMethodRecord>> paydunyaMethodsAsync,
    dynamic profile,
    dynamic defaultMethod,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            style: AppTextStyles.bodySm.copyWith(color: AppColors.error),
          ),
          data: (methods) => Column(
            children: methods.where((m) => m.enabled).map((method) {
              final isSelected = _selectedMethod == method.code;
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Column(
                  children: [
                    MethodTile(
                      id: method.code,
                      label: method.label,
                      selected: isSelected,
                      onTap: () =>
                          setState(() => _selectedMethod = method.code),
                    ),
                    if (isSelected)
                      _buildFormForMethod(
                        method.code,
                        profile: profile,
                        defaultMethod: defaultMethod,
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildIncompleteProfileBanner(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
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
                  style: AppTextStyles.labelLg.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          gapH8,
          Text(
            'Ajoutez votre nom complet et un moyen de paiement pour finaliser votre réservation.',
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          gapH16,
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  label: 'Mon profil',
                  onPressed: () => context.go(
                    paymentHandoffProfileSetupRoute(widget.bookingId),
                  ),
                ),
              ),
              gapW8,
              Expanded(
                child: AppButton.primary(
                  label: 'Paiement',
                  onPressed: () => context.go(
                    paymentHandoffMethodSetupRoute(widget.bookingId),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleBackNavigation() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(paymentHandoffBackFallbackRoute(widget.bookingId));
  }

  // ── Form Builders ──────────────────────────────────────────────────────

  Widget _buildFormForMethod(
    String methodCode, {
    required dynamic profile,
    required dynamic defaultMethod,
  }) {
    if (methodCode == 'carte_bancaire') return _buildCardForm();
    if (methodCode == 'paydunya_wallet') return _buildWalletForm();
    return _buildMobileMoneyForm(
      methodCode,
      profile: profile,
      defaultMethod: defaultMethod,
    );
  }

  Widget _buildCardForm() {
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
          Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.successContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppIcon('shield-check', color: AppColors.success, size: 20),
                gapW8,
                Expanded(
                  child: Text(
                    'Les données de votre carte sont transmises de manière sécurisée via PayDunya. Elles ne sont pas stockées sur nos serveurs.',
                    style: AppTextStyles.bodyXs.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text('Informations de la carte', style: AppTextStyles.labelLg),
          gapH12,
          buildPaymentTextField(
            controller: _nameController,
            label: 'Nom sur la carte',
            hint: 'John Doe',
          ),
          gapH12,
          buildPaymentTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'john.doe@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          gapH12,
          buildPaymentTextField(
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
                child: buildPaymentTextField(
                  controller: _cardExpiryMonthController,
                  label: 'Mois exp. (MM)',
                  hint: '12',
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                ),
              ),
              gapW12,
              Expanded(
                child: buildPaymentTextField(
                  controller: _cardExpiryYearController,
                  label: 'Année exp. (YY)',
                  hint: '28',
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                ),
              ),
              gapW12,
              Expanded(
                child: buildPaymentTextField(
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
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.successContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _pciDssAccepted,
                  onChanged: (val) =>
                      setState(() => _pciDssAccepted = val ?? false),
                  activeColor: AppColors.primary,
                  visualDensity: VisualDensity.compact,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      "J'accepte de soumettre mes informations bancaires via PayDunya. Mes données sont chiffrées en transit (TLS) et non stockées sur Beauté Avenue.",
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletForm() {
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
          buildPaymentTextField(
            controller: _phoneController,
            label: 'Numéro de téléphone / Email',
            hint: 'john.doe@example.com ou 77XXXXXXX',
          ),
          gapH12,
          buildPaymentTextField(
            controller: _walletPasswordController,
            label: 'Mot de passe PayDunya',
            hint: '••••••••',
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileMoneyForm(
    String methodCode, {
    required dynamic profile,
    required dynamic defaultMethod,
  }) {
    final showOtpTip = methodCode == 'om_ci' || methodCode == 'om_bf';
    String otpTip = '';
    if (methodCode == 'om_ci') {
      otpTip =
          'Composez le #144*82# pour obtenir un code d\'autorisation Orange Money.';
    } else if (methodCode == 'om_bf') {
      otpTip =
          'Générez un code OTP Orange Money en composant le *144*4*6*montant#.';
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
          if (methodCode == 'djamo') ...[gapH12, _buildDjamoCountrySelector()],
          if (defaultMethod != null) ...[
            gapH8,
            Semantics(
              label:
                  'Moyen de paiement par défaut: ${defaultMethod.phoneNumber}',
              child: Text(
                profile != null && profile.fullName.isNotEmpty
                    ? '${profile.fullName} · ${defaultMethod.phoneNumber}'
                    : defaultMethod.phoneNumber,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            if (profile?.email != null && profile!.email!.isNotEmpty)
              Semantics(
                label: 'Email: ${profile.email}',
                child: Text(
                  profile.email!,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
          ] else ...[
            gapH12,
            AppPhoneField(
              controller: _phoneController,
              labelText: 'Numéro de téléphone',
              initialCountry: _selectedDjamoCountryCode == 'CI'
                  ? kPhoneCountries[1]
                  : kPhoneCountries[0],
            ),
            gapH12,
            buildPaymentTextField(
              controller: _nameController,
              label: 'Nom complet',
              hint: 'John Doe',
            ),
            gapH12,
            buildPaymentTextField(
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
            buildPaymentTextField(
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

  Widget _buildDjamoCountrySelector() {
    return Semantics(
      label: 'Pays du compte Djamo',
      child: AppDropdown<String>(
        label: 'Pays du compte Djamo',
        value: _selectedDjamoCountryCode,
        items: _djamoCountries.map((c) => c.code).toList(),
        itemLabel: (code) {
          final country = _djamoCountries.firstWhere((c) => c.code == code);
          return '${country.flag} ${country.name}';
        },
        itemLeading: (code) {
          final country = _djamoCountries.firstWhere((c) => c.code == code);
          return ExcludeSemantics(
            child: Text(country.flag, style: TextStyle(fontSize: 20.sp)),
          );
        },
        onChanged: (value) => setState(() => _selectedDjamoCountryCode = value),
      ),
    );
  }

  void _formatCardNumber(String value) {
    final digits = value.replaceAll(RegExp(r'\s+'), '');
    final formatted = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) formatted.write(' ');
      formatted.write(digits[i]);
    }
    final text = formatted.toString();
    _cardNumberController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  Widget _buildBottomBar() {
    if (_backgroundPollActive) {
      return AppBottomBar(
        child: SizedBox(
          width: double.infinity,
          child: AppButton.outline(
            onPressed: () => AppSnackbar.info(
              context,
              AppStrings.paymentBackgroundSubtitle,
            ),
            label: AppStrings.paymentBackgroundTitle,
            isLoading: true,
          ),
        ),
      );
    }

    if (_backgroundPollExhausted) {
      return AppBottomBar(
        child: Row(
          children: [
            Expanded(
              child: AppButton.outline(
                onPressed: () =>
                    _startBackgroundPolling(_backgroundPollPaymentId!),
                label: AppStrings.paymentRetry,
              ),
            ),
            gapW8,
            Expanded(
              child: AppButton.primary(
                onPressed: () {
                  final uri = Uri(
                    scheme: 'mailto',
                    path: AppContacts.supportEmail,
                    queryParameters: {
                      'subject':
                          '${AppStrings.paymentSupportSubject} #${widget.bookingId}',
                      'body':
                          '${AppStrings.paymentSupportBody}${widget.bookingId}',
                    },
                  );
                  unawaited(launchUrl(uri));
                },
                label: AppStrings.paymentContactSupport,
              ),
            ),
          ],
        ),
      );
    }

    return AppBottomBar(
      child: AppButton.primary(
        onPressed: _selectedMethod == null ? null : _pay,
        label: _selectedMethod != null ? 'Payer' : 'Continuer',
        isLoading: _isProcessing,
      ),
    );
  }

  Widget _buildBackgroundPollBanner() {
    if (_backgroundPollExhausted) {
      return Container(
        margin: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 0),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            AppIcon('alert-circle', color: AppColors.error, size: 24),
            gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.paymentCheckFailedTitle,
                    style: AppTextStyles.labelLg.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    AppStrings.paymentCheckFailedAction,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 0),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20.r,
            height: 20.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.paymentBackgroundBanner,
                  style: AppTextStyles.labelLg.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  AppStrings.paymentBackgroundBannerSub,
                  style: AppTextStyles.bodyXs.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _resumePaymentFromCallbackIfNeeded() async {
    final paymentId = widget.resumePaymentId?.trim();
    if (!widget.openedFromCallback ||
        _resumedCallbackFlow ||
        paymentId == null ||
        paymentId.isEmpty ||
        !mounted) {
      return;
    }
    _resumedCallbackFlow = true;
    await _pollPaymentConfirmationWithLaunchTargets(
      paymentId: paymentId,
      pendingProviderConfirmation: true,
    );
  }

  // ── Payment Polling ────────────────────────────────────────────────────

  Future<void> _pollPaymentConfirmation(String paymentId) async {
    await _pollPaymentConfirmationWithLaunchTargets(paymentId: paymentId);
  }

  Future<void> _pollPaymentConfirmationWithLaunchTargets({
    required String paymentId,
    String? preferredLaunchUrl,
    String? secondaryLaunchUrl,
    String? hostedLaunchUrl,
    String? channel,
    bool pendingProviderConfirmation = false,
  }) async {
    if (!mounted) return;
    bool confirmed = false;
    final preferNonBrowser = true;

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return PaymentWaitingSheet(
          paymentId: paymentId,
          onConfirmed: () {
            confirmed = true;
            Navigator.of(sheetContext).pop();
          },
          onFailed: (msg) {
            Navigator.of(sheetContext).pop();
            if (mounted) {
              AppSnackbar.error(context, msg);
            }
          },
          onCloseRequested: () {
            Navigator.of(sheetContext).pop();
            _handleWaitingSheetClose(paymentId);
          },
          onReopenPreferred: preferredLaunchUrl == null
              ? null
              : () async {
                  final launched = await _launchExternalPaymentCandidates([
                    preferredLaunchUrl,
                  ], preferNonBrowser: preferNonBrowser);
                  if (!launched && mounted) {
                    AppSnackbar.error(
                      context,
                      'Impossible de rouvrir ${paydunyaLaunchLabel(preferredLaunchUrl, channel: channel)}.',
                    );
                  }
                },
          preferredLaunchLabel: preferredLaunchUrl == null
              ? null
              : paydunyaLaunchLabel(preferredLaunchUrl, channel: channel),
          onReopenSecondary: secondaryLaunchUrl == null
              ? null
              : () async {
                  final launched = await _launchExternalPaymentCandidates([
                    secondaryLaunchUrl,
                  ], preferNonBrowser: preferNonBrowser);
                  if (!launched && mounted) {
                    AppSnackbar.error(
                      context,
                      'Impossible d\'ouvrir ${paydunyaLaunchLabel(secondaryLaunchUrl, channel: channel)}.',
                    );
                  }
                },
          secondaryLaunchLabel: secondaryLaunchUrl == null
              ? null
              : paydunyaLaunchLabel(secondaryLaunchUrl, channel: channel),
          onOpenHosted: hostedLaunchUrl == null
              ? null
              : () async {
                  final launched = await _launchExternalPaymentCandidates([
                    hostedLaunchUrl,
                  ]);
                  if (!launched && mounted) {
                    AppSnackbar.error(
                      context,
                      'Impossible d\'ouvrir ${paydunyaLaunchLabel(hostedLaunchUrl, channel: channel)}.',
                    );
                  }
                },
          hostedLaunchLabel: hostedLaunchUrl == null
              ? null
              : paydunyaLaunchLabel(hostedLaunchUrl, channel: channel),
          reconcile: (id) =>
              ref.read(paymentInitiateProvider.notifier).reconcile(id),
          pendingProviderConfirmation: pendingProviderConfirmation,
        );
      },
    );

    if (confirmed && mounted) {
      context.pushReplacement(AppRoutes.success(widget.bookingId));
    }
  }

  // ── Background Polling (post-sheet dismiss) ─────────────────────────

  Future<void> _handleWaitingSheetClose(String paymentId) async {
    final didPay = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          AppStrings.paymentCloseConfirmTitle,
          style: AppTextStyles.headlineSm,
        ),
        content: Text(
          AppStrings.paymentCloseConfirmBody,
          style: AppTextStyles.bodyMd,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              AppStrings.paymentCloseConfirmNo,
              style: AppTextStyles.labelLg.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              AppStrings.paymentCloseConfirmYes,
              style: AppTextStyles.labelLg,
            ),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (didPay == true) {
      _startBackgroundPolling(paymentId);
    } else {
      if (context.canPop()) {
        context.pop();
      }
    }
  }

  void _startBackgroundPolling(String paymentId) {
    _backgroundPollPaymentId = paymentId;
    _backgroundPollAttempts = 0;
    _backgroundPollExhausted = false;
    setState(() => _backgroundPollActive = true);

    AppSnackbar.info(
      context,
      AppStrings.paymentBackgroundSubtitle,
    );

    _scheduleNextBackgroundPoll();
  }

  void _scheduleNextBackgroundPoll() {
    _backgroundPollTimer?.cancel();
    _backgroundPollTimer = Timer(_backgroundPollInterval, () {
      _runBackgroundPollCheck();
    });
  }

  Future<void> _runBackgroundPollCheck() async {
    final paymentId = _backgroundPollPaymentId;
    if (paymentId == null || !mounted) return;

    _backgroundPollAttempts++;
    try {
      final status = await ref
          .read(paymentInitiateProvider.notifier)
          .reconcile(paymentId);

      if (!mounted) return;

      if (status == 'succeeded') {
        _onBackgroundPollSuccess();
        return;
      }

      if (status == 'failed' || status == 'refunded') {
        if (_backgroundPollAttempts >= _maxBackgroundPollAttempts) {
          _onBackgroundPollExhausted();
          return;
        }
        _scheduleNextBackgroundPoll();
        return;
      }

      if (_backgroundPollAttempts >= _maxBackgroundPollAttempts) {
        _onBackgroundPollExhausted();
        return;
      }

      _scheduleNextBackgroundPoll();
    } catch (_) {
      if (!mounted) return;
      if (_backgroundPollAttempts >= _maxBackgroundPollAttempts) {
        _onBackgroundPollExhausted();
      } else {
        _scheduleNextBackgroundPoll();
      }
    }
  }

  void _onBackgroundPollSuccess() {
    _cancelBackgroundPolling();
    if (mounted) {
      // Show local notification (payment confirmed while in background)
      _showPaymentConfirmedNotification();
      // Navigate immediately
      context.pushReplacement(AppRoutes.success(widget.bookingId));
    }
  }

  void _onBackgroundPollExhausted() {
    _cancelBackgroundPolling();
    if (!mounted) return;
    setState(() => _backgroundPollExhausted = true);

    // Show notification that payment could not be confirmed
    _showPaymentFailedNotification();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.paymentCheckFailedTitle),
          duration: const Duration(seconds: 6),
          action: SnackBarAction(
            label: AppStrings.retry,
            onPressed: () =>
                _startBackgroundPolling(_backgroundPollPaymentId!),
          ),
        ),
      );
    }
  }

  void _cancelBackgroundPolling() {
    _backgroundPollTimer?.cancel();
    _backgroundPollTimer = null;
    if (mounted) {
      setState(() {
        _backgroundPollActive = false;
      });
    }
  }

  void _showPaymentConfirmedNotification() {
    final plugin = ForegroundNotificationService.plugin;
    plugin.show(
      id: 0,
      title: AppStrings.paymentConfirmedNotifTitle,
      body: AppStrings.paymentConfirmedNotifBody,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'Beauté Avenue',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
      ),
      payload: 'type=payment_confirmed&bookingId=${widget.bookingId}',
    );
  }

  void _showPaymentFailedNotification() {
    final bookingId = widget.bookingId;
    final plugin = ForegroundNotificationService.plugin;
    plugin.show(
      id: 1,
      title: AppStrings.paymentCheckFailedTitle,
      body: AppStrings.paymentCheckFailedSubtitle,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'Beauté Avenue',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
      ),
      payload: 'type=payment_failed&bookingId=$bookingId',
    );
  }

  // ── OTP Dialog ──────────────────────────────────────────────────────────

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
              Center(
                child: Pinput(
                  length: 6,
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  defaultPinTheme: PinTheme(
                    width: 44.w,
                    height: 52.h,
                    textStyle: AppTextStyles.headlineLg.copyWith(
                      color: AppColors.onSurface,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.outline.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 44.w,
                    height: 52.h,
                    textStyle: AppTextStyles.headlineLg.copyWith(
                      color: AppColors.onSurface,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                  onCompleted: (code) {
                    if (code.trim().isNotEmpty) {
                      Navigator.pop(context, code.trim());
                    }
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Annuler',
                style: AppTextStyles.labelLg.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
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

  // ── Main Pay Method ────────────────────────────────────────────────────

  Future<void> _pay() async {
    if (_selectedMethod == null) return;

    if (_selectedMethod == 'carte_bancaire') {
      if (!_pciDssAccepted) {
        AppSnackbar.error(
          context,
          'Vous devez accepter les conditions PCI-DSS.',
        );
        return;
      }
      if (_nameController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty ||
          _cardNumberController.text.trim().isEmpty ||
          _cardCvvController.text.trim().isEmpty ||
          _cardExpiryMonthController.text.trim().isEmpty ||
          _cardExpiryYearController.text.trim().isEmpty) {
        AppSnackbar.error(
          context,
          'Veuillez remplir tous les champs de la carte.',
        );
        return;
      }
    } else if (_selectedMethod == 'paydunya_wallet') {
      if (_phoneController.text.trim().isEmpty ||
          _walletPasswordController.text.trim().isEmpty) {
        AppSnackbar.error(
          context,
          'Veuillez remplir vos identifiants PayDunya.',
        );
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
        AppSnackbar.error(
          context,
          'Veuillez saisir votre numéro de téléphone.',
        );
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

      final existingStatus = paymentResult?['status'] as String?;
      if (existingStatus == 'authorized' || existingStatus == 'succeeded') {
        final reconciled = await ref
            .read(paymentInitiateProvider.notifier)
            .reconcile(paymentId);
        if (!context.mounted) return;
        if (reconciled == 'succeeded') {
          Navigator.of(context).pop(true);
          return;
        }
        if (mounted) {
          await _pollPaymentConfirmationWithLaunchTargets(paymentId: paymentId);
        }
        return;
      }

      final Map<String, dynamic> details = {};
      if (_selectedMethod == 'carte_bancaire') {
        details['fullName'] = _nameController.text.trim();
        details['email'] = _emailController.text.trim();
        details['cardNumber'] = _cardNumberController.text.replaceAll(' ', '');
        details['cardCvv'] = _cardCvvController.text.trim();
        details['cardExpiredDateMonth'] = _cardExpiryMonthController.text
            .trim();
        details['cardExpiredDateYear'] = _cardExpiryYearController.text.trim();
      } else if (_selectedMethod == 'paydunya_wallet') {
        details['phone'] = _phoneController.text.trim();
        details['password'] = _walletPasswordController.text.trim();
      } else {
        final profileSnap = ref.read(profileProvider).asData?.value;
        final methodsSnap = ref.read(paymentMethodsProvider).asData?.value;
        final storedDefault = methodsSnap
            ?.where((m) => m.isDefault)
            .firstOrNull;
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
          .execute(
            paymentId: paymentId,
            method: _selectedMethod!,
            details: details,
          );
      if (!context.mounted) return;

      if (executeResult?['success'] == true) {
        final url = executeResult?['url'] as String?;
        final omUrl =
            executeResult?['other_url']?['om_url'] as String? ??
            executeResult?['data']?['om_url'] as String?;
        final maxitUrl =
            executeResult?['other_url']?['maxit_url'] as String? ??
            executeResult?['data']?['maxit_url'] as String?;
        if (omUrl != null || maxitUrl != null) {
          final launched = await _launchExternalPaymentCandidates(
            paydunyaLaunchCandidates(
              omUrl: omUrl,
              maxitUrl: maxitUrl,
              hostedUrl: url,
              channel: _selectedMethod,
            ),
            preferNonBrowser: true,
          );
          if (!launched && url != null) {
            final fallbackUri = Uri.tryParse(url);
            if (fallbackUri != null) {
              await _launchExternalPaymentUri(fallbackUri);
            }
          }
          if (mounted) {
            await _pollPaymentConfirmationWithLaunchTargets(
              paymentId: paymentId,
              preferredLaunchUrl: launched ? null : omUrl ?? maxitUrl,
              secondaryLaunchUrl: launched
                  ? null
                  : (omUrl != null && maxitUrl != null && omUrl != maxitUrl
                        ? maxitUrl
                        : null),
              hostedLaunchUrl: launched || _selectedMethod == 'orange_senegal'
                  ? null
                  : url,
              channel: _selectedMethod,
              pendingProviderConfirmation:
                  executeResult?['pendingProviderConfirmation'] == true,
            );
          }
          return;
        }

        final cid =
            executeResult?['data']?['details']?['cid'] as String? ??
            executeResult?['data']?['cid'] as String?;
        if (cid != null && cid.isNotEmpty) {
          final otp = await _showOtpDialog('Wizall Sénégal');
          if (otp != null && otp.isNotEmpty) {
            setState(() => _isProcessing = true);
            final confirmResult = await ref
                .read(paymentInitiateProvider.notifier)
                .execute(
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
              await _pollPaymentConfirmationWithLaunchTargets(
                paymentId: paymentId,
                preferredLaunchUrl: confirmResult?['return_url'] as String?,
                hostedLaunchUrl: confirmResult?['return_url'] as String?,
              );
            } else {
              final msg =
                  confirmResult?['message'] as String? ??
                  'Échec de la validation Wizall.';
              if (mounted) {
                AppSnackbar.error(context, msg);
              }
            }
          }
          return;
        }

        if (url != null && url.isNotEmpty) {
          final uri = Uri.parse(url);
          final launched = await _launchExternalPaymentUri(uri);
          if (mounted) {
            await _pollPaymentConfirmationWithLaunchTargets(
              paymentId: paymentId,
              preferredLaunchUrl: launched ? null : url,
              channel: _selectedMethod,
            );
          }
          return;
        }

        if (mounted) {
          await _pollPaymentConfirmation(paymentId);
        }
      } else {
        final msg =
            executeResult?['message'] as String? ?? 'Échec du paiement.';
        if (mounted) {
          AppSnackbar.error(context, msg);
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      await _handlePaymentError(e);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // ── Error Handling ────────────────────────────────────────────────────

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
          if (mounted) {
            context.push(AppRoutes.profileEdit);
          }
          return;
        case 'reconcile_throttled':
          AppSnackbar.info(
            context,
            retryAfter ??
                'Réconciliation trop fréquente. Réessayez dans quelques secondes.',
          );
          return;
        case 'invalid_status':
          AppSnackbar.error(
            context,
            'Cette tentative de paiement n\'est plus valide. Relancez le paiement.',
          );
          return;
        case 'missing_invoice_token':
          AppSnackbar.error(
            context,
            'Le paiement n\'a pas pu être préparé correctement. Réessayez.',
          );
          return;
        case 'payment_not_found':
          AppSnackbar.error(
            context,
            'Paiement introuvable. Recommencez la réservation ou relancez le paiement.',
          );
          return;
      }
    }
    if (mounted) {
      context.handleHttpError(error, 'Échec du paiement.');
    }
  }

  String? _channelFromMethod(dynamic method) {
    if (method == null) return null;
    final provider = method.provider as String? ?? '';
    if (provider != 'paydunya') return null;
    final savedMethod = (method.method as String?)?.trim();
    if (savedMethod != null && savedMethod.isNotEmpty) return savedMethod;
    final label = (method.label as String? ?? '');
    final code = channelFromMethodLabel(label);
    return code.isEmpty ? null : code;
  }

  String _inferDjamoCountryCode(String phone) => inferDjamoCountryCode(phone);

  String _inferDjamoCountryCodeFromMethod(dynamic method) {
    final savedCountry = (method?.country as String?)?.trim().toUpperCase();
    if (savedCountry == 'CI' || savedCountry == 'SN') return savedCountry!;
    final phone = method?.phoneNumber as String? ?? '';
    return _inferDjamoCountryCode(phone);
  }
}

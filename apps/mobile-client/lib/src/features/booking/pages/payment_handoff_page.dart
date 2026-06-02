import 'dart:async';
import 'dart:convert';
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
  String? _selectedMethod;
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
  bool _hasInitializedProfileData = false;

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
    if (profile != null && !_hasInitializedProfileData) {
      _hasInitializedProfileData = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            if (profile.phone != null) _phoneController.text = profile.phone!;
            _nameController.text = profile.fullName;
            if (profile.email != null) _emailController.text = profile.email!;
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
                  Text('Moyen de paiement', style: AppTextStyles.headlineSm),
                  if (defaultMethod != null) ...[
                    SizedBox(height: 6.h),
                    Text(
                      'Numéro enregistré: ${defaultMethod.phoneNumber}',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
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
                                  if (isSelected) _buildFormForMethod(method.code),
                                ],
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }

  Widget _buildFormForMethod(String methodCode) {
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

  Future<bool> _showThreeDsConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Authentification 3D Secure',
            style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Une page d\'authentification s\'est ouverte dans votre navigateur. Veuillez valider la transaction auprès de votre banque, puis revenez ici pour finaliser.',
                style: AppTextStyles.bodySm,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Annuler',
                style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text('J\'ai finalisé mon paiement', style: AppTextStyles.labelLg),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Future<bool> _showMoovCiCountdownDialog() async {
    int timeLeft = 30;
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final timer = Stream.periodic(const Duration(seconds: 1), (i) => i);
            final subscription = timer.listen((_) {
              if (timeLeft > 0) {
                if (context.mounted) {
                  setStateDialog(() {
                    timeLeft--;
                  });
                }
              } else {
                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              }
            });

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Text(
                'Validation Moov Money',
                style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Veuillez valider la transaction sur votre téléphone en saisissant votre code secret Moov.',
                    style: AppTextStyles.bodySm,
                    textAlign: TextAlign.center,
                  ),
                  gapH16,
                  Text(
                    '$timeLeft s',
                    style: AppTextStyles.headlineLg.copyWith(
                      color: AppColors.primary,
                      fontSize: 36.sp,
                    ),
                  ),
                  gapH8,
                  const CircularProgressIndicator.adaptive(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    subscription.cancel();
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'Annuler',
                    style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    subscription.cancel();
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text('Vérifier', style: AppTextStyles.labelLg),
                ),
              ],
            );
          },
        );
      },
    ) ?? false;
  }

  Future<void> _showQrCodeDialog(String qrCodeBase64) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Scannez le QR Code',
            style: AppTextStyles.headlineSm.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ouvrez votre application de paiement et scannez ce QR code pour finaliser la transaction.',
                style: AppTextStyles.bodySm,
                textAlign: TextAlign.center,
              ),
              gapH16,
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Image.memory(
                  base64Decode(qrCodeBase64),
                  width: 200.r,
                  height: 200.r,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text('J\'ai payé', style: AppTextStyles.labelLg),
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
      if (_phoneController.text.trim().isEmpty) {
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
        details['phone'] = _phoneController.text.trim();
        details['fullName'] = _nameController.text.trim();
        details['email'] = _emailController.text.trim();
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

        if (url != null && (url.contains('data[qrcode]') || url.contains('data%5Bqrcode%5D'))) {
          final uri = Uri.parse(url);
          final qrCodeBase64 = uri.queryParameters['data[qrcode]'] ?? uri.queryParameters['data%5Bqrcode%5D'];
          if (qrCodeBase64 != null) {
            await _showQrCodeDialog(qrCodeBase64);
            await ref.read(paymentInitiateProvider.notifier).reconcile(paymentId);
            if (mounted) context.pushReplacement(AppRoutes.success(widget.bookingId));
            return;
          }
        }

        final omUrl = executeResult?['other_url']?['om_url'] ?? executeResult?['data']?['om_url'] as String?;
        final maxitUrl = executeResult?['other_url']?['maxit_url'] ?? executeResult?['data']?['maxit_url'] as String?;
        final deepLink = omUrl ?? maxitUrl;
        if (deepLink != null) {
          final uri = Uri.parse(deepLink);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
          final confirmed = await _showThreeDsConfirmationDialog();
          if (confirmed) {
            await ref.read(paymentInitiateProvider.notifier).reconcile(paymentId);
          }
          if (mounted) context.pushReplacement(AppRoutes.success(widget.bookingId));
          return;
        }

        final cid = executeResult?['data']?['details']?['cid'] ?? executeResult?['data']?['cid'] as String?;
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
              await ref.read(paymentInitiateProvider.notifier).reconcile(paymentId);
              if (mounted) context.pushReplacement(AppRoutes.success(widget.bookingId));
            } else {
              final msg = confirmResult?['message'] as String? ?? 'Échec de la validation Wizall.';
              if (mounted) AppSnackbar.error(context, msg);
            }
          }
          return;
        }

        if (_selectedMethod == 'moov_ci' || _selectedMethod == 'paydunya_moov_ci') {
          final confirmed = await _showMoovCiCountdownDialog();
          if (confirmed) {
            await ref.read(paymentInitiateProvider.notifier).reconcile(paymentId);
          }
          if (mounted) context.pushReplacement(AppRoutes.success(widget.bookingId));
          return;
        }

        if (url != null && url.isNotEmpty) {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
          final confirmed = await _showThreeDsConfirmationDialog();
          if (confirmed) {
            await ref.read(paymentInitiateProvider.notifier).reconcile(paymentId);
          }
          if (mounted) context.pushReplacement(AppRoutes.success(widget.bookingId));
          return;
        }

        await ref.read(paymentInitiateProvider.notifier).reconcile(paymentId);
        if (mounted) context.pushReplacement(AppRoutes.success(widget.bookingId));
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
    final label = (method.label as String? ?? '').toLowerCase();
    if (label.contains('orange')) return 'orange_senegal';
    if (label.contains('free')) return 'free_senegal';
    if (label.contains('wizall')) return 'wizall_senegal';
    if (label.contains('expresso')) return 'expresso_sn';
    if (label.contains('wave')) return 'wave_senegal';
    return 'wave_senegal';
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

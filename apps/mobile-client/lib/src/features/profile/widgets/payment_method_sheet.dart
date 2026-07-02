import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/app_phone_field.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/providers/supported_countries_provider.dart';
import '../../booking/providers/payment_methods_provider.dart'
    as booking_payment_methods;
import '../providers/payment_methods_provider.dart';
import '../models/account_models.dart';

/// Result returned when the sheet is dismissed after a successful save.
class PaymentMethodSheetResult {
  const PaymentMethodSheetResult({
    required this.channelCode,
    this.phoneCleared = false,
  });

  final String channelCode;
  final bool phoneCleared;
}

/// Shows a modal bottom sheet for adding or editing a payment method.
///
/// Returns a [PaymentMethodSheetResult] on success, or `null` if cancelled.
Future<PaymentMethodSheetResult?> showPaymentMethodSheet({
  required BuildContext context,
  required WidgetRef ref,
  required bool isEdit,
  required List<booking_payment_methods.PaydunyaMethodRecord> channelItems,
  String initialChannel = '',
  String initialPhone = '',
  String initialLabel = '',
  PaymentMethodRecord? existingMethod,
}) {
  return showModalBottomSheet<PaymentMethodSheetResult>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: AppColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (sheetContext) {
      return _PaymentMethodSheetContent(
        isEdit: isEdit,
        channelItems: channelItems,
        initialChannel: initialChannel,
        initialPhone: initialPhone,
        initialLabel: initialLabel,
        existingMethod: existingMethod,
        ref: ref,
        sheetContext: sheetContext,
      );
    },
  );
}

class _PaymentMethodSheetContent extends ConsumerStatefulWidget {
  const _PaymentMethodSheetContent({
    required this.isEdit,
    required this.channelItems,
    required this.initialChannel,
    required this.initialPhone,
    required this.initialLabel,
    this.existingMethod,
    required this.ref,
    required this.sheetContext,
  });

  final bool isEdit;
  final List<booking_payment_methods.PaydunyaMethodRecord> channelItems;
  final String initialChannel;
  final String initialPhone;
  final String initialLabel;
  final PaymentMethodRecord? existingMethod;
  final WidgetRef ref;
  final BuildContext sheetContext;

  @override
  ConsumerState<_PaymentMethodSheetContent> createState() =>
      _PaymentMethodSheetContentState();
}

class _PaymentMethodSheetContentState
    extends ConsumerState<_PaymentMethodSheetContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  late final TextEditingController _labelController;
  late String _selectedChannel;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhone);
    _labelController = TextEditingController(text: widget.initialLabel);

    // Determine initial channel
    if (widget.initialChannel.isNotEmpty &&
        widget.channelItems.any((item) => item.code == widget.initialChannel)) {
      _selectedChannel = widget.initialChannel;
    } else if (widget.existingMethod != null) {
      _selectedChannel = _resolveExistingChannel();
    } else {
      _selectedChannel = widget.channelItems.first.code;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  String _resolveExistingChannel() {
    final method = widget.existingMethod;
    if (method == null) return widget.channelItems.first.code;

    final savedMethod = method.method?.trim();
    if (savedMethod != null &&
        savedMethod.isNotEmpty &&
        widget.channelItems.any((item) => item.code == savedMethod)) {
      return savedMethod;
    }
    final normalizedLabel = (method.label ?? '').toLowerCase();
    final matched = widget.channelItems.where((item) {
      final label = item.label.toLowerCase();
      return label == normalizedLabel ||
          normalizedLabel.contains(label) ||
          label.contains(normalizedLabel);
    }).firstOrNull;
    return matched?.code ?? widget.channelItems.first.code;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      if (widget.isEdit && widget.existingMethod != null) {
        // Update existing method
        await widget.ref
            .read(paymentMethodsProvider.notifier)
            .updateMethod(
              widget.existingMethod!.id,
              phoneNumber: _phoneController.text.trim(),
              label: _labelController.text.trim().isEmpty
                  ? null
                  : _labelController.text.trim(),
              method: _selectedChannel,
              country: _resolveChannelCountry(),
            );
      } else {
        // Add new method
        await widget.ref
            .read(paymentMethodsProvider.notifier)
            .add(
              provider: 'paydunya',
              phoneNumber: _phoneController.text.trim(),
              label: _resolveChannelLabel(),
              method: _selectedChannel,
              country: _resolveChannelCountry(),
            );
      }

      if (!mounted) return;

      if (widget.sheetContext.mounted) {
        Navigator.of(widget.sheetContext).pop(
          PaymentMethodSheetResult(
            channelCode: _selectedChannel,
            phoneCleared: !widget.isEdit,
          ),
        );
      }
    } catch (_) {
      setState(() => _saving = false);
      if (context.mounted) {
        AppSnackbar.error(
          context,
          widget.isEdit
              ? 'Mise à jour impossible pour le moment.'
              : 'Ajout impossible pour le moment.',
        );
      }
    }
  }

  String _resolveChannelLabel() {
    final matched = widget.channelItems.firstWhere(
      (item) => item.code == _selectedChannel,
      orElse: () => booking_payment_methods.PaydunyaMethodRecord(
        code: _selectedChannel,
        country: '',
        label: _selectedChannel,
        enabled: true,
      ),
    );
    return _displayChannelLabel(matched);
  }

  String _displayChannelLabel(
    booking_payment_methods.PaydunyaMethodRecord item,
  ) {
    return item.label.toLowerCase().contains('paydunya')
        ? 'Portefeuille mobile'
        : item.label;
  }

  String? _resolveChannelCountry() {
    final matched = widget.channelItems.firstWhere(
      (item) => item.code == _selectedChannel,
      orElse: () => booking_payment_methods.PaydunyaMethodRecord(
        code: _selectedChannel,
        country: '',
        label: _selectedChannel,
        enabled: true,
      ),
    );
    final country = matched.country.trim().toLowerCase();
    return country.isEmpty ? null : country;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20.w,
          24.h,
          20.w,
          MediaQuery.viewInsetsOf(context).bottom + 32.h,
        ),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEdit
                    ? AppStrings.editPaymentMethod
                    : AppStrings.addPhoneNumber,
                style: AppTextStyles.labelLg,
              ),
              if (!widget.isEdit) ...[
                SizedBox(height: 8.h),
                Text(
                  'Ajoutez jusqu\'à 2 numéros pour payer plus vite.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
              SizedBox(height: 20.h),
              AppDropdown<String>(
                label: widget.isEdit ? 'Opérateur' : AppStrings.operatorLabel,
                value: _selectedChannel,
                items: widget.channelItems.map((item) => item.code).toList(),
                itemLabel: (value) => _displayChannelLabel(
                  widget.channelItems.firstWhere((item) => item.code == value),
                ),
                onChanged: widget.isEdit
                    ? (val) {
                        setState(() {
                          final prevChannel = _selectedChannel;
                          _selectedChannel = val;

                          final prevMethod = widget.channelItems
                              .where((item) => item.code == prevChannel)
                              .firstOrNull;
                          final newMethod = widget.channelItems
                              .where((item) => item.code == val)
                              .firstOrNull;

                          final currentLabel = _labelController.text.trim();
                          if (prevMethod != null && newMethod != null) {
                            if (currentLabel.isEmpty ||
                                currentLabel == _displayChannelLabel(prevMethod)) {
                              _labelController.text = _displayChannelLabel(newMethod);
                            }
                          }
                        });
                      }
                    : (val) => setState(() => _selectedChannel = val),
              ),
              gapH16,
              _buildPhoneField(),
              if (widget.isEdit) ...[
                gapH16,
                TextField(
                  controller: _labelController,
                  decoration: InputDecoration(
                    labelText: AppStrings.labelOptional,
                    hintText: AppStrings.labelHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md.r),
                    ),
                  ),
                  maxLength: 60,
                ),
                SizedBox(height: 8.h),
              ],
              SizedBox(height: 24.h),
              AppButton.primary(
                label: widget.isEdit ? AppStrings.save : AppStrings.add,
                onPressed: _saving ? null : _save,
                isLoading: _saving,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    final countriesAsync = ref.watch(supportedCountriesProvider);
    final countries = countriesAsync.asData?.value ?? kPhoneCountries;
    final countryStr = _resolveChannelCountry();

    final selectedCountry = countries.firstWhere(
      (c) => countryStr?.toUpperCase() == c.code,
      orElse: () => countries[0],
    );

    return Semantics(
      label: 'Numéro de téléphone pour le moyen de paiement',
      child: AppPhoneField(
        key: ValueKey(_selectedChannel),
        controller: _phoneController,
        labelText: 'Numéro de téléphone',
        initialCountry: selectedCountry,
        countries: countries,
        onCountryChanged: (_) {},
      ),
    );
  }
}

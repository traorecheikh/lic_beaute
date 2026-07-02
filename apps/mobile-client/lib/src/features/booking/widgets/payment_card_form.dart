import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import 'payment_form_fields.dart';

/// Card payment form extracted from PaymentHandoffPage.
class PaymentCardForm extends StatelessWidget {
  const PaymentCardForm({
    required this.nameController,
    required this.emailController,
    required this.cardNumberController,
    required this.cardCvvController,
    required this.cardExpiryMonthController,
    required this.cardExpiryYearController,
    required this.pciDssAccepted,
    required this.onPciDssChanged,
    required this.onFormatCardNumber,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController cardNumberController;
  final TextEditingController cardCvvController;
  final TextEditingController cardExpiryMonthController;
  final TextEditingController cardExpiryYearController;
  final bool pciDssAccepted;
  final ValueChanged<bool?> onPciDssChanged;
  final void Function(String) onFormatCardNumber;

  @override
  Widget build(BuildContext context) {
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
          _securityNotice(),
          Text('Informations de la carte', style: AppTextStyles.labelLg),
          gapH12,
          buildPaymentTextField(
            controller: nameController,
            label: 'Nom sur la carte',
            hint: 'John Doe',
          ),
          gapH12,
          buildPaymentTextField(
            controller: emailController,
            label: 'Email',
            hint: 'john.doe@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          gapH12,
          buildPaymentTextField(
            controller: cardNumberController,
            label: 'Numéro de carte',
            hint: '4111 1111 1111 1111',
            keyboardType: TextInputType.number,
            onChanged: onFormatCardNumber,
          ),
          gapH12,
          _expiryRow(),
          gapH12,
          _pciCheckbox(),
        ],
      ),
    );
  }

  Widget _securityNotice() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.successContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon('shield-check', color: AppColors.success, size: 20),
          gapW8,
          Expanded(
            child: Text(
              'Les données de votre carte sont chiffrées pendant la transmission et ne sont pas stockées par Beauté Avenue.',
              style: AppTextStyles.bodyXs.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _expiryRow() {
    return Row(
      children: [
        Expanded(
          child: buildPaymentTextField(
            controller: cardExpiryMonthController,
            label: 'Mois exp. (MM)',
            hint: '12',
            keyboardType: TextInputType.number,
            maxLength: 2,
          ),
        ),
        gapW12,
        Expanded(
          child: buildPaymentTextField(
            controller: cardExpiryYearController,
            label: 'Année exp. (YY)',
            hint: '28',
            keyboardType: TextInputType.number,
            maxLength: 2,
          ),
        ),
        gapW12,
        Expanded(
          child: buildPaymentTextField(
            controller: cardCvvController,
            label: 'CVC / CVV',
            hint: '123',
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
          ),
        ),
      ],
    );
  }

  Widget _pciCheckbox() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.successContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: pciDssAccepted,
            onChanged: onPciDssChanged,
            activeColor: AppColors.primary,
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                "J'accepte de transmettre mes informations bancaires de manière sécurisée. Elles ne sont pas stockées par Beauté Avenue.",
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

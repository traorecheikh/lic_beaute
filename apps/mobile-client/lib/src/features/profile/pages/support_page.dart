import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_haptics.dart';
import '../../../core/widgets/app_snackbar.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  Future<void> _launch(BuildContext context, String url) async {
    AppHaptics.light();
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        AppSnackbar.error(context, "Impossible d'ouvrir l'application.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Support & Assistance', style: AppTextStyles.headlineSm),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 60.h),
        children: [
          Text(
            'Contactez-nous',
            style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
          ),
          SizedBox(height: 12.h),
          _SupportTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Chat en direct',
            subtitle: 'Réponse en moins de 5 minutes',
            onTap: () {
              AppHaptics.light();
              AppSnackbar.info(context, 'Chat bientôt disponible !');
            },
          ),
          SizedBox(height: 10.h),
          _SupportTile(
            icon: Icons.email_outlined,
            title: 'Envoyer un email',
            subtitle: 'support@beauteavenue.sn',
            onTap: () => _launch(context, 'mailto:support@beauteavenue.sn'),
          ),
          SizedBox(height: 10.h),
          _SupportTile(
            icon: Icons.phone_outlined,
            title: 'Nous appeler',
            subtitle: '+221 77 000 00 00',
            onTap: () => _launch(context, 'tel:+221770000000'),
          ),
          SizedBox(height: 32.h),
          Text(
            'Questions fréquentes',
            style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
          ),
          SizedBox(height: 12.h),
          _FaqTile(
            q: "Comment annuler un rendez-vous ?",
            a: "Rendez-vous dans \"Mes Rendez-vous\", ouvrez le détail de votre RDV et appuyez sur \"Annuler le rendez-vous\". L'annulation est gratuite jusqu'à 24h avant.",
          ),
          _FaqTile(
            q: "Quels sont les modes de paiement ?",
            a: "Nous acceptons Wave et Orange Money. Le paiement s'effectue en deux fois : acompte (20%) à la réservation, solde directement au salon.",
          ),
          _FaqTile(
            q: "Comment modifier mon profil ?",
            a: "Rendez-vous dans l'onglet Profil, puis appuyez sur l'icône stylo à côté de votre nom.",
          ),
        ],
      ),
    );
  }
}

class _SupportTile extends StatelessWidget {
  const _SupportTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22.r),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelLg),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14.r, color: AppColors.outline),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.q, required this.a});
  final String q;
  final String a;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHaptics.select();
        setState(() => _expanded = !_expanded);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _expanded ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.q,
                    style: AppTextStyles.labelLg.copyWith(
                      color: _expanded ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20.r,
                    color: _expanded ? AppColors.primary : AppColors.outline,
                  ),
                ),
              ],
            ),
            if (_expanded) ...[
              SizedBox(height: 10.h),
              Text(
                widget.a,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

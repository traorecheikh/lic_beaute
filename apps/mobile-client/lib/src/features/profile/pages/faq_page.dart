import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  static const _faqs = [
    _FaqItem(
      q: "Comment réserver un rendez-vous ?",
      a: "Recherchez un salon sur la page d'accueil, choisissez vos prestations, sélectionnez un créneau disponible et payez l'acompte via Wave ou Orange Money. C'est tout !",
    ),
    _FaqItem(
      q: "Comment payer ?",
      a: "Nous acceptons Wave et Orange Money. Le paiement se fait en deux étapes : un acompte de 20% lors de la réservation, et le solde directement en salon.",
    ),
    _FaqItem(
      q: "Puis-je annuler ma réservation ?",
      a: "Oui, l'annulation est gratuite jusqu'à 24 heures avant le rendez-vous. En cas d'annulation tardive, l'acompte n'est pas remboursable.",
    ),
    _FaqItem(
      q: "Comment contacter un salon ?",
      a: "Depuis la fiche du salon, vous pouvez voir les coordonnées et accéder à la carte pour vous rendre sur place.",
    ),
    _FaqItem(
      q: "Puis-je utiliser l'application sans compte ?",
      a: "Oui ! Vous pouvez parcourir les salons et les prestations sans créer de compte. Un compte est nécessaire uniquement pour réserver.",
    ),
    _FaqItem(
      q: "Comment laisser un avis ?",
      a: "Après votre rendez-vous, rendez-vous dans \"Mes Rendez-vous\" et appuyez sur \"Laisser un avis\" sur le rendez-vous concerné.",
    ),
    _FaqItem(
      q: "L'application est-elle disponible partout au Sénégal ?",
      a: "Nous sommes actuellement disponibles à Dakar et dans ses environs. D'autres villes seront ajoutées prochainement.",
    ),
    _FaqItem(
      q: "Comment signaler un problème ?",
      a: "Rendez-vous dans \"Support & Assistance\" depuis votre profil. Notre équipe vous répondra sous 24 heures.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('FAQ', style: AppTextStyles.headlineSm),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 60.h),
        itemCount: _faqs.length,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (_, i) => _FaqTile(item: _faqs[i]),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.item});
  final _FaqItem item;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
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
                    widget.item.q,
                    style: AppTextStyles.labelLg.copyWith(
                      color: _expanded ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22.r,
                    color: _expanded ? AppColors.primary : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (_expanded) ...[
              SizedBox(height: 12.h),
              Text(
                widget.item.a,
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

class _FaqItem {
  const _FaqItem({required this.q, required this.a});
  final String q;
  final String a;
}

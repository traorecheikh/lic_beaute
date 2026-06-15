import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:beauteavenue_mobile_client/src/core/theme/app_theme.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../widgets/faq_tile.dart';

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
      a: "Nous sommes actuellement disponibles à Dakar et dans ses environs. Consultez la carte des salons pour voir les zones couvertes.",
    ),
    _FaqItem(
      q: "Comment signaler un problème ?",
      a: "Rendez-vous dans \"Support & Assistance\" depuis votre profil. Notre équipe vous répondra sous 24 heures.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.neutral,
      appBar: const AppTopBar(title: 'FAQ', showBackButton: true),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 60.h),
        itemCount: _faqs.length,
        separatorBuilder: (_, _) => SizedBox(height: 10.h),
        itemBuilder: (_, i) =>
            FaqTile(question: _faqs[i].q, answer: _faqs[i].a),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({required this.q, required this.a});
  final String q;
  final String a;
}

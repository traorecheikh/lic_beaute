<script setup lang="ts">
import { DocumentTextIcon } from '@heroicons/vue/24/outline';
import { legalConfig } from '@beauteavenue/shared-ts';
import LegalLayout from '@/layouts/LegalLayout.vue';

const hasValue = (val?: string) => {
  return val && val.trim() !== '' && !val.includes('[') && !val.includes(']');
};
</script>

<template>
  <LegalLayout
    page-title="Conditions Générales d'Utilisation"
    page-subtitle="Contrat d'accès et de réservation sur la plateforme Beauté Avenue"
    badge-text="Réglementation des Transactions Électroniques"
  >
    <template #badge-icon>
      <DocumentTextIcon class="w-4 h-4" aria-hidden="true" />
    </template>

    <!-- Definitions -->
    <section class="space-y-4" aria-labelledby="sec-definitions">
      <h2 id="sec-definitions" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        Définitions importantes
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-[13px] text-cocoa/80">
        <div class="p-4 rounded-xl bg-sand/30 border border-outline-variant/40">
          <strong class="text-espresso block mb-1">Plateforme :</strong> Le site internet, l'application mobile et les outils techniques associés de {{ legalConfig.appName }}.
        </div>
        <div class="p-4 rounded-xl bg-sand/30 border border-outline-variant/40">
          <strong class="text-espresso block mb-1">Client :</strong> Toute personne physique majeure qui utilise la Plateforme pour réserver une prestation.
        </div>
        <div class="p-4 rounded-xl bg-sand/30 border border-outline-variant/40">
          <strong class="text-espresso block mb-1">Salon Partenaire :</strong> Le professionnel indépendant de la beauté référencé sur la Plateforme.
        </div>
        <div class="p-4 rounded-xl bg-sand/30 border border-outline-variant/40">
          <strong class="text-espresso block mb-1">Compte :</strong> L'espace numérique personnel créé par l'utilisateur (Client ou Professionnel).
        </div>
        <div class="p-4 rounded-xl bg-sand/30 border border-outline-variant/40">
          <strong class="text-espresso block mb-1">Réservation :</strong> La programmation d'une prestation de beauté auprès d'un Salon Partenaire.
        </div>
        <div class="p-4 rounded-xl bg-sand/30 border border-outline-variant/40">
          <strong class="text-espresso block mb-1">Acompte :</strong> La somme partielle perçue en ligne pour garantir la Réservation.
        </div>
        <div class="p-4 rounded-xl bg-sand/30 border border-outline-variant/40">
          <strong class="text-espresso block mb-1">Prestataire de paiement :</strong> L'agrégateur tiers agréé (PayDunya) qui traite les transactions de paiement.
        </div>
      </div>
    </section>

    <!-- Section 1 -->
    <section class="space-y-4" aria-labelledby="sec-operator">
      <h2 id="sec-operator" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">01.</span> Identification de l'opérateur
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        La plateforme {{ legalConfig.appName }} est conçue et exploitée par la société <strong>{{ legalConfig.operatorName }}</strong><span v-if="hasValue(legalConfig.formeJuridique)"> ({{ legalConfig.formeJuridique }})</span>.
      </p>

      <div v-if="hasValue(legalConfig.adresseSiege) || hasValue(legalConfig.numeroRccm) || hasValue(legalConfig.ninea) || hasValue(legalConfig.telephone) || hasValue(legalConfig.emailJuridique) || hasValue(legalConfig.referenceCdp)" class="p-5 rounded-2xl bg-sand/30 border border-outline-variant/60 space-y-2 text-[13px] text-cocoa/80">
        <p v-if="hasValue(legalConfig.adresseSiege)">
          <strong class="text-espresso">Adresse du siège :</strong> {{ legalConfig.adresseSiege }}
        </p>
        <p v-if="hasValue(legalConfig.numeroRccm)">
          <strong class="text-espresso">RCCM :</strong> {{ legalConfig.numeroRccm }}
        </p>
        <p v-if="hasValue(legalConfig.ninea)">
          <strong class="text-espresso">NINEA :</strong> {{ legalConfig.ninea }}
        </p>
        <p v-if="hasValue(legalConfig.telephone)">
          <strong class="text-espresso">Téléphone :</strong> {{ legalConfig.telephone }}
        </p>
        <p v-if="hasValue(legalConfig.emailJuridique)">
          <strong class="text-espresso">Contact e-mail :</strong> {{ legalConfig.emailJuridique }}
        </p>
        <p v-if="hasValue(legalConfig.referenceCdp)">
          <strong class="text-espresso">Référence CDP :</strong> {{ legalConfig.referenceCdp }}
        </p>
      </div>

      <p class="text-[14px] leading-relaxed text-cocoa/80">
        {{ legalConfig.appName }} est une plateforme exploitée par {{ legalConfig.operatorName }}. {{ legalConfig.operatorName }} accomplit les formalités requises auprès des autorités compétentes lorsque celles-ci sont applicables.
      </p>
    </section>

    <!-- Section 2 -->
    <section class="space-y-4" aria-labelledby="sec-acceptance">
      <h2 id="sec-acceptance" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">02.</span> Objet et acceptation des conditions
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Les présentes Conditions Générales d'Utilisation régissent l'accès et l'utilisation de l'ensemble des services de la Plateforme {{ legalConfig.appName }} : création de compte, recherche de professionnels de la beauté, planification de rendez-vous, paiement sécurisé de l'acompte, et communication d'assistance technique.
      </p>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        L'acceptation des CGU se matérialise de manière explicite lors de la création d'un compte utilisateur, lors de la soumission d'une Réservation, ou lors de la première utilisation de l'application mobile ou web suite à une notification de mise à jour des CGU. L'utilisateur qui rejette les présentes conditions doit s'abstenir de recourir aux services.
      </p>
    </section>

    <!-- Section 3 -->
    <section class="space-y-4" aria-labelledby="sec-service-desc">
      <h2 id="sec-service-desc" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">03.</span> Description du service et zone de couverture
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        {{ legalConfig.appName }} agit en qualité d'intermédiaire technologique de mise en relation. Nous permettons aux utilisateurs de trouver des salons indépendants partenaires et de réserver des rendez-vous.
      </p>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Le service n'est disponible que dans les localités géographiques couvertes par nos salons partenaires référencés, telles qu'indiquées sur la Plateforme (actuellement concentrées au {{ legalConfig.currentScope }}). Les Salons Partenaires sont des entités juridiquement distinctes et indépendantes de {{ legalConfig.operatorName }}.
      </p>
    </section>

    <!-- Section 4 -->
    <section class="space-y-4" aria-labelledby="sec-user-obligations">
      <h2 id="sec-user-obligations" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">04.</span> Comptes et obligations de l'utilisateur
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Pour réserver une prestation, le Client doit créer un compte en fournissant des informations personnelles sincères et complètes (nom, numéro de téléphone valide). L'accès au compte s'effectue via des identifiants et des codes d'authentification temporaires (OTP) envoyés par SMS.
      </p>
      <ul class="list-disc list-inside space-y-1 text-[13px] text-cocoa/80 pl-2">
        <li>Vous devez préserver la confidentialité de vos accès et nous signaler immédiatement tout accès suspect ou compromission de votre appareil.</li>
        <li>Toute usurpation d'identité, réservation fictive, tentative de fraude bancaire ou mobile money, harcèlement du personnel d'un salon, extraction automatisée de données (scraping) ou tentative d'atteinte technique à la Plateforme est strictement interdite.</li>
        <li>L'utilisation de la plateforme requiert la majorité civile (18 ans au Sénégal) ou l'autorisation d'un parent ou tuteur légal ayant la capacité juridique.</li>
      </ul>
      <p class="text-[13px] text-primary font-medium">
        {{ legalConfig.operatorName }} se réserve le droit de suspendre ou de supprimer immédiatement et unilatéralement tout compte violant ces règles.
      </p>
    </section>

    <!-- Section 5 -->
    <section class="space-y-4" aria-labelledby="sec-salon-obligations">
      <h2 id="sec-salon-obligations" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">05.</span> Obligations des Salons Partenaires
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Les Salons Partenaires sont tenus de respecter des normes professionnelles strictes. Ils sont seuls responsables de :
      </p>
      <ul class="list-disc list-inside space-y-1 text-[13px] text-cocoa/80 pl-2">
        <li>L'exactitude des tarifs, disponibilités, descriptifs de services et photos affichés ;</li>
        <li>La possession des qualifications requises, des assurances professionnelles et des autorisations d'exercer ;</li>
        <li>L'hygiène, la sécurité sanitaire des locaux, et la qualité d'exécution technique des prestations ;</li>
        <li>Leur conformité fiscale locale et le paiement de leurs propres taxes professionnelles.</li>
      </ul>
      <p class="text-[13px] text-cocoa/70">
        {{ legalConfig.operatorName }} effectue des contrôles documentaires, mais ne contrôle pas en temps réel la conformité opérationnelle quotidienne des salons. Nous pouvons exclure tout salon faisant l'objet d'avis négatifs récurrents ou de signalements de manquement à l'hygiène.
      </p>
    </section>

    <!-- Section 6 -->
    <section class="space-y-4" aria-labelledby="sec-bookings">
      <h2 id="sec-bookings" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">06.</span> Processus et validation des réservations
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Conformément à la logique technique de la plateforme, une Réservation est initiée en choisissant un salon, un service, un membre du personnel et un créneau horaire.
      </p>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        La Réservation n'est considérée comme validée et bloquée (« confirmée ») qu'à l'issue du paiement effectif de l'Acompte requis via la plateforme de paiement. Le Client reçoit un message de confirmation automatique par le canal de notification de la plateforme. En cas de blocage technique ou de non-paiement de l'acompte dans le délai de session, le créneau horaire redevient libre et la demande de réservation expire.
      </p>
    </section>

    <!-- Section 7 -->
    <section class="space-y-4" aria-labelledby="sec-payments">
      <h2 id="sec-payments" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">07.</span> Acomptes et transactions financières
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Le paiement de l'Acompte est traité de manière sécurisée par l'agrégateur de paiement tiers <strong>PayDunya</strong>. Les modes de paiement acceptés dépendent des intégrations actives de PayDunya (incluant les portefeuilles de mobile money Wave et Orange Money).
      </p>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        {{ legalConfig.operatorName }} collecte le montant de l'acompte au nom et pour le compte du Salon Partenaire. Une transaction est réputée finalisée après validation par les serveurs de PayDunya et enregistrement du statut « réussi » dans notre base de données.
      </p>
    </section>

    <!-- Section 8 -->
    <section class="space-y-4" aria-labelledby="sec-cancellation">
      <h2 id="sec-cancellation" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">08.</span> Conditions d'annulation et de remboursement
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        La politique d'annulation de rendez-vous dépend des paramètres définis par la Plateforme ou le Salon Partenaire et est validée au moment de la confirmation de réservation.
      </p>
      <div class="p-5 rounded-2xl bg-sand/30 border border-outline-variant/60 space-y-3 text-[13px] text-cocoa/80">
        <ul class="space-y-2">
          <li><strong>Annulation par le Client :</strong> Si le Client annule sa réservation avant la fin de la période d'annulation configurée (par défaut 24h avant le rendez-vous), l'acompte est éligible à remboursement (sous déduction éventuelle des frais techniques du réseau ou de l'opérateur de paiement). Au-delà de cette fenêtre d'annulation, l'acompte n'est plus remboursable et est versé au salon à titre de dédommagement.</li>
          <li><strong>Annulation par le Salon :</strong> En cas d'annulation ou d'absence constatée du Salon Partenaire, l'acompte est intégralement remboursé au Client.</li>
          <li><strong>Force majeure / Erreurs techniques :</strong> En cas de double transaction de paiement par erreur système avérée ou de panne majeure confirmée, {{ legalConfig.operatorName }} procède au remboursement des fonds perçus à tort.</li>
          <li><strong>Frais et délais :</strong> Le traitement opérationnel des remboursements intervient dans les meilleurs délais, mais reste soumis aux contraintes techniques et délais de traitement réglementaires de PayDunya et des opérateurs de réseaux (Wave, Orange Money), pouvant prendre plusieurs jours.</li>
        </ul>
      </div>
    </section>

    <!-- Section 9 -->
    <section class="space-y-4" aria-labelledby="sec-liability">
      <h2 id="sec-liability" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">09.</span> Responsabilités respectives
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        La plateforme {{ legalConfig.appName }} est fournie en tant qu'intermédiaire technique. Les salons partenaires sont des professionnels indépendants qui effectuent eux-mêmes les prestations sous leur propre responsabilité.
      </p>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        {{ legalConfig.operatorName }} est responsable du fonctionnement technique de sa Plateforme, de la sécurité logique de ses serveurs, du traitement correct des flux de paiement sous son contrôle et de l'exécution des remboursements dus conformément aux présentes conditions. Nous déclinons toute responsabilité en cas de litige relatif à la coupe de cheveux, aux traitements cosmétiques, aux blessures, à la qualité des soins ou aux retards survenus dans l'enceinte des Salons Partenaires.
      </p>
    </section>

    <!-- Section 10 -->
    <section class="space-y-4" aria-labelledby="sec-prohibited">
      <h2 id="sec-prohibited" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">10.</span> Usages interdits
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Il est strictement interdit de faire un usage détourné de la plateforme. Sont notamment prohibés :
      </p>
      <ul class="list-disc list-inside space-y-1 text-[13px] text-cocoa/80 pl-2">
        <li>La création de faux comptes pour perturber l'agenda des salons ;</li>
        <li>Toute tentative d'intrusion, de rétro-ingénierie ou de perturbation technique de l'API de {{ legalConfig.appName }} ;</li>
        <li>L'utilisation de scripts ou de robots (robots de scraping) pour copier les bases de données ;</li>
        <li>Le contournement des règles de paiement ou l'utilisation frauduleuse de comptes Wave/Orange Money tiers.</li>
      </ul>
    </section>

    <!-- Section 11 -->
    <section class="space-y-4" aria-labelledby="sec-ip">
      <h2 id="sec-ip" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">11.</span> Propriété intellectuelle et contenus
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        La marque {{ legalConfig.appName }}, les logos associés, les chartes graphiques, le code source de l'application et du site internet sont la propriété intellectuelle exclusive de <strong>{{ legalConfig.operatorName }}</strong>.
      </p>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Les photos, images de réalisations et descriptions fournies par les Salons Partenaires restent leur propriété exclusive. Ces derniers accordent à {{ legalConfig.operatorName }} une licence d'utilisation gratuite, mondiale et non exclusive pour diffuser ces contenus uniquement aux fins d'affichage et de promotion au sein de la Plateforme.
      </p>
    </section>

    <!-- Section 12 -->
    <section class="space-y-4" aria-labelledby="sec-suspension">
      <h2 id="sec-suspension" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">12.</span> Suspension et résiliation
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        En cas de manquement grave ou répété à l'une des dispositions des présentes CGU (fraudes, menaces, fausses réservations récurrentes), {{ legalConfig.operatorName }} pourra suspendre immédiatement et sans mise en demeure le compte de l'utilisateur. Les réservations en cours déjà réglées seront soit honorées par le salon, soit annulées et remboursées si la faute émane de la Plateforme ou du Salon Partenaire.
      </p>
    </section>

    <!-- Section 13 -->
    <section class="space-y-4" aria-labelledby="sec-changes">
      <h2 id="sec-changes" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">13.</span> Évolution des services et modifications
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Nous faisons évoluer régulièrement les fonctionnalités de {{ legalConfig.appName }} pour améliorer l'expérience. Ces modifications n'impacteront pas rétroactivement les réservations déjà payées et confirmées. Les CGU applicables sont celles en vigueur et acceptées au jour de la transaction.
      </p>
    </section>

    <!-- Section 14 -->
    <section class="space-y-4" aria-labelledby="sec-disputes">
      <h2 id="sec-disputes" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">14.</span> Réclamations et résolution amiable
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Pour toute réclamation, incident technique ou demande de support, le Client peut adresser un e-mail à l'adresse officielle : <strong>{{ legalConfig.emailJuridique }}</strong>.
      </p>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Les parties s'engagent à faire leurs meilleurs efforts pour résoudre à l'amiable tout litige né de l'interprétation ou de l'exécution des présentes conditions. À défaut de résolution amiable, le litige relève des juridictions compétentes conformément aux règles impératives applicables.
      </p>
    </section>

    <!-- Section 15 -->
    <section class="space-y-4" aria-labelledby="sec-law">
      <h2 id="sec-law" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">15.</span> Droit applicable
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Les présentes Conditions Générales d'Utilisation sont régies et interprétées selon la législation de la République du Sénégal. Il est fait référence expresse aux dispositions de la <strong>Loi n° 2008-08 du 25 janvier 2008 sur les transactions électroniques</strong> et de la <strong>Loi n° 2008-12 du 25 janvier 2008 relative à la protection des données à caractère personnel</strong>.
      </p>
    </section>
  </LegalLayout>
</template>

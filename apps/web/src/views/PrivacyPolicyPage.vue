<script setup lang="ts">
import { ShieldCheckIcon } from '@heroicons/vue/24/outline';
import { legalConfig } from '@beauteavenue/shared-ts';
import LegalLayout from '@/layouts/LegalLayout.vue';

const hasValue = (val?: string) => {
  return val && val.trim() !== '' && !val.includes('[') && !val.includes(']');
};
</script>

<template>
  <LegalLayout
    page-title="Politique de Confidentialité"
    page-subtitle="Protection de vos données personnelles et conformité réglementaire"
    badge-text="Cadre Légal Sénégalais"
  >
    <template #badge-icon>
      <ShieldCheckIcon class="w-4 h-4" aria-hidden="true" />
    </template>

    <!-- Section 1 -->
    <section class="space-y-4" aria-labelledby="sec-identity">
      <h2 id="sec-identity" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">01.</span> Identité du responsable du traitement
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Le responsable du traitement des données à caractère personnel collectées sur la plateforme {{ legalConfig.appName }} est la société <strong>{{ legalConfig.operatorName }}</strong><span v-if="hasValue(legalConfig.formeJuridique)"> ({{ legalConfig.formeJuridique }})</span>.
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
    <section class="space-y-4" aria-labelledby="sec-scope">
      <h2 id="sec-scope" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">02.</span> Portée et champ d'application
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        La présente politique s'applique à l'ensemble des services édités et fournis par {{ legalConfig.operatorName }} dans le cadre de la plateforme {{ legalConfig.appName }}, notamment :
      </p>
      <ul class="list-disc list-inside space-y-1 text-[13px] text-cocoa/80 pl-2">
        <li>L'application mobile {{ legalConfig.appName }} ;</li>
        <li>Le site internet et les portails web associés ;</li>
        <li>Les comptes clients et les espaces dédiés aux professionnels (salons) ;</li>
        <li>Les processus de réservation, de paiement et de gestion des acomptes ;</li>
        <li>Le service client, l'assistance technique et les notifications (SMS, Push, E-mail).</li>
      </ul>
    </section>

    <!-- Section 3 -->
    <section class="space-y-4" aria-labelledby="sec-categories">
      <h2 id="sec-categories" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">03.</span> Catégories de données collectées
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Sur la base des fonctionnalités de l'application et de sa structure de base de données, les catégories de données suivantes sont collectées et traitées :
      </p>
      <div class="space-y-3 pl-4 border-l-2 border-primary/20 text-[13px] text-cocoa/80">
        <p>
          <strong class="text-espresso">Données d'identification et de compte :</strong> Nom, prénom, numéro de téléphone, adresse e-mail, photo de profil (le cas échéant) et identifiants uniques de compte.
        </p>
        <p>
          <strong class="text-espresso">Données d'authentification :</strong> Jetons de session, métadonnées de connexion et journaux de validation de sécurité par mot de passe ou code de validation temporaire (OTP).
        </p>
        <p>
          <strong class="text-espresso">Données de réservation :</strong> Prestations sélectionnées, dates et heures de rendez-vous, notes facultatives saisies par le client, historique de présence et d'annulation.
        </p>
        <p>
          <strong class="text-espresso">Avis et évaluations :</strong> Notes sur cinq étoiles attribuées aux salons partenaires, commentaires rédigés et dates de soumission.
        </p>
        <p>
          <strong class="text-espresso">Données de paiement et transactions :</strong> Identifiant de transaction, montant de l'acompte payé, statut du paiement, clé d'idempotence, signature des webhooks de notification de paiement et références du fournisseur de paiement.
        </p>
        <p>
          <strong class="text-espresso">Données techniques et de navigation :</strong> Adresse IP, identifiant de l'appareil (device ID), jetons de notification push (FCM token), cookies, données de stockage local (localStorage/sessionStorage) et informations système (user-agent).
        </p>
        <p>
          <strong class="text-espresso">Données professionnelles (Salons Partenaires uniquement) :</strong> Documents d'identification fiscale ou commerciale, justificatifs professionnels, liste des employés, plannings, grille tarifaire des services et détails de versement pour les reversements bancaires ou mobile money.
        </p>
      </div>
    </section>

    <!-- Section 4 -->
    <section class="space-y-4" aria-labelledby="sec-geolocation">
      <h2 id="sec-geolocation" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">04.</span> Géolocalisation
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        L'application mobile propose une fonction de géolocalisation pour identifier les salons à proximité immédiate de l'utilisateur.
      </p>
      <p class="text-[13px] leading-relaxed text-cocoa/70">
        Cette collecte est <strong>ponctuelle et facultative</strong>. Elle n'intervient que lorsque l'application est ouverte au premier plan et sous réserve du consentement accordé via les autorisations du système d'exploitation mobile (iOS/Android). Aucun suivi en arrière-plan ni historique continu des déplacements n'est enregistré sur nos serveurs. L'utilisateur peut à tout moment désactiver ce service dans les réglages de son appareil mobile et effectuer des recherches manuelles.
      </p>
    </section>

    <!-- Section 5 -->
    <section class="space-y-4" aria-labelledby="sec-purposes">
      <h2 id="sec-purposes" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">05.</span> Tableau des finalités et bases légales
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse text-[12px] text-cocoa/80">
          <thead>
            <tr class="bg-espresso text-white">
              <th class="p-3 font-semibold uppercase tracking-wider">Traitement</th>
              <th class="p-3 font-semibold uppercase tracking-wider">Finalité</th>
              <th class="p-3 font-semibold uppercase tracking-wider">Base Légale</th>
              <th class="p-3 font-semibold uppercase tracking-wider">Destinataires</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-outline-variant/60">
            <tr class="hover:bg-neutral-bg/30">
              <td class="p-3 font-medium text-espresso">Authentification & Comptes</td>
              <td class="p-3">Création de profil client/professionnel et envoi d'OTP de validation.</td>
              <td class="p-3">Exécution du contrat</td>
              <td class="p-3">Services internes, Routeur SMS</td>
            </tr>
            <tr class="hover:bg-neutral-bg/30">
              <td class="p-3 font-medium text-espresso">Gestion des réservations</td>
              <td class="p-3">Enregistrement du créneau, affectation du personnel et rappels.</td>
              <td class="p-3">Exécution du contrat</td>
              <td class="p-3">Salons Partenaires concernés</td>
            </tr>
            <tr class="hover:bg-neutral-bg/30">
              <td class="p-3 font-medium text-espresso">Paiement d'acompte</td>
              <td class="p-3">Encaissement de l'acompte via mobile money pour valider le créneau.</td>
              <td class="p-3">Exécution du contrat</td>
              <td class="p-3">Prestataire de paiement (PayDunya)</td>
            </tr>
            <tr class="hover:bg-neutral-bg/30">
              <td class="p-3 font-medium text-espresso">Vérification de compte pro</td>
              <td class="p-3">Validation des pièces administratives et fiscales des salons.</td>
              <td class="p-3">Obligation légale / Intérêt légitime</td>
              <td class="p-3">Services de modération internes</td>
            </tr>
            <tr class="hover:bg-neutral-bg/30">
              <td class="p-3 font-medium text-espresso">Sécurité & Audit</td>
              <td class="p-3">Détection des anomalies de paiement et des fraudes de compte.</td>
              <td class="p-3">Intérêt légitime</td>
              <td class="p-3">Équipes de sécurité, hébergeur</td>
            </tr>
            <tr class="hover:bg-neutral-bg/30">
              <td class="p-3 font-medium text-espresso">Support client</td>
              <td class="p-3">Résolution des difficultés techniques et traitement des plaintes.</td>
              <td class="p-3">Exécution du contrat</td>
              <td class="p-3">Outils internes d'assistance</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- Section 6 -->
    <section class="space-y-4" aria-labelledby="sec-payment">
      <h2 id="sec-payment" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">06.</span> Traitement des données financières
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Les paiements d'acomptes en ligne sont entièrement délégués à notre <strong>prestataire de paiement</strong> agréé, la plateforme <strong>PayDunya</strong>.
      </p>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        {{ legalConfig.operatorName }} ne reçoit et ne stocke aucune donnée bancaire hautement confidentielle, telle que vos codes secrets de mobile money (Wave, Orange Money), ou numéros de carte de paiement. Nous conservons uniquement des métadonnées de transaction non sensibles nécessaires au suivi comptable et au traitement des remboursements : le statut de la transaction (réussite, échec), la référence unique fournie par PayDunya, le montant réglé et la date de paiement.
      </p>
    </section>

    <!-- Section 7 -->
    <section class="space-y-4" aria-labelledby="sec-recipients">
      <h2 id="sec-recipients" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">07.</span> Destinataires des données et sous-traitants
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Dans le cadre de l'exploitation de la plateforme, certaines données sont transmises à des tiers sous-traitants sous contrat de conformité technique :
      </p>
      <ul class="space-y-2 text-[13px] text-cocoa/80 pl-4 border-l-2 border-secondary/20">
        <li><strong>PayDunya :</strong> Pour la passerelle de paiement mobile money et cartes bancaires.</li>
        <li><strong>Africa's Talking :</strong> Pour le routage technique des SMS et codes d'authentification temporaires (OTP).</li>
        <li><strong>Firebase Cloud Messaging (FCM) :</strong> Pour la distribution technique des notifications push de rappel sur mobile.</li>
        <li><strong>Fournisseurs d'hébergement :</strong> Pour l'exécution sécurisée de l'API, de la base de données PostgreSQL et du stockage d'images.</li>
      </ul>
    </section>

    <!-- Section 8 -->
    <section class="space-y-4" aria-labelledby="sec-salons">
      <h2 id="sec-salons" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">08.</span> Données partagées avec les Salons Partenaires
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Afin de permettre l'exécution des prestations réservées, les informations suivantes sont communiquées au Salon Partenaire concerné :
      </p>
      <ul class="list-disc list-inside space-y-1 text-[13px] text-cocoa/80 pl-2">
        <li>Votre prénom, nom et numéro de téléphone ;</li>
        <li>Les caractéristiques de la réservation (prestation, date, heure, notes fournies) ;</li>
        <li>Le statut du paiement de l'acompte ;</li>
        <li>L'historique des réservations effectuées et honorées auprès de ce salon spécifique.</li>
      </ul>
      <p class="text-[13px] text-cocoa/70 italic">
        Les Salons Partenaires sont contractuellement tenus d'utiliser ces informations uniquement pour la gestion et l'exécution du service demandé, et s'engagent à respecter les lois locales sur la protection des données.
      </p>
    </section>

    <!-- Section 9 -->
    <section class="space-y-4" aria-labelledby="sec-transfers">
      <h2 id="sec-transfers" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">09.</span> Transferts internationaux de données
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Pour des raisons techniques d'infrastructure logicielle, nos serveurs de base de données et de stockage d'images peuvent être hébergés auprès de prestataires situés en dehors du territoire sénégalais. {{ legalConfig.operatorName }} s'assure que ces hébergeurs offrent des garanties suffisantes de sécurité et de conformité aux standards internationaux de protection de la vie privée.
      </p>
    </section>

    <!-- Section 10 -->
    <section class="space-y-4" aria-labelledby="sec-retention">
      <h2 id="sec-retention" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">10.</span> Durées de conservation
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse text-[12px] text-cocoa/80">
          <thead>
            <tr class="bg-espresso text-white">
              <th class="p-3 font-semibold uppercase tracking-wider">Type de Données</th>
              <th class="p-3 font-semibold uppercase tracking-wider">Durée de conservation active</th>
              <th class="p-3 font-semibold uppercase tracking-wider">Raison de conservation</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-outline-variant/60">
            <tr class="hover:bg-neutral-bg/30">
              <td class="p-3 font-medium text-espresso">Comptes Clients Inactifs</td>
              <td class="p-3">3 ans après le dernier contact actif</td>
              <td class="p-3">Nettoyage périodique & protection de la vie privée</td>
            </tr>
            <tr class="hover:bg-neutral-bg/30">
              <td class="p-3 font-medium text-espresso">Historique des Réservations</td>
              <td class="p-3">5 ans après exécution</td>
              <td class="p-3">Prescription civile sénégalaise en cas de litige</td>
            </tr>
            <tr class="hover:bg-neutral-bg/30">
              <td class="p-3 font-medium text-espresso">Factures & Transactions financières</td>
              <td class="p-3">10 ans après la clôture de l'exercice</td>
              <td class="p-3">Obligation légale comptable et fiscale du Sénégal</td>
            </tr>
            <tr class="hover:bg-neutral-bg/30">
              <td class="p-3 font-medium text-espresso">Codes de vérification OTP</td>
              <td class="p-3">1 an maximum</td>
              <td class="p-3">Audits de sécurité et prévention de l'abus de jetons</td>
            </tr>
            <tr class="hover:bg-neutral-bg/30">
              <td class="p-3 font-medium text-espresso">Journaux techniques (Logs)</td>
              <td class="p-3">1 an maximum</td>
              <td class="p-3">Détection des intrusions et correction des erreurs</td>
            </tr>
            <tr class="hover:bg-neutral-bg/30">
              <td class="p-3 font-medium text-espresso">Pièces d'identité pour vérification pro</td>
              <td class="p-3">5 ans pour les comptes actifs ; 30 jours après rejet d'inscription</td>
              <td class="p-3">Lutte contre la fraude administrative et fiscale</td>
            </tr>
            <tr class="hover:bg-neutral-bg/30">
              <td class="p-3 font-medium text-espresso">Sauvegardes de bases de données (Backups)</td>
              <td class="p-3">30 jours (cycle de rotation)</td>
              <td class="p-3">Plan de reprise d'activité technique</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- Section 11 -->
    <section class="space-y-4" aria-labelledby="sec-security">
      <h2 id="sec-security" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">11.</span> Sécurité technique et organisationnelle
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        {{ legalConfig.operatorName }} met en œuvre des mesures de protection techniques courantes et adaptées au niveau de risque, notamment l'utilisation du protocole de chiffrement HTTPS/TLS pour l'ensemble des flux d'échange, un cloisonnement strict des accès serveurs aux seuls employés habilités, une journalisation des accès de sécurité, ainsi que la validation double-facteur OTP.
      </p>
      <p class="text-[13px] text-cocoa/60 italic leading-relaxed">
        Toutefois, la transmission de données sur les réseaux informatiques et mobiles money n'étant jamais sécurisée de façon absolue, {{ legalConfig.operatorName }} ne peut promettre une immunité totale contre tout incident de sécurité.
      </p>
    </section>

    <!-- Section 12 -->
    <section class="space-y-4" aria-labelledby="sec-rights">
      <h2 id="sec-rights" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">12.</span> Vos droits
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Conformément à la Loi n° 2008-12 du 25 janvier 2008 au Sénégal, vous disposez d'un droit d'information, d'un droit d'accès, de rectification, d'opposition et de suppression de vos données personnelles.
      </p>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Le droit à l'effacement n'est pas inconditionnel et peut être écarté lorsque la conservation des données est indispensable pour respecter nos obligations légales (notamment comptables et fiscales), pour prévenir les fraudes ou pour défendre nos droits dans le cadre d'un litige.
      </p>
    </section>

    <!-- Section 13 -->
    <section class="space-y-4" aria-labelledby="sec-process">
      <h2 id="sec-process" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">13.</span> Processus de demande de droits
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Toute demande d'accès ou d'exercice de vos droits doit être adressée par e-mail à : <strong>{{ legalConfig.emailJuridique }}</strong>.
      </p>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Afin d'éviter tout piratage ou usurpation d'identité, la demande doit provenir du numéro ou de l'adresse e-mail associée au compte, et s'accompagner d'une justification raisonnable permettant de s'assurer de votre identité. {{ legalConfig.operatorName }} s'engage à traiter la demande dans un délai d'un (1) mois à compter de sa réception complète. En cas de demande infondée ou abusive, une opposition motivée pourra être opposée conformément à la loi.
      </p>
    </section>

    <!-- Section 14 -->
    <section class="space-y-4" aria-labelledby="sec-cookies">
      <h2 id="sec-cookies" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">14.</span> Cookies et stockage local
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        La plateforme web utilise des cookies techniques internes et le stockage de données du navigateur (localStorage / sessionStorage) pour maintenir votre connexion authentifiée en cours et conserver vos préférences fonctionnelles (comme votre session d'espace professionnel). Aucun cookie de ciblage publicitaire tiers n'est déposé sur votre terminal. Vous pouvez bloquer les cookies à tout moment via les réglages de votre navigateur, ce qui entraînera l'obligation de vous reconnecter à chaque visite.
      </p>
    </section>

    <!-- Section 15 -->
    <section class="space-y-4" aria-labelledby="sec-mobile">
      <h2 id="sec-mobile" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">15.</span> Stockage mobile et permissions
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        L'application mobile utilise un espace de stockage sécurisé local pour mémoriser votre jeton d'accès utilisateur et ses préférences (via la bibliothèque Hive ou similaire). L'application requiert par ailleurs les autorisations système suivantes :
      </p>
      <ul class="list-disc list-inside space-y-1 text-[13px] text-cocoa/80 pl-2">
        <li><strong>Notification :</strong> Pour vous envoyer des rappels automatiques et alertes de statut de rendez-vous ;</li>
        <li><strong>Localisation :</strong> Pour la recherche géolocalisée (facultative) ;</li>
        <li><strong>Appareil Photo / Galerie :</strong> Pour téléverser des images de profil ou des pièces administratives de salons professionnels.</li>
      </ul>
      <p class="text-[13px] text-cocoa/70">
        Une action de déconnexion efface le jeton d'authentification mémorisé localement dans le stockage mobile.
      </p>
    </section>

    <!-- Section 16 -->
    <section class="space-y-4" aria-labelledby="sec-minors">
      <h2 id="sec-minors" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">16.</span> Mineurs et capacité juridique
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        La plateforme {{ legalConfig.appName }} est conçue pour des personnes majeures ayant la capacité juridique de contracter et de payer. L'utilisation par des mineurs s'effectue sous la surveillance et avec l'autorisation de leur représentant légal (parent ou tuteur).
      </p>
    </section>

    <!-- Section 17 -->
    <section class="space-y-4" aria-labelledby="sec-breach">
      <h2 id="sec-breach" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">17.</span> Procédure en cas de violation de données
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        En cas de détection d'une violation de données entraînant un risque élevé pour vos droits et libertés, {{ legalConfig.operatorName }} s'engage à notifier l'autorité de protection des données compétente au Sénégal (CDP) et à informer individuellement les utilisateurs concernés, dans les délais impartis par la réglementation locale applicable.
      </p>
    </section>

    <!-- Section 18 -->
    <section class="space-y-4" aria-labelledby="sec-updates">
      <h2 id="sec-updates" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">18.</span> Mises à jour de la politique
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        {{ legalConfig.operatorName }} se réserve le droit de modifier la présente politique de confidentialité à tout moment pour l'adapter aux évolutions techniques ou réglementaires. En cas de changement significatif impactant vos droits fondamentaux, une notification préalable vous sera adressée sur l'application ou par courrier électronique.
      </p>
    </section>

    <!-- Section 19 -->
    <section class="space-y-4" aria-labelledby="sec-contact">
      <h2 id="sec-contact" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">19.</span> Contact
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Pour toute question ou demande de clarification relative aux données personnelles, vous pouvez nous contacter à l'adresse email générique suivante : <strong>{{ legalConfig.emailJuridique }}</strong>.
      </p>
    </section>
  </LegalLayout>
</template>

<script setup lang="ts">
import { InformationCircleIcon } from '@heroicons/vue/24/outline';
import { legalConfig } from '@beauteavenue/shared-ts';
import LegalLayout from '@/layouts/LegalLayout.vue';
</script>

<template>
  <LegalLayout
    page-title="Gestion des Cookies"
    page-subtitle="Politique relative aux cookies et technologies de stockage local utilisés sur la plateforme"
    badge-text="Protection de la Vie Privée"
  >
    <template #badge-icon>
      <InformationCircleIcon class="w-4 h-4" aria-hidden="true" />
    </template>

    <!-- Section 1 -->
    <section class="space-y-4" aria-labelledby="sec-what">
      <h2 id="sec-what" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">01.</span> Qu'est-ce qu'un cookie ?
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Un cookie est un petit fichier texte déposé sur votre terminal (ordinateur, tablette ou mobile) lors de la visite d'un site web. Il permet de stocker des informations relatives à votre navigation et de vous reconnaître lors de vos visites ultérieures.
      </p>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Sur la plateforme {{ legalConfig.appName }}, nous utilisons également le stockage local de votre navigateur (localStorage et sessionStorage) ainsi que les stockages internes de l'application mobile à des fins fonctionnelles similaires. L'ensemble de ces technologies est désigné ci-après par le terme « Cookies ».
      </p>
    </section>

    <!-- Section 2 -->
    <section class="space-y-4" aria-labelledby="sec-types">
      <h2 id="sec-types" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">02.</span> Types de cookies utilisés
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <div class="space-y-4 text-[13px] text-cocoa/80">
        <div class="p-4 rounded-xl bg-sand/30 border border-outline-variant/40">
          <strong class="text-espresso block mb-1">Cookies techniques strictement nécessaires</strong>
          <p>Ces cookies sont essentiels au fonctionnement de la plateforme. Ils permettent de maintenir votre session authentifiée, de mémoriser vos préférences de navigation et d'assurer la sécurité de vos transactions. Sans ces cookies, certains services ne peuvent pas fonctionner correctement.</p>
          <p class="mt-2 text-cocoa/60 text-[12px]"><strong>Durée de conservation :</strong> Durée de la session ou paramètres de l'utilisateur.</p>
        </div>
        <div class="p-4 rounded-xl bg-sand/30 border border-outline-variant/40">
          <strong class="text-espresso block mb-1">Stockage local (localStorage / sessionStorage)</strong>
          <p>La plateforme web utilise le localStorage pour conserver votre jeton d'authentification et vos préférences fonctionnelles (thème, langue). Ces informations restent sur votre appareil et ne sont pas automatiquement transmises à nos serveurs en dehors des appels API nécessaires au service.</p>
          <p class="mt-2 text-cocoa/60 text-[12px]"><strong>Durée de conservation :</strong> Jusqu'à la déconnexion ou suppression manuelle.</p>
        </div>
      </div>
      <p class="text-[14px] leading-relaxed text-cocoa/80 font-medium text-primary">
        {{ legalConfig.operatorName }} n'utilise aucun cookie de ciblage publicitaire, cookie tiers de réseau social, cookie de suivi intersite ou cookie de profilage à des fins commerciales.
      </p>
    </section>

    <!-- Section 3 -->
    <section class="space-y-4" aria-labelledby="sec-mobile">
      <h2 id="sec-mobile" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">03.</span> Application mobile et stockage local
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        L'application mobile {{ legalConfig.appName }} utilise un espace de stockage sécurisé interne (Hive) pour mémoriser localement votre jeton d'accès, vos informations de profil et les données de navigation en cache. Ce stockage est chiffré et isolé par le système d'exploitation de votre appareil.
      </p>
      <ul class="list-disc list-inside space-y-1 text-[13px] text-cocoa/80 pl-2">
        <li>La déconnexion de l'application efface automatiquement le jeton d'authentification stocké localement.</li>
        <li>Les données de cache (salons, services, disponibilités) sont conservées pour améliorer la vitesse de navigation et permettre un mode hors ligne partiel.</li>
        <li>Vous pouvez effacer l'ensemble des données locales via les paramètres de votre appareil (Paramètres → Applications → {{ legalConfig.appName }} → Effacer les données).</li>
      </ul>
    </section>

    <!-- Section 4 -->
    <section class="space-y-4" aria-labelledby="sec-manage">
      <h2 id="sec-manage" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">04.</span> Gérer vos préférences de cookies
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Vous pouvez à tout moment configurer votre navigateur pour être informé de l'utilisation des cookies ou les refuser. La procédure dépend du navigateur que vous utilisez :
      </p>
      <ul class="list-disc list-inside space-y-1 text-[13px] text-cocoa/80 pl-2">
        <li><strong>Google Chrome :</strong> Paramètres → Confidentialité et sécurité → Cookies et autres données</li>
        <li><strong>Safari :</strong> Préférences → Confidentialité → Cookies et données de sites web</li>
        <li><strong>Mozilla Firefox :</strong> Options → Vie privée et sécurité → Cookies et données</li>
        <li><strong>Microsoft Edge :</strong> Paramètres → Cookies et autorisations → Cookies</li>
      </ul>
      <p class="text-[13px] text-cocoa/70 italic mt-4">
        Note : Le blocage de l'ensemble des cookies techniques pourrait affecter le fonctionnement normal de la plateforme et vous obliger à vous reconnecter à chaque visite.
      </p>
    </section>

    <!-- Section 5 -->
    <section class="space-y-4" aria-labelledby="sec-updates">
      <h2 id="sec-updates" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">05.</span> Mises à jour de la politique cookies
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        {{ legalConfig.operatorName }} se réserve le droit de modifier la présente politique relative aux cookies à tout moment pour l'adapter aux évolutions techniques ou réglementaires. Nous vous invitons à consulter régulièrement cette page.
      </p>
    </section>

    <!-- Section 6 -->
    <section class="space-y-4" aria-labelledby="sec-contact">
      <h2 id="sec-contact" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">06.</span> Contact
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Pour toute question relative à l'utilisation des cookies et technologies de stockage sur la plateforme {{ legalConfig.appName }}, vous pouvez nous contacter à l'adresse <a :href="'mailto:' + legalConfig.emailJuridique" class="text-primary hover:underline">{{ legalConfig.emailJuridique }}</a>.
      </p>
    </section>
  </LegalLayout>
</template>

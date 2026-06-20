<script setup lang="ts">
import { ScaleIcon } from '@heroicons/vue/24/outline';
import { legalConfig } from '@beauteavenue/shared-ts';
import LegalLayout from '@/layouts/LegalLayout.vue';

const hasValue = (val?: string) => {
  return val && val.trim() !== '' && !val.includes('[') && !val.includes(']');
};
</script>

<template>
  <LegalLayout
    page-title="Mentions Légales"
    page-subtitle="Informations légales et identification de l'éditeur de la plateforme"
    badge-text="Conformité Légale"
  >
    <template #badge-icon>
      <ScaleIcon class="w-4 h-4" aria-hidden="true" />
    </template>

    <!-- Section 1 -->
    <section class="space-y-4" aria-labelledby="sec-editor">
      <h2 id="sec-editor" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">01.</span> Éditeur de la plateforme
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        La plateforme {{ legalConfig.appName }} est éditée par la société <strong>{{ legalConfig.operatorName }}</strong><span v-if="hasValue(legalConfig.formeJuridique)"> ({{ legalConfig.formeJuridique }})</span>.
      </p>

      <div class="p-5 rounded-2xl bg-sand/30 border border-outline-variant/60 space-y-2 text-[13px] text-cocoa/80">
        <p v-if="hasValue(legalConfig.adresseSiege)">
          <strong class="text-espresso">Siège social :</strong> {{ legalConfig.adresseSiege }}
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
          <strong class="text-espresso">Contact e-mail :</strong>
          <a :href="'mailto:' + legalConfig.emailJuridique" class="text-primary hover:underline">{{ legalConfig.emailJuridique }}</a>
        </p>
        <p v-if="hasValue(legalConfig.referenceCdp)">
          <strong class="text-espresso">Référence CDP :</strong> {{ legalConfig.referenceCdp }}
        </p>
      </div>
    </section>

    <!-- Section 2 -->
    <section class="space-y-4" aria-labelledby="sec-host">
      <h2 id="sec-host" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">02.</span> Hébergement
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        La plateforme {{ legalConfig.appName }} est hébergée par des prestataires techniques spécialisés offrant des infrastructures sécurisées de classe entreprise. L'hébergement peut être situé au Sénégal ou dans des centres de données internationaux conformes aux standards en vigueur.
      </p>
      <p class="text-[13px] text-cocoa/60 italic">
        Pour toute demande spécifique relative à l'hébergement des données, veuillez nous contacter à l'adresse e-mail juridique mentionnée ci-dessus.
      </p>
    </section>

    <!-- Section 3 -->
    <section class="space-y-4" aria-labelledby="sec-activity">
      <h2 id="sec-activity" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">03.</span> Activité
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        {{ legalConfig.appName }} est une plateforme de mise en relation entre les clients et les salons de beauté partenaires. La société {{ legalConfig.operatorName }} agit en qualité d'intermédiaire technique et n'exerce pas directement les professions de coiffure, d'esthétique ou de bien-être proposées par les salons partenaires référencés sur la plateforme.
      </p>
    </section>

    <!-- Section 4 -->
    <section class="space-y-4" aria-labelledby="sec-ip">
      <h2 id="sec-ip" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">04.</span> Propriété intellectuelle
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        L'ensemble des marques, logos, noms de domaine, contenus, design, code source, bases de données et chartes graphiques de la plateforme {{ legalConfig.appName }} sont la propriété exclusive de {{ legalConfig.operatorName }}, sauf indication contraire. Toute reproduction, représentation, diffusion ou exploitation, même partielle, est strictement interdite sans autorisation écrite préalable.
      </p>
    </section>

    <!-- Section 5 -->
    <section class="space-y-4" aria-labelledby="sec-responsibility">
      <h2 id="sec-responsibility" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">05.</span> Responsabilité
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        {{ legalConfig.operatorName }} s'efforce d'assurer l'exactitude et la mise à jour des informations diffusées sur la plateforme, sans pouvoir garantir l'absence d'erreurs ou d'omissions. La responsabilité de {{ legalConfig.operatorName }} ne saurait être engagée en cas de dommages directs ou indirects résultant de l'utilisation de la plateforme ou des services des salons partenaires.
      </p>
    </section>

    <!-- Section 6 -->
    <section class="space-y-4" aria-labelledby="sec-contacts">
      <h2 id="sec-contacts" class="text-2xl font-display font-medium-bold text-espresso flex items-center gap-3">
        <span class="text-primary font-sans text-lg" aria-hidden="true">06.</span> Contact
      </h2>
      <div class="h-[1px] bg-outline-variant/50 w-16" aria-hidden="true"></div>
      <p class="text-[14px] leading-relaxed text-cocoa/80">
        Pour toute demande d'information relative aux mentions légales, vous pouvez nous contacter :
      </p>
      <ul class="list-disc list-inside space-y-1 text-[13px] text-cocoa/80 pl-2">
        <li>Par e-mail : <a :href="'mailto:' + legalConfig.emailJuridique" class="text-primary hover:underline">{{ legalConfig.emailJuridique }}</a></li>
        <li v-if="hasValue(legalConfig.telephone)">Par téléphone : {{ legalConfig.telephone }}</li>
        <li v-if="hasValue(legalConfig.adresseSiege)">Par courrier : {{ legalConfig.adresseSiege }}</li>
      </ul>
    </section>
  </LegalLayout>
</template>

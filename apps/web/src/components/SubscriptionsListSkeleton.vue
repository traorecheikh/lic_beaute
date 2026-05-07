<template>
  <div aria-busy="true" aria-live="polite" class="space-y-6">
    <article class="panel-clean bg-white p-6">
      <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <div class="flex items-start gap-4">
          <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-secondary/10 text-secondary">
            <svg class="h-5 w-5 animate-spin" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none" />
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 0 1 8-8V0C5.37 0 0 5.37 0 12h4Zm2 5.29A7.94 7.94 0 0 1 4 12H0c0 3.04 1.13 5.82 3 7.94l3-2.65Z" />
            </svg>
          </div>
          <div class="space-y-1.5">
            <p class="section-label">Chargement en cours</p>
            <p class="row-primary">Synchronisation des abonnements</p>
            <p class="row-meta">Nous récupérons les contrats, la facturation et les statuts d'accès.</p>
          </div>
        </div>

        <div class="inline-flex items-center gap-2 self-start rounded-full bg-sand px-4 py-2">
          <span class="h-2.5 w-2.5 animate-pulse rounded-full bg-secondary"></span>
          <span class="section-label">Actualisation</span>
        </div>
      </div>
    </article>

    <section class="grid grid-cols-1 gap-4 md:grid-cols-3">
      <article
        v-for="card in 3"
        :key="card"
        class="panel-clean space-y-4 bg-white p-5"
      >
        <div class="h-3 w-24 animate-pulse rounded-full bg-sand"></div>
        <div class="h-8 w-16 animate-pulse rounded-full bg-neutral-bg"></div>
      </article>
    </section>

    <article class="panel-clean overflow-hidden bg-white">
      <div class="grid grid-cols-[1.6fr_repeat(4,minmax(0,1fr))_120px] gap-4 border-b border-outline-variant/40 bg-neutral-bg/40 px-5 py-3">
        <div
          v-for="column in 6"
          :key="column"
          class="h-3 animate-pulse rounded-full bg-sand"
        ></div>
      </div>

      <div class="divide-y divide-outline-variant/20">
        <div
          v-for="row in 5"
          :key="row"
          class="grid grid-cols-[1.6fr_repeat(4,minmax(0,1fr))_120px] items-center gap-4 px-5 py-4"
        >
          <div class="space-y-2">
            <div class="h-3.5 w-32 animate-pulse rounded-full bg-neutral-bg"></div>
            <div class="h-3 w-20 animate-pulse rounded-full bg-sand"></div>
          </div>
          <div class="h-8 w-20 animate-pulse rounded-full bg-sand"></div>
          <div class="h-8 w-20 animate-pulse rounded-full bg-sand"></div>
          <div class="h-3.5 w-20 animate-pulse rounded-full bg-neutral-bg"></div>
          <div class="h-3.5 w-24 animate-pulse rounded-full bg-neutral-bg"></div>
          <div class="ml-auto h-9 w-24 animate-pulse rounded-full bg-sand"></div>
        </div>
      </div>
    </article>
  </div>
</template>

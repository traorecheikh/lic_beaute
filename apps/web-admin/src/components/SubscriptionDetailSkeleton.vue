<template>
  <div aria-busy="true" aria-live="polite" class="space-y-8">
    <article class="panel-clean bg-white p-8 md:p-10">
      <div class="flex flex-col gap-8 lg:flex-row lg:items-center lg:justify-between">
        <div class="space-y-4">
          <div class="flex items-center gap-3">
            <div class="flex h-12 w-12 items-center justify-center rounded-2xl bg-secondary/10 text-secondary">
              <svg class="h-5 w-5 animate-spin" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none" />
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 0 1 8-8V0C5.37 0 0 5.37 0 12h4Zm2 5.29A7.94 7.94 0 0 1 4 12H0c0 3.04 1.13 5.82 3 7.94l3-2.65Z" />
              </svg>
            </div>
            <div class="space-y-1.5">
              <p class="section-label">Chargement en cours</p>
              <p class="row-primary">Préparation du cycle de vie de l'abonnement</p>
              <p class="row-meta">Nous chargeons l'historique, les droits et la facturation.</p>
            </div>
          </div>

          <div class="flex flex-wrap gap-3">
            <div class="h-9 w-48 animate-pulse rounded-full bg-neutral-bg"></div>
            <div class="h-8 w-20 animate-pulse rounded-full bg-sand"></div>
            <div class="h-8 w-20 animate-pulse rounded-full bg-sand"></div>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-4 rounded-2xl border border-outline-variant/60 bg-sand/30 p-6 sm:grid-cols-3">
          <div v-for="metric in 3" :key="metric" class="space-y-2">
            <div class="h-3 w-16 animate-pulse rounded-full bg-sand"></div>
            <div class="h-4 w-24 animate-pulse rounded-full bg-neutral-bg"></div>
          </div>
        </div>
      </div>
    </article>

    <div class="grid grid-cols-12 gap-8">
      <div class="col-span-12 space-y-8 lg:col-span-7">
        <article class="panel-clean bg-white p-6">
          <div class="mb-4 h-3 w-28 animate-pulse rounded-full bg-sand"></div>
          <div class="space-y-3">
            <div
              v-for="card in 3"
              :key="card"
              class="flex items-center justify-between rounded-2xl border border-outline-variant p-5"
            >
              <div class="space-y-2">
                <div class="h-3.5 w-40 animate-pulse rounded-full bg-neutral-bg"></div>
                <div class="h-3 w-28 animate-pulse rounded-full bg-sand"></div>
              </div>
              <div class="h-8 w-20 animate-pulse rounded-full bg-sand"></div>
            </div>
          </div>
        </article>

        <article class="panel-clean overflow-hidden bg-white">
          <div class="border-b border-outline-variant/30 px-6 py-5">
            <div class="h-3 w-24 animate-pulse rounded-full bg-sand"></div>
          </div>
          <div class="divide-y divide-outline-variant/30">
            <div v-for="event in 3" :key="event" class="space-y-3 px-6 py-5">
              <div class="flex items-center justify-between gap-4">
                <div class="h-3.5 w-48 animate-pulse rounded-full bg-neutral-bg"></div>
                <div class="h-3 w-20 animate-pulse rounded-full bg-sand"></div>
              </div>
              <div class="h-3 w-64 animate-pulse rounded-full bg-sand"></div>
            </div>
          </div>
        </article>
      </div>

      <div class="col-span-12 space-y-8 lg:col-span-5">
        <article class="panel-clean space-y-5 bg-white p-8">
          <div class="space-y-2">
            <div class="h-3 w-28 animate-pulse rounded-full bg-sand"></div>
            <div class="h-8 w-52 animate-pulse rounded-full bg-neutral-bg"></div>
          </div>
          <div class="grid grid-cols-2 gap-4 rounded-2xl border border-outline-variant/60 bg-sand/40 p-5">
            <div v-for="cell in 2" :key="cell" class="space-y-2">
              <div class="h-3 w-16 animate-pulse rounded-full bg-sand"></div>
              <div class="h-4 w-24 animate-pulse rounded-full bg-neutral-bg"></div>
            </div>
          </div>
          <div class="space-y-3">
            <div v-for="field in 4" :key="field" class="space-y-2">
              <div class="h-3 w-24 animate-pulse rounded-full bg-sand"></div>
              <div class="h-12 w-full animate-pulse rounded-2xl bg-neutral-bg"></div>
            </div>
          </div>
          <div class="h-12 w-full animate-pulse rounded-full bg-secondary/20"></div>
        </article>

        <article class="panel-clean space-y-3 bg-white p-6">
          <div class="h-3 w-24 animate-pulse rounded-full bg-sand"></div>
          <div
            v-for="invoice in 2"
            :key="invoice"
            class="flex items-center justify-between rounded-2xl border border-outline-variant p-5"
          >
            <div class="space-y-2">
              <div class="h-3.5 w-28 animate-pulse rounded-full bg-neutral-bg"></div>
              <div class="h-3 w-20 animate-pulse rounded-full bg-sand"></div>
            </div>
            <div class="flex items-center gap-4">
              <div class="h-8 w-20 animate-pulse rounded-full bg-sand"></div>
              <div class="h-8 w-8 animate-pulse rounded-full bg-neutral-bg"></div>
            </div>
          </div>
        </article>
      </div>
    </div>
  </div>
</template>

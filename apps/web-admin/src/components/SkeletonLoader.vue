<template>
  <div class="animate-pulse">
    <!-- Dashboard -->
    <template v-if="variant === 'dashboard'">
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-10">
        <div v-for="i in 4" :key="i" class="bg-white rounded-3xl border border-outline-variant/40 p-6 space-y-3">
          <div class="h-2.5 w-20 bg-sand rounded-full" />
          <div class="h-8 w-16 bg-sand rounded-lg" />
          <div class="h-2 w-24 bg-sand/60 rounded-full" />
        </div>
      </div>
      <div class="grid grid-cols-12 gap-8">
        <div class="col-span-12 lg:col-span-8 space-y-3">
          <div class="h-3 w-28 bg-sand rounded-full mb-4" />
          <div v-for="i in 4" :key="i" class="bg-white rounded-3xl border border-outline-variant/40 p-6 flex items-center gap-4">
            <div class="w-12 h-12 rounded-2xl bg-sand shrink-0" />
            <div class="flex-1 space-y-2">
              <div class="h-3.5 w-40 bg-sand rounded-full" />
              <div class="h-2.5 w-56 bg-sand/60 rounded-full" />
            </div>
            <div class="h-3 w-10 bg-sand rounded-full" />
          </div>
        </div>
        <div class="col-span-12 lg:col-span-4 space-y-4">
          <div class="h-3 w-20 bg-sand rounded-full mb-2" />
          <div v-for="i in 2" :key="i" class="bg-white rounded-3xl border border-outline-variant/40 p-6 space-y-2">
            <div class="h-3.5 w-28 bg-sand rounded-full" />
            <div class="h-2.5 w-20 bg-sand/60 rounded-full" />
          </div>
          <div class="bg-sand rounded-3xl border border-outline-variant/60 p-8 space-y-4">
            <div class="h-2.5 w-24 bg-cocoa/10 rounded-full" />
            <div class="h-8 w-12 bg-cocoa/10 rounded-lg" />
            <div class="h-8 w-full bg-cocoa/10 rounded-full" />
          </div>
        </div>
      </div>
    </template>

    <!-- Salon list -->
    <template v-else-if="variant === 'salon-list'">
      <div class="bg-white rounded-2xl border border-outline-variant/40 divide-y divide-outline-variant/20 overflow-hidden shadow-sm">
        <div v-for="i in 5" :key="i" class="p-5 flex items-center justify-between gap-8">
          <div class="flex-1 space-y-3">
            <div class="flex items-center gap-3">
              <div class="h-4 w-40 bg-sand rounded-full" />
              <div class="h-5 w-16 bg-sand/60 rounded-full" />
              <div class="h-5 w-14 bg-sand/60 rounded-full" />
            </div>
            <div class="flex items-center gap-6">
              <div class="h-3 w-16 bg-sand/60 rounded-full" />
              <div class="h-3 w-20 bg-sand/60 rounded-full" />
              <div class="h-3 w-32 bg-sand/60 rounded-full" />
            </div>
          </div>
          <div class="h-8 w-20 bg-sand rounded-full shrink-0" />
        </div>
      </div>
    </template>

    <!-- Salon detail -->
    <template v-else-if="variant === 'salon-detail'">
      <div class="bg-white rounded-3xl border border-outline-variant shadow-sm overflow-hidden">
        <div class="p-8 md:p-10 border-b border-outline-variant/30 flex flex-col md:flex-row md:items-center justify-between gap-8">
          <div class="space-y-4">
            <div class="flex items-center gap-3">
              <div class="h-8 w-52 bg-sand rounded-lg" />
              <div class="h-6 w-20 bg-sand/60 rounded-full" />
            </div>
            <div class="flex items-center gap-6">
              <div class="h-3 w-40 bg-sand/60 rounded-full" />
              <div class="h-3 w-24 bg-sand/60 rounded-full" />
            </div>
          </div>
          <div class="flex gap-2">
            <div class="h-10 w-28 bg-sand rounded-full" />
            <div class="h-10 w-28 bg-sand/60 rounded-full" />
            <div class="h-10 w-24 bg-sand/60 rounded-full" />
          </div>
        </div>
        <div class="p-8 bg-sand/30">
          <div class="h-3 w-full bg-sand/60 rounded-full mb-2" />
          <div class="h-3 w-3/4 bg-sand/60 rounded-full" />
        </div>
      </div>
      <div class="grid grid-cols-12 gap-8 mt-8">
        <div class="col-span-12 lg:col-span-7 space-y-4">
          <div class="h-3 w-28 bg-sand rounded-full" />
          <div v-for="i in 3" :key="i" class="bg-white rounded-2xl border border-outline-variant p-5 flex items-center justify-between">
            <div class="space-y-2">
              <div class="h-3.5 w-36 bg-sand rounded-full" />
              <div class="h-2.5 w-24 bg-sand/60 rounded-full" />
            </div>
            <div class="h-6 w-16 bg-sand/60 rounded-full" />
          </div>
        </div>
        <div class="col-span-12 lg:col-span-5 space-y-4">
          <div class="h-3 w-24 bg-sand rounded-full" />
          <div class="grid grid-cols-2 gap-3">
            <div v-for="i in 4" :key="i" class="aspect-[4/3] rounded-2xl bg-sand" />
          </div>
        </div>
      </div>
    </template>

    <!-- Subscription list -->
    <template v-else-if="variant === 'subscription-list'">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
        <div v-for="i in 3" :key="i" class="panel-clean p-5 bg-white space-y-2">
          <div class="h-2.5 w-16 bg-sand rounded-full" />
          <div class="h-7 w-12 bg-sand rounded-lg" />
        </div>
      </div>
      <div class="bg-white rounded-2xl border border-outline-variant overflow-hidden shadow-sm">
        <div class="overflow-x-auto">
          <table class="min-w-full">
            <thead>
              <tr class="border-b border-outline-variant/40 bg-neutral-bg/40">
                <th v-for="i in 6" :key="i" class="px-5 py-3">
                  <div class="h-2 w-16 bg-sand/60 rounded-full" />
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-outline-variant/20">
              <tr v-for="i in 6" :key="i">
                <td class="px-5 py-4"><div class="h-3.5 w-32 bg-sand rounded-full" /></td>
                <td class="px-5 py-4"><div class="h-5 w-16 bg-sand/60 rounded-full" /></td>
                <td class="px-5 py-4"><div class="h-5 w-14 bg-sand/60 rounded-full" /></td>
                <td class="px-5 py-4"><div class="h-3 w-16 bg-sand/60 rounded-full" /></td>
                <td class="px-5 py-4"><div class="h-3 w-20 bg-sand/60 rounded-full" /></td>
                <td class="px-5 py-4 text-right"><div class="h-7 w-16 bg-sand rounded-full ml-auto" /></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </template>

    <!-- Subscription detail -->
    <template v-else-if="variant === 'subscription-detail'">
      <div class="bg-white rounded-3xl border border-outline-variant shadow-sm overflow-hidden">
        <div class="p-8 md:p-10 border-b border-outline-variant/30 flex flex-col lg:flex-row lg:items-center justify-between gap-8">
          <div class="space-y-4">
            <div class="flex items-center gap-3">
              <div class="h-8 w-48 bg-sand rounded-lg" />
              <div class="h-6 w-16 bg-sand/60 rounded-full" />
              <div class="h-6 w-14 bg-sand/60 rounded-full" />
            </div>
            <div class="flex gap-6">
              <div class="h-3 w-32 bg-sand/60 rounded-full" />
              <div class="h-3 w-28 bg-sand/60 rounded-full" />
            </div>
          </div>
          <div class="grid grid-cols-3 gap-8 bg-sand/30 p-6 rounded-2xl border border-outline-variant/60">
            <div v-for="i in 3" :key="i" class="space-y-2">
              <div class="h-2 w-10 bg-sand/60 rounded-full" />
              <div class="h-3.5 w-16 bg-sand rounded-full" />
            </div>
          </div>
        </div>
      </div>
      <div class="grid grid-cols-12 gap-8 mt-8">
        <div class="col-span-12 lg:col-span-7 space-y-4">
          <div class="h-3 w-24 bg-sand rounded-full" />
          <div v-for="i in 4" :key="i" class="bg-white rounded-2xl border border-outline-variant p-5 flex items-center justify-between">
            <div class="space-y-2">
              <div class="h-3.5 w-36 bg-sand rounded-full" />
              <div class="h-2.5 w-24 bg-sand/60 rounded-full" />
            </div>
            <div class="h-6 w-14 bg-sand/60 rounded-full" />
          </div>
        </div>
        <div class="col-span-12 lg:col-span-5">
          <div class="bg-white rounded-3xl border border-outline-variant p-8 space-y-5">
            <div class="h-2.5 w-32 bg-sand rounded-full" />
            <div class="h-6 w-40 bg-sand rounded-lg" />
            <div class="h-11 w-full bg-sand/60 rounded-xl" />
            <div class="h-11 w-full bg-sand/60 rounded-xl" />
            <div class="h-11 w-full bg-sand/60 rounded-xl" />
            <div class="h-12 w-full bg-sand rounded-xl mt-2" />
          </div>
        </div>
      </div>
    </template>

    <!-- Audit list -->
    <template v-else-if="variant === 'audit-list'">
      <div class="space-y-3">
        <div v-for="i in 6" :key="i" class="bg-white p-5 rounded-2xl border border-outline-variant/40 shadow-sm">
          <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div class="space-y-2 flex-1">
              <div class="flex items-center gap-3">
                <div class="h-4 w-64 bg-sand rounded-full" />
                <div class="h-5 w-14 bg-sand/60 rounded-full" />
              </div>
              <div class="flex items-center gap-5">
                <div class="h-3 w-28 bg-sand/60 rounded-full" />
                <div class="h-3 w-24 bg-sand/60 rounded-full" />
                <div class="h-3 w-32 bg-sand/60 rounded-full" />
              </div>
            </div>
            <div class="h-8 w-24 bg-sand rounded-full shrink-0" />
          </div>
        </div>
      </div>
    </template>

    <!-- Audit detail -->
    <template v-else-if="variant === 'audit-detail'">
      <div class="bg-white rounded-3xl border border-outline-variant shadow-sm p-8 md:p-10 space-y-4">
        <div class="flex items-center gap-3 mb-4">
          <div class="h-8 w-72 bg-sand rounded-lg" />
          <div class="h-6 w-16 bg-sand/60 rounded-full" />
        </div>
        <div class="flex flex-wrap gap-5">
          <div class="h-3 w-36 bg-sand/60 rounded-full" />
          <div class="h-3 w-48 bg-sand/60 rounded-full" />
          <div class="h-3 w-32 bg-sand/60 rounded-full" />
          <div class="h-3 w-28 bg-sand/60 rounded-full" />
        </div>
      </div>
      <div class="grid gap-6 xl:grid-cols-[0.7fr_1.3fr] mt-6">
        <div class="panel-clean p-6 space-y-3">
          <div class="h-2.5 w-24 bg-sand rounded-full mb-4" />
          <div v-for="i in 2" :key="i" class="h-10 w-full bg-sand rounded-2xl" />
        </div>
        <div class="panel-clean p-6">
          <div class="h-2.5 w-16 bg-sand rounded-full mb-4" />
          <div class="h-48 w-full bg-espresso/10 rounded-2xl" />
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  variant:
    | "dashboard"
    | "salon-list"
    | "salon-detail"
    | "subscription-list"
    | "subscription-detail"
    | "audit-list"
    | "audit-detail";
}>();
</script>

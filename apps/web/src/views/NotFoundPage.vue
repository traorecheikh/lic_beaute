<template>
  <div class="min-h-screen bg-[#F3F1EE] flex items-center justify-center px-6">
    <div class="w-full max-w-md text-center">
      <div class="bg-white rounded-2xl border border-[#E0D8CE] shadow-lg p-12">
        <div class="text-[96px] font-bold text-[#D96B8C] leading-none mb-4">404</div>

        <div class="w-12 h-12 mx-auto mb-6 flex items-center justify-center bg-[#FCEEF2] rounded-full">
          <svg class="w-6 h-6 text-[#D96B8C]" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m9-.75a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 3.75h.008v.008H12v-.008Z" />
          </svg>
        </div>

        <h1 class="text-2xl font-bold text-[#2D1A12] mb-3">Page introuvable</h1>

        <p class="text-sm text-[#5C4A3A] leading-relaxed mb-10">
          La page que vous cherchez n'existe pas ou a été déplacée.<br />
          Vérifiez l'URL ou utilisez l'un des liens ci-dessous.
        </p>

        <div class="flex flex-col sm:flex-row gap-3 justify-center">
          <router-link to="/" class="inline-flex items-center justify-center gap-2 rounded-full bg-[#D96B8C] text-white px-8 py-3 text-xs font-bold uppercase tracking-widest hover:bg-[#C45A7A] transition-all">
            <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12l8.954-8.955a1.126 1.126 0 0 1 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25" />
            </svg>
            Accueil
          </router-link>
          <router-link to="/pro/login" class="inline-flex items-center justify-center gap-2 rounded-full bg-white text-[#2D1A12] border border-[#E0D8CE] px-8 py-3 text-xs font-bold uppercase tracking-widest hover:bg-[#F9F5F0] transition-all">
            <svg class="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0 0 13.5 3h-6a2.25 2.25 0 0 0-2.25 2.25v13.5A2.25 2.25 0 0 0 7.5 21h6a2.25 2.25 0 0 0 2.25-2.25V15m3 0 3-3m0 0-3-3m3 3H9" />
            </svg>
            Espace Pro
          </router-link>
        </div>
      </div>

      <p class="mt-8 text-[10px] text-[#8A7A6A] font-semibold uppercase tracking-widest">Beauté Avenue</p>
    </div>
  </div>
</template>

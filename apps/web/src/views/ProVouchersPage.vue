<template>
  <div>
    <div class="mb-8 flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div>
        <h1 class="page-title mb-2">Codes Promo</h1>
        <p class="text-cocoa/60">Créez et gérez vos codes de réduction clients.</p>
      </div>
      <button @click="showForm = !showForm" class="btn-primary px-6 py-3 text-sm">
        <PlusIcon class="w-4 h-4 mr-2 inline-block" />
        Nouveau code
      </button>
    </div>

    <!-- Create Form -->
    <Transition
      enter-active-class="transition duration-200 ease-out"
      enter-from-class="opacity-0 -translate-y-2"
      enter-to-class="opacity-100 translate-y-0"
      leave-active-class="transition duration-150 ease-in"
      leave-from-class="opacity-100 translate-y-0"
      leave-to-class="opacity-0 -translate-y-2"
    >
      <div v-if="showForm" class="panel-clean p-8 mb-8">
        <h2 class="entity-title mb-6">Créer un code promo</h2>
        <form @submit.prevent="submitVoucher" class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <label class="section-label block mb-2">Code *</label>
            <input
              v-model="form.code"
              type="text"
              class="input-shell uppercase"
              placeholder="EX: SUMMER25"
              required
              style="letter-spacing: 0.1em"
            />
            <p class="text-[11px] text-cocoa/40 mt-1">Majuscules, sans espaces.</p>
          </div>
          <div>
            <label class="section-label block mb-2">Titre *</label>
            <input v-model="form.title" type="text" class="input-shell" placeholder="Réduction de bienvenue" required />
          </div>
          <div>
            <label class="section-label block mb-2">Libellé de réduction *</label>
            <input v-model="form.discountLabel" type="text" class="input-shell" placeholder="-10% ou 2 500 XOF" required />
            <p class="text-[11px] text-cocoa/40 mt-1">Texte affiché sur le bon. Ex: -10%, 2 500 XOF</p>
          </div>
          <div>
            <label class="section-label block mb-2">Description</label>
            <input v-model="form.description" type="text" class="input-shell" placeholder="Valable sur votre prochaine réservation" />
          </div>
          <div>
            <label class="section-label block mb-2">Date d'expiration</label>
            <input v-model="form.expiresAt" type="date" class="input-shell" :min="todayIso" />
          </div>
          <div>
            <label class="section-label block mb-2">Utilisations max</label>
            <input v-model.number="form.maxRedemptions" type="number" class="input-shell" placeholder="Illimité" min="1" />
          </div>

          <div class="md:col-span-2 flex items-center justify-end gap-3 pt-2 border-t border-outline-variant/30">
            <button type="button" @click="cancelForm" class="btn-secondary px-6 py-3 text-sm">Annuler</button>
            <button type="submit" :disabled="submitting" class="btn-primary px-8 py-3 text-sm">
              <span v-if="submitting">Création…</span>
              <span v-else>Créer le code</span>
            </button>
          </div>
        </form>
        <p v-if="formError" class="text-error row-meta mt-4">{{ formError }}</p>
      </div>
    </Transition>

    <!-- Voucher list -->
    <div class="panel-clean overflow-hidden">
      <div v-if="vouchers.length === 0 && !showForm" class="flex flex-col items-center justify-center py-20 text-center">
        <TicketIcon class="w-12 h-12 text-cocoa/20 mb-4" />
        <p class="row-primary mb-1">Aucun code promo</p>
        <p class="row-meta max-w-xs">Créez un premier code pour offrir des réductions à vos clients.</p>
      </div>
      <table v-else-if="vouchers.length > 0" class="w-full text-left border-collapse">
        <thead>
          <tr class="bg-neutral-bg/50">
            <th class="px-6 py-4 section-label">Code</th>
            <th class="px-6 py-4 section-label">Titre</th>
            <th class="px-6 py-4 section-label">Réduction</th>
            <th class="px-6 py-4 section-label text-center">Utilisations</th>
            <th class="px-6 py-4 section-label">Expire</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/30">
          <tr v-for="v in vouchers" :key="v.id" class="hover:bg-neutral-bg/20 transition-colors">
            <td class="px-6 py-4">
              <span class="font-mono font-bold text-[13px] tracking-wider text-espresso">{{ v.code }}</span>
            </td>
            <td class="px-6 py-4 row-primary">{{ v.title }}</td>
            <td class="px-6 py-4">
              <span class="inline-flex items-center px-2.5 py-1 rounded-full text-[11px] font-semibold bg-primary/10 text-primary">
                {{ v.discountLabel }}
              </span>
            </td>
            <td class="px-6 py-4 text-center row-meta">
              {{ v.maxRedemptions != null ? v.maxRedemptions : '∞' }}
            </td>
            <td class="px-6 py-4 row-meta">
              {{ v.expiresAt ? formatDate(v.expiresAt) : 'Sans limite' }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from "vue";
import { proVoucherCreateSchema } from "@beauteavenue/contracts";
import { validateForm } from "@beauteavenue/shared-ts";
import { PlusIcon, TicketIcon } from "@heroicons/vue/24/outline";
import dayjs from "dayjs";
import { createProVoucher } from "@/lib/pro-api";
import { useProAuthStore } from "@/stores/proAuth";

const auth = useProAuthStore();

interface VoucherRow {
  id: string;
  code: string;
  title: string;
  discountLabel: string;
  description: string | null;
  expiresAt: string | null;
  maxRedemptions: number | null;
}

const vouchers = ref<VoucherRow[]>([]);
const showForm = ref(false);
const submitting = ref(false);
const formError = ref<string | null>(null);

const todayIso = computed(() => dayjs().format("YYYY-MM-DD"));

const form = ref({
  code: "",
  title: "",
  discountLabel: "",
  description: "",
  expiresAt: "",
  maxRedemptions: null as number | null
});

function cancelForm() {
  showForm.value = false;
  resetForm();
}

function resetForm() {
  form.value = { code: "", title: "", discountLabel: "", description: "", expiresAt: "", maxRedemptions: null };
  formError.value = null;
}

async function submitVoucher() {
  if (!auth.accessToken) return;
  formError.value = null;
  const result = validateForm(proVoucherCreateSchema, {
    code: form.value.code.trim().toUpperCase(),
    title: form.value.title.trim(),
    discountLabel: form.value.discountLabel.trim(),
    description: form.value.description.trim() || null,
    expiresAt: form.value.expiresAt ? new Date(form.value.expiresAt).toISOString() : null,
    maxRedemptions: form.value.maxRedemptions ?? null
  });
  if (!result.success) {
    const firstError = Object.values(result.errors)[0];
    formError.value = firstError ?? "Vérifiez les champs.";
    return;
  }
  submitting.value = true;
  try {
    const apiResult = await createProVoucher(auth.accessToken, {
      code: form.value.code.trim().toUpperCase(),
      title: form.value.title.trim(),
      discountLabel: form.value.discountLabel.trim(),
      description: form.value.description.trim() || null,
      expiresAt: form.value.expiresAt ? new Date(form.value.expiresAt) : null,
      maxRedemptions: form.value.maxRedemptions ?? null
    });
    vouchers.value.unshift({
      id: apiResult.id,
      code: apiResult.code,
      title: apiResult.title,
      discountLabel: apiResult.discountLabel,
      description: apiResult.description ?? null,
      expiresAt: apiResult.expiresAt ?? null,
      maxRedemptions: apiResult.maxRedemptions ?? null
    });
    showForm.value = false;
    resetForm();
  } catch (err: unknown) {
    const msg = err instanceof Error ? err.message : "Impossible de créer le code.";
    formError.value = msg;
  } finally {
    submitting.value = false;
  }
}

function formatDate(iso: string) {
  return dayjs(iso).format("DD/MM/YYYY");
}
</script>

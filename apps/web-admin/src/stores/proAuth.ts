import { defineStore } from "pinia";
import { ref, computed } from "vue";

export interface ProUser {
  id: string;
  email: string;
  fullName: string;
  role: "salon_owner" | "salon_staff";
  salonId: string;
  salonName: string;
}

export const useProAuthStore = defineStore("proAuth", () => {
  const currentUser = ref<ProUser | null>(null);
  const initialized = ref(false);

  const isAuthenticated = computed(() => !!currentUser.value);
  const isOwner = computed(() => currentUser.value?.role === "salon_owner");

  async function restoreSession() {
    // Mock session restoration
    const savedUser = localStorage.getItem("pro_user");
    if (savedUser) {
      currentUser.value = JSON.parse(savedUser);
    }
    initialized.value = true;
  }

  async function login(role: "salon_owner" | "salon_staff" = "salon_owner") {
    const mockUser: ProUser = {
      id: "pro-1",
      email: role === "salon_owner" ? "owner@example.com" : "staff@example.com",
      fullName: role === "salon_owner" ? "Marie Diop" : "Jean Faye",
      role,
      salonId: "salon-1",
      salonName: "Beauté Divine"
    };
    currentUser.value = mockUser;
    localStorage.setItem("pro_user", JSON.stringify(mockUser));
  }

  async function logout() {
    currentUser.value = null;
    localStorage.removeItem("pro_user");
  }

  return {
    currentUser,
    initialized,
    isAuthenticated,
    isOwner,
    restoreSession,
    login,
    logout
  };
});

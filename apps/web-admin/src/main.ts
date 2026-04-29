import { createApp } from "vue";
import { VueQueryPlugin, QueryClient } from "@tanstack/vue-query";
import { createPinia } from "pinia";
import piniaPluginPersistedstate from "pinia-plugin-persistedstate";

import App from "./App.vue";
import router from "./router";
import { shouldRetryAdminQuery } from "./lib/query";
import { useAdminAuthStore } from "./stores/adminAuth";
import "./styles.css";

async function bootstrap() {
  const app = createApp(App);
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: {
        retry: shouldRetryAdminQuery,
        retryDelay: 500,
        staleTime: 30_000,
        refetchOnWindowFocus: false
      }
    }
  });
  const pinia = createPinia();

  pinia.use(piniaPluginPersistedstate);
  app.use(pinia);
  await useAdminAuthStore(pinia).restoreSession();
  app.use(router);
  app.use(VueQueryPlugin, { queryClient });
  app.mount("#app");
}

void bootstrap();

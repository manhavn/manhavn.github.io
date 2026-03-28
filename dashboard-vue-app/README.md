# Vue 3 + TypeScript + Vite

1 - Create UI

```shell
npm i -g bun
bun create vite --template vue-ts my-vue-app

cd my-vue-app
bun i -f

git init --initial-branch=main
git config user.name vite
git config user.email vite@setup.md

bun add --dev husky prettier
bunx husky init
echo '# .husky/pre-commit
prettier $(git diff --cached --name-only --diff-filter=ACMR | sed '"'s| |\\\\ |g'"') --write --ignore-unknown
git update-index --again' | tee .husky/pre-commit

echo 'bun.lock' >> .gitignore
git add .
git commit -m "Keep calm and commit"
```

2 - Add config basicSsl `vite.config.ts`

```ts
/* eslint-disable @typescript-eslint/ban-ts-comment */
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import path from "path";
import basicSsl from "@vitejs/plugin-basic-ssl";

const server = "http://server.api:8080";
const files = "http://server.api:8080";

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue({
      template: {
        compilerOptions: {
          isCustomElement: (tag) =>
            ["ui-", "s-"].some((prefix) => tag.startsWith(prefix)),
        },
      },
    }),
    basicSsl(),
  ],
  resolve: {
    tsconfigPaths: true,
    alias: {
      "@res": path.resolve(__dirname, "res"),
      "@src": path.resolve(__dirname, "src"),
      "@assets": path.resolve(__dirname, "src/assets"),
      "@components": path.resolve(__dirname, "src/components"),
    },
  },
  server: {
    // @ts-expect-error
    https: true,
    // port: 443, // default port: 5173
    proxy: { "/server/": server, "/files/": files },
  },
});

// if using port 443
// sudo setcap 'cap_net_bind_service=+ep' $(which node) # ubuntu
// prettier config: **/*.{js,ts,jsx,tsx,cjs,cts,mjs,mts,json,vue,astro,html,md}
```

3 - Add package `@vitejs/plugin-basic-ssl`

```shell
bun i -D @vitejs/plugin-basic-ssl
```

4 - Add config `index.html`: shopify-api-key, app-bridge, polaris

```html
<head>
  ...
  <meta name="shopify-api-key" content="fbc72a9f43e4c56cd441b8011462cf6b" />
  <script src="https://cdn.shopify.com/shopifycloud/app-bridge.js"></script>
</head>
```

5 - Edit: `src/App.vue`

```vue
<script setup lang="ts">
import HelloWorld from "@components/HelloWorld.vue";
</script>

<template>
  <HelloWorld />
</template>
```

6 - Add Config ui-save-bar: `src/components/HelloWorld.vue`

```vue
<script setup lang="ts">
import { ref } from "vue";
import viteLogo from "@assets/vite.svg";
import heroImg from "@assets/hero.png";
import vueLogo from "@assets/vue.svg";

const sleep = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));
const shopify = (window as any).shopify || {
  toast: {
    show: () => {},
    hide: () => {},
  },
};

const inputValue = ref("");

const mySaveBar = ref();
const hasUnsavedChanges = ref<boolean>(false);

const handleFieldInput = (e: any) => {
  inputValue.value = e.currentTarget?.value || "";

  shopify.toast.hide();
  if (!hasUnsavedChanges.value) {
    hasUnsavedChanges.value = true;
    mySaveBar.value.show();
  }
};

const handleDiscard = (e: Event) => {
  e.preventDefault();
  inputValue.value = "";

  hasUnsavedChanges.value = false;
  mySaveBar.value.hide();
  shopify.toast.hide();
};

const handleSave = async (e: Event) => {
  e.preventDefault();
  // Save to your backend
  await sleep(100);
  shopify.toast.show("Successfully saved!");

  hasUnsavedChanges.value = false;
  mySaveBar.value.hide();
};
</script>

<template>
  <ui-save-bar ref="mySaveBar">
    <button variant="primary" v-on:click="handleSave"></button>
    <button v-on:click="handleDiscard"></button>
  </ui-save-bar>

  <div class="ticks"></div>

  <section id="center">
    <div class="hero">
      <img :src="heroImg" class="base" width="170" height="179" alt="" />
      <img :src="vueLogo" class="framework" alt="Vue logo" />
      <img :src="viteLogo" class="vite" alt="Vite logo" />
    </div>

    <form v-on:submit="handleSave" v-on:reset="handleDiscard">
      <div class="hero">
        <label>
          Name:
          <input :value="inputValue" v-on:input="handleFieldInput" />
        </label>
      </div>

      <div class="hero">
        <button type="submit" class="counter">Submit</button>
        <button type="reset" class="counter">Reset</button>
      </div>
    </form>
  </section>

  <div class="ticks"></div>
</template>
```

7 - Commit app config

```shell
git config user.name myapp
git config user.email myapp@shopify.app

git add .
git commit -m "Add config ssl, shopify-api-key, app-bridge, ui-save-bar"
```

8 - Run `bun dev`:

- Open url from browser: https://localhost:5173/?shop=my-store.myshopify.com
- And accept: Advanced > Proceed to localhost (unsafe)

---

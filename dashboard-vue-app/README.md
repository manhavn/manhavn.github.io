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
  plugins: [vue(), basicSsl()],
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
  <script src="https://cdn.shopify.com/shopifycloud/polaris.js"></script>
</head>
```

5 - Commit app config

```shell
git config user.name myapp
git config user.email myapp@shopify.app

git add .
git commit -m "Add config ssl, shopify-api-key, app-bridge, polaris"
```

6 - Run `bun dev`:

- Open url from browser: https://localhost:5173/?shop=my-store.myshopify.com
- And accept: Advanced > Proceed to localhost (unsafe)

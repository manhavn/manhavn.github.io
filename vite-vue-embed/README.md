# Create project

```shell
npm i -g bun
bun create vite my-vue-app --template vue
cd my-vue-app
bun i
bun dev

git init
git config user.name vite
git config user.email vite@setup.md
git add .
git commit -m "init"

bun add --dev husky
bunx husky init

echo '# .husky/pre-commit
prettier $(git diff --cached --name-only --diff-filter=ACMR | sed '"'s| |\\\\ |g'"') --write --ignore-unknown
git update-index --again' | tee .husky/pre-commit

bun i crypto vue
bun i -D prettier
bun i -D vite @vitejs/plugin-basic-ssl @vitejs/plugin-vue @vitejs/plugin-vue-jsx
bun i -D cross-env dotenv dotenv-webpack
bun i -D esbuild-loader
bun i -D webpack webpack-cli webpack-merge
```

---

# File and Folder

- .../my-vue-app/vite.config.js

```javascript
import { fileURLToPath, URL } from "node:url";

import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import vueJsx from "@vitejs/plugin-vue-jsx";
import basicSsl from "@vitejs/plugin-basic-ssl";
import crypto from "crypto";

const salt1 = crypto.randomBytes(4).toString("hex");
const salt2 = crypto.randomBytes(4).toString("hex");
const salt3 = crypto.randomBytes(4).toString("hex");
const random = 12 - Math.floor(Math.random() * 4);

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue(), vueJsx(), basicSsl()],
  server: {
    https: true,
    host: true,
    port: 8080,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "*",
    },
  },
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
  build: {
    assetsInlineLimit: 0,
    manifest: true,
    cssCodeSplit: true,
    rollupOptions: {
      input: {
        main: "src/main.js",
      },
      output: {
        entryFileNames: "[hash].js",
        chunkFileNames: "[hash].js",
        assetFileNames: `${salt1.slice(0, 1)}[hash:${random}]${salt2.slice(0, 5 - Math.floor(Math.random() * 4))}.[ext]`,
      },
    },
  },
  css: {
    modules: {
      generateScopedName(name, filename, _css) {
        const hash = crypto
          .createHash("sha256")
          .update(salt3 + filename + name)
          .digest("base64")
          .replace(/[^a-zA-Z0-9]/g, "")
          .slice(0, 8);
        const allChar = hash.match(/[A-z]+/g)?.join("") || "_";
        return `${allChar.substring(allChar.length - 1)}${hash}`;
      },
    },
  },
});
```

- .../my-vue-app/package.json

```json
{
  ...
  //"type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "clean": "rm -rf dist/*",
    "prettier": "prettier --write \"{**/*,*}.{js,ts,jsx,tsx,css,scss,sass,html,htm,json,md,vue,cjs}\"",
    "eb-run-dev": "bun clean && webpack --config webpack/embed.dev.js && VITE_CJS_IGNORE_WARNING=true vite",
    "eb-run-staging": "bun run clean && cross-env WEBPACK_SET_ENV=staging webpack --config webpack/embed.dev.js && vite --mode staging",
    "eb-run-prod": "bun clean && WEBPACK_SET_ENV=production webpack --config webpack/embed.dev.js && VITE_CJS_IGNORE_WARNING=true vite --mode production",
    "eb-build-dev": "vite build --mode development && WEBPACK_SET_ENV=development webpack --config webpack/embed.prod.js && node improve.js",
    "eb-build-staging": "vite build --mode staging && cross-env WEBPACK_SET_ENV=staging webpack --config webpack/embed.prod.js && node improve.js",
    "eb-build-prod": "vite build && WEBPACK_SET_ENV=production webpack --config webpack/embed.prod.js && node improve.js",
    "deploy": "firebase deploy",
    "prepare": "husky"
  },
  ...
}
```

- .../my-vue-app/index.html

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Vite + Vue</title>
  </head>
  <body>
    <!-- <div id="app"></div> -->
    <script type="module" src="/src/main.js"></script>
  </body>
</html>
```

- .../my-vue-app/.env.development

```env
VITE_SDK_NAME=sdk.myApp.development
VITE_SDK_ENV=development
VITE_SDK_EMBED_NAME=test-app-embed.js
VITE_SDK_APP_ID=myApp-instance
VITE_SDK_APP_VERSION=v0.0.1

VITE_SDK_DEMO=demo
VITE_SDK_SRC_MAIN_JS=src/main.js
```

- .../my-vue-app/.env.production

```env
VITE_SDK_NAME=sdk.myApp
VITE_SDK_ENV=production
VITE_SDK_EMBED_NAME=test-app-embed.js
VITE_SDK_APP_ID=myApp-instance
VITE_SDK_APP_VERSION=v0.0.1

VITE_SDK_DEMO=demo
VITE_SDK_SRC_MAIN_JS=src/main.js
```

- .../my-vue-app/.env.staging

```env
VITE_SDK_NAME=sdk.myApp.staging
VITE_SDK_ENV=staging
VITE_SDK_EMBED_NAME=test-app-embed.js
VITE_SDK_APP_ID=myApp-instance
VITE_SDK_APP_VERSION=v0.0.1

VITE_SDK_DEMO=demo
VITE_SDK_SRC_MAIN_JS=src/main.js
```

- .../my-vue-app/src/embed.dev.js

```javascript
/* eslint-disable no-undef */

const id = process.env.VITE_SDK_NAME;
const srcMainJs = process.env.VITE_SDK_SRC_MAIN_JS;
const mainElement = document.getElementById(id);
if (mainElement === null || !mainElement) {
  const scriptManifest = document.createElement("script");
  scriptManifest.id = id;
  scriptManifest.type = "module";
  scriptManifest.src = `${new URL(document.currentScript.src).origin}/${srcMainJs}`;

  const regexMobileUserAgent =
    /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini|Windows Phone|Phone/i;
  if (regexMobileUserAgent.test(navigator.userAgent)) {
    setTimeout(function () {
      document.head.appendChild(scriptManifest);
    }, 1500);
  } else {
    document.head.appendChild(scriptManifest);
  }
}
```

- .../my-vue-app/src/embed.js

```javascript
/* eslint-disable no-undef */
// noinspection JSFileReferences

import manifest from "../dist/.vite/manifest.json";

const id = process.env.VITE_SDK_NAME;
const mainElement = document.getElementById(id);
if (mainElement === null || !mainElement) {
  const scriptManifest = document.createElement("script");
  scriptManifest.id = id;
  scriptManifest.type = "module";

  const { src } = document.currentScript;
  const search = new URL(src).search;
  const embedName = process.env.VITE_SDK_EMBED_NAME;
  const mainName = manifest["src/main.js"].file;
  scriptManifest.src = src.replace(embedName, mainName).replace(search, "");

  const regexMobileUserAgent =
    /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini|Windows Phone|Phone/i;
  if (regexMobileUserAgent.test(navigator.userAgent)) {
    setTimeout(function () {
      document.head.appendChild(scriptManifest);
    }, 1500);
  } else {
    document.head.appendChild(scriptManifest);
  }
}
```

- .../my-vue-app/src/main.js

```javascript
import { createApp } from "vue";
import App from "./App.vue";

if (import.meta.env.DEV) console.clear();

createApp(App).mount(document.createElement("div"));
```

- .../my-vue-app/src/App.vue

```vue
<!--suppress JSUnresolvedReference -->
<script setup>
import { onMounted } from "vue";

onMounted(() => {
  console.log("Hello World!");
});
</script>

<template>
  <teleport to="html">
    <div :class="[$style['hello']]">Hello World!</div>
  </teleport>
</template>

<style module>
.hello {
  color: gray;
  text-decoration: none;
}

.hello:hover {
  color: aqua;
  text-decoration: underline;
}
</style>
```

- .../my-vue-app/webpack/embed.dev.js

```javascript
const { merge } = require("webpack-merge");
const Dotenv = require("dotenv-webpack");

const dotConfig = { path: "./.env.development" };

switch (process.env.WEBPACK_SET_ENV) {
  case "production":
    dotConfig.path = "./.env.production";
    break;
  case "staging":
    dotConfig.path = "./.env.staging";
    break;
  default:
    dotConfig.path = "./.env.development";
    break;
}

require("dotenv").config(dotConfig);

const chunkLoadingGlobal = process.env.VITE_SDK_NAME?.toString() + "-embed-dev";
const filename = process.env.VITE_SDK_EMBED_NAME?.toString() || "embed.js";

module.exports = merge(require("./webpack.app.js"), {
  entry: "./src/embed.dev.js",
  mode: "development",
  devtool: "inline-source-map",
  output: {
    filename,
    chunkLoadingGlobal,
  },
  plugins: [new Dotenv(dotConfig)],
});
```

- .../my-vue-app/webpack/embed.prod.js

```javascript
const { merge } = require("webpack-merge");
const Dotenv = require("dotenv-webpack");

const dotConfig = { path: "./.env.development" };

switch (process.env.WEBPACK_SET_ENV) {
  case "production":
    dotConfig.path = "./.env.production";
    break;
  case "staging":
    dotConfig.path = "./.env.staging";
    break;
  default:
    dotConfig.path = "./.env.development";
    break;
}

require("dotenv").config(dotConfig);

const chunkLoadingGlobal = process.env.VITE_SDK_NAME?.toString() + "-embed";
const filename = process.env.VITE_SDK_EMBED_NAME?.toString() || "embed.js";

module.exports = merge(require("./webpack.app.js"), {
  entry: "./src/embed.js",
  mode: "production",
  devtool: false,
  output: {
    filename,
    chunkLoadingGlobal,
  },
  plugins: [new Dotenv(dotConfig)],
});
```

- .../my-vue-app/webpack/webpack.app.js

```javascript
const path = require("path");
const { DefinePlugin } = require("webpack");

module.exports = {
  output: {
    path: path.join(__dirname, "../dist"),
    publicPath: "/",
  },
  resolve: {
    alias: {
      "@": path.join(__dirname, "../src"),
    },
    extensions: ["", ".ts", ".tsx", ".js", ".jsx", ".vue", ".json"],
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "esbuild-loader",
        options: {
          loader: "jsx",
        },
      },
    ],
  },
  plugins: [
    new DefinePlugin({
      __VUE_OPTIONS_API__: false,
      __VUE_PROD_DEVTOOLS__: false,
    }),
  ],
};
```

- .../my-vue-app/build-deploy.js

```javascript
import { exec } from "node:child_process";
import { promisify } from "node:util";
import fs from "node:fs";

const execAsync = promisify(exec);

async function main() {
  const scriptName = process.argv[2];
  if (!scriptName) {
    return;
  }
  console.log(`Start build ${scriptName}...`);
  const { stdoutCms, stderrCms } = await execAsync(`npm run ${scriptName}`);
  if (stdoutCms) console.log(stdoutCms);
  if (stderrCms) console.error(stderrCms);
  console.log(`Finished build ${scriptName}!`);

  const deployFolder = process.argv[3];
  if (!deployFolder) {
    return;
  }
  console.log(`Start remove ${deployFolder} theme-extension/assets...`);
  try {
    fs.rmSync(`${deployFolder}/extensions/theme-extension/assets`, {
      recursive: true,
      force: true,
    });
  } catch {}
  console.log(`Finished remove ${deployFolder} theme-extension/assets!`);

  console.log(`Start copy dist to ${deployFolder} theme-extension/assets...`);
  try {
    fs.cpSync("dist", `${deployFolder}/extensions/theme-extension/assets`, {
      recursive: true,
      force: true,
    });
  } catch {}
  console.log(`Finished copy dist to ${deployFolder} theme-extension/assets!`);

  console.log("Begin deploy...");
}

main().catch(console.error);

// const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
// node build-deploy.js eb-build-dev

/*
    node build-deploy.js eb-build-dev
*/

/*
    node build-deploy.js eb-build-staging staging-myapp
    cd staging-myapp
    npm i
    npm i -g shopify
    shopify app deploy
    cd ..
*/

/*
    node build-deploy.js eb-build-prod prod-myapp
    cd prod-myapp
    npm i
    npm i -g shopify
    shopify app deploy
    cd ..
*/
```

- .../my-vue-app/improve.js

```javascript
import fs from "node:fs";

async function main() {
  console.log("Begin improve main.[build].js ...");
  const manifest = fs.readFileSync("dist/.vite/manifest.json", {
    encoding: "utf-8",
  });
  const manifestJson = JSON.parse(manifest);
  const mainBuildPath = `dist/${manifestJson["src/main.js"]?.file}`;
  let mainContent = fs.readFileSync(mainBuildPath, {
    encoding: "utf-8",
  });
  mainContent = mainContent.replace(
    /=function\(([A-z0-9]+)\){return"\/"\+\1},/g,
    '=function(e){const mU=new URL(import.meta.url);return(mU.origin+mU.pathname.replace(/\\/([^/]+)?.js/i,""))+"/"+e},',
  );
  fs.writeFileSync(mainBuildPath, mainContent);
  console.log("Remove dist/.vite/manifest.json");
  try {
    fs.rmSync("dist/.vite", { recursive: true, force: true });
  } catch {}
  console.log("Finished improve main.[build].js !");
}

main().catch(console.error);

// const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
// node improve.js

// dist/.vite/manifest.json
// =function(e){return"/"+e},
// =function\(([A-z0-9]+)\){return"\/"\+\1},
// =function\(([A-z0-9]+)\){return"\/"\+([A-z0-9]+)},
// =function(e){const mU=new URL(import.meta.url);return(mU.origin+mU.pathname.replace(/\/([^/]+)?.js/i,""))+"/"+e},
```

- .../my-vue-app/embed.sh

```shell
#!/bin/bash
# shellcheck disable=SC2164
cd "$(dirname "$0")"

if [ -s $1 ]; then
  echo "have no env param: dev, staging, prod"
  exit 1
else
  case "$1" in
  "dev")
    node build-deploy.js eb-build-dev
    ;;
  "staging")
    node build-deploy.js eb-build-staging staging-myapp
    cd staging-myapp
    shopify app deploy
    cd ..
    ;;
  "prod")
    node build-deploy.js eb-build-prod brand-myapp-salespop
    cd brand-myapp-salespop
    shopify app deploy
    cd ..
    ;;
  *)
    echo "default env"
    exit 1
    ;;
  esac
fi
```

- .../my-vue-app/deploy.sh

```shell
#!/bin/bash
# shellcheck disable=SC2164
cd "$(dirname "$0")"

if [ -s $1 ]; then
  echo "have no env param: dev, staging, prod"
  exit 1
else
  case "$1" in
  "dev")
    node build-deploy.js eb-build-dev
    ;;
  "staging")
    node build-deploy.js eb-build-staging staging-myapp
    cd staging-myapp
    npm i
    npm i -g shopify
    shopify app deploy
    cd ..
    ;;
  "prod")
    node build-deploy.js eb-build-prod brand-myapp-salespop
    cd brand-myapp-salespop
    npm i
    npm i -g shopify
    shopify app deploy
    cd ..
    ;;
  *)
    echo "default env"
    exit 1
    ;;
  esac
fi
```

---

## Run EMBED

```shell
bun prettier

bun eb-run-dev
bun eb-run-staging
bun eb-run-prod
```

## DEBUG EMBED

```javascript
var script = document.createElement("script");
script.src = "https://localhost:8080/dist/test-app-embed.js";
document.head.appendChild(script);
```

## Build Production

```shell
bun prettier

bun eb-build-dev
bun eb-build-staging
bun eb-build-prod
```

## Shopify Deploy

```shell
npm install -g @shopify/cli@latest
shopify app init

cd staging-myapp
shopify app generate extension

rm -rf extensions/theme-extension/**/*
curl -fsSL https://manhavn.github.io/vite-vue-embed/app-embed.liquid | tee extensions/theme-extension/blocks/app-embed.liquid

cd ..
bun prettier

sh deploy.sh staging
sh deploy.sh prod

sh embed.sh staging
sh embed.sh prod
```

## Firebase Deploy

```shell
npm install -g firebase-tools
firebase login
firebase init
firebase init hosting
#✔ What do you want to use as your public directory? dist
#✔ Configure as a single-page app (rewrite all urls to /index.html)? Yes
#✔ Set up automatic builds and deploys with GitHub? No
#✔  Wrote dist/index.html
bun eb-build-prod
firebase deploy
```

```javascript
var script = document.createElement("script");
script.src = "/test-app-embed.js";
document.head.appendChild(script);
```

---

## Git Finish

```shell
bun prettier

git add .
git commit -m "Finish"
```

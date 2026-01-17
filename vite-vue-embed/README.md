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

bun i -D prettier
bun i -D @vitejs/plugin-vue-jsx # "^4.2.0",
bun i -D @vitejs/plugin-basic-ssl # "^2.0.0",
bun i -D dotenv # "^16.5.0",
bun i -D dotenv-webpack # "^8.1.0",
bun i -D esbuild-loader # "^4.3.0",
bun i -D webpack # "^5.99.9",
bun i -D webpack-cli # "^6.0.1",
bun i -D webpack-merge # "^6.0.1"
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
        entryFileNames: "[name].[hash].js",
        chunkFileNames: "build.[name].[hash].js",
        assetFileNames: "build.[name].[hash].[ext]",
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
    ...
    "clean": "rm -rf dist/*",
    "prettier": "prettier --write \"{**/*,*}.{js,ts,jsx,tsx,css,scss,sass,html,htm,json,md,vue,cjs}\"",
    "eb-run-dev": "bun clean && webpack --config webpack/embed.dev.js && VITE_CJS_IGNORE_WARNING=true vite",
    "eb-run-prod": "bun clean && WEBPACK_SET_ENV=production webpack --config webpack/embed.dev.js && VITE_CJS_IGNORE_WARNING=true vite --mode production",
    "eb-build-dev": "vite build --mode development && WEBPACK_SET_ENV=development webpack --config webpack/embed.prod.js && sh improve.sh",
    "eb-build-prod": "vite build && WEBPACK_SET_ENV=production webpack --config webpack/embed.prod.js && sh improve.sh",
    "deploy": "firebase deploy"
  },
  ...
}
```

- .../my-vue-app/index.html

```html
...
<!-- <div id="app"></div> -->
...
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

const container = document.createElement("div");
document.body.appendChild(container);

createApp(App).mount(container);
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

- .../my-vue-app/improve.sh

```shell
#!/bin/bash
# shellcheck disable=SC2164
cd "$(dirname "$0")"

rm -rf dist/.vite dist/*.LICENSE.txt dist/*.ico dist/index.html

# LINUX
sed -i 's/=function(\([A-Za-z0-9]\+\)){return"\/"+\1},/=function(e){const mU=new URL(import.meta.url);return(mU.origin+mU.pathname.replace(\/\\\/([^\/]+)?.js\/i,""))+"\/"+e},/g' dist/*.js

# MACOS
# sed -i '' 's/=function(\([A-Za-z0-9]\+\)){return"\/"+\1},/=function(e){const mU=new URL(import.meta.url);return(mU.origin+mU.pathname.replace(\/\\\/([^\/]+)?.js\/i,""))+"\/"+e},/g' "$(ls dist/main*.js)"

# MACOS
# sed -i '' 's/=function([A-z]){return"\/"\+[A-z]},/=function(e){const mU=new URL(import.meta.url);return(mU.origin+mU.pathname.replace(\/\\\/([^\/]+)?.js\/i,""))+"\/"+e},/g' "$(ls dist/main*.js)"

```

---

## Run EMBED

```shell
bun prettier

bun eb-run-dev
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
bun eb-build-prod
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

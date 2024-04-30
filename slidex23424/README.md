# slidex23424

- [slidex23424](https://manhavn.github.io/slidex23424)
- [demo html](https://manhavn.github.io/slidex23424/html)
- [demo reactjs](https://manhavn.github.io/slidex23424/reactjs)
- [demo vuejs](https://manhavn.github.io/slidex23424/vuejs)

```shell
 npm i slidex23424
```

# VueJS: Item.vue

```javascript
<template>
  <div ref="item" style="position: relative; padding: 0 2px">
    <img
      style="width: 300px; height: 300px; object-fit: cover"
      :src="src"
      :alt="src"
      loading="lazy"
    />
    <div style="max-width: 300px">
      <div style="color: beige; background-color: slateblue">
        {{ new Date() }}
      </div>
      <div style="color: azure; background-color: slategrey">
        {{ new Date().getTime() }}
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from "vue";

defineProps({ src: null });
const emit = defineEmits(["addItem"]);

const item = ref(HTMLElement);
watch(item, function () {
  if (item.value && item.value.isConnected) emit("addItem", item.value);
});
</script>
```

# VueJS: App.vue

```javascript
<template>
  <div ref="view">
    <Item v-if="add" v-for="src in list" :src="src" @addItem="add" />
  </div>
  <button @click="prev">Prev</button>
  <button @click="next">Next</button>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import slideX from "slidex23424";
import Item from "./Item.vue";

const style = document.createElement("style");
style.innerHTML = "#app { max-width: 1280px; margin: 0 auto; padding: 2rem; text-align: center; width: 80% }";
document.body.appendChild(style)

const view = ref(HTMLElement);
const list = ref();

const add = ref();
const prev = ref();
const next = ref();

watch(view, function () {
  if (view.value && view.value.isConnected) {
    const x = new slideX({
      scale: 1,
      threshold: [0.9999, 0.5, 0.0001],
      section: view.value,
    });
    add.value = x.addItem;
    prev.value = x.prev;
    next.value = x.next;
  }
});

onMounted(function () {
  list.value = [
    "https://picsum.photos/300/300",
    "https://picsum.photos/300/300",
    "https://picsum.photos/300/300",
  ];

  setTimeout(function () {
    alert("Before changing the list");
    const list2 = [
      "https://picsum.photos/300/300",
      "https://picsum.photos/300/300",
      "https://picsum.photos/300/300",
      "https://picsum.photos/300/300",
      "https://picsum.photos/300/300",

      "https://picsum.photos/300/300",
      "https://picsum.photos/300/300",
      "https://picsum.photos/300/300",
      "https://picsum.photos/300/300",
      "https://picsum.photos/300/300",
      "https://picsum.photos/300/300",
      "https://picsum.photos/300/300",
      "https://picsum.photos/300/300",
    ];
    list.value = [...list.value, ...list2];
  }, 1000);
});
</script>
```

# ReactJS: main.jsx

- `REMOVE React.StrictMode in development mode`

```javascript
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.jsx";

ReactDOM.createRoot(document.getElementById("root")).render(
  // <React.StrictMode>
  <App />,
  // </React.StrictMode>,
);
```

# ReactJS: App.jsx

```javascript
import { useRef, useEffect, useState } from "react";
import slideX from "slidex23424";

function Item({ src, addItem }) {
  const item = useRef(HTMLElement);

  useEffect(() => {
    if (
      item.current &&
      item.current.isConnected &&
      typeof addItem === "function"
    ) {
      addItem(item.current);
    }
  }, [item, addItem]);

  return (
    <div ref={item} style={{ position: "relative", padding: "0 2px" }}>
      <img
        style={{ width: "300px", height: "300px", objectFit: "cover" }}
        srcSet={src}
        src={src}
        alt={src}
        loading="lazy"
      />
      <div style={{ maxWidth: "300px" }}>
        <div style={{ color: "beige", backgroundColor: "slateblue" }}>
          {`${new Date()}`}
        </div>
        <div style={{ color: "azure", backgroundColor: "slategrey" }}>
          {`${new Date().getTime()}`}
        </div>
      </div>
    </div>
  );
}

function App() {
  const view = useRef(HTMLElement);
  const [list, setList] = useState([]);

  const add = useRef();
  const prev = useRef();
  const next = useRef();

  useEffect(() => {
    if (view.current && view.current.isConnected) {
      const x = new slideX({
        scale: 1,
        threshold: [0.9999, 0.5, 0.0001],
        section: view.current,
      });
      add.current = x.addItem;
      prev.current = x.prev;
      next.current = x.next;
    }
  }, [view]);

  useEffect(() => {
    setList([
      "https://picsum.photos/300/300",
      "https://picsum.photos/300/300",
      "https://picsum.photos/300/300",
    ]);

    setTimeout(function () {
      alert("Before changing the list");
      const list2 = [
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",

        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
      ];
      setList([...list, ...list2]);
    }, 1000);
  }, []);

  return (
    <>
      <div ref={view}>
        {list.map((src, index) => (
          <Item key={index} src={src} addItem={add.current} />
        ))}
      </div>
      <button onClick={prev.current}>Prev</button>
      <button onClick={next.current}>Next</button>
      <style>
        {
          "#root { max-width: 1280px; margin: 0 auto; padding: 2rem; text-align: center; width: 80% }"
        }
      </style>
    </>
  );
}

export default App;
```

# HTML/JAVASCTIPT Only: index.html

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SlideX23424</title>
    <style type="text/css">
      div.navButtons {
        display: flex;
        justify-content: space-evenly;
        width: 100%;
        position: sticky;
        left: 0;
        bottom: 5px;
      }

      div.navButtons button {
        padding: 25px;
        flex: 1;
        margin: 5px;
        border: 0;
        background: #f001;
      }

      div.navButtons button:hover {
        background: #00f1;
      }

      div.navButtons button:active {
        background: #f0f1;
      }
    </style>
  </head>

  <body>
    <div id="view"></div>

    <div class="navButtons">
      <button id="prev">Prev</button>
      <button id="next">Next</button>
    </div>

    <script src="https://manhavn.github.io/slidex23424/html/index.js"></script>
    <script>
      const configBoxItem = {
        imageSquare: true,
        imageRepeat: false,
        minWidth: 300,
        maxWidth: 300,
        height: 300,
        padding: 2,
        timeEffect: 500,
      };
      const createItem = (url) => {
        const itemDivContent = document.createElement("div");
        itemDivContent.setAttribute(
          "style",
          "height: 100%; overflow: hidden; display: flex; flex-direction: column;",
        );
        itemDivContent.style.position = "relative";
        itemDivContent.style.height = `${configBoxItem.height}px`;
        itemDivContent.style.padding = `${configBoxItem.padding}px`;
        itemDivContent.style.minWidth = `${configBoxItem.minWidth}px`;
        itemDivContent.style.maxWidth = `${configBoxItem.maxWidth}px`;
        itemDivContent.style.transition = `all ${configBoxItem.timeEffect}ms`;
        (() => {
          const imgDiv = document.createElement("div");
          imgDiv.setAttribute(
            "style",
            "width: 100%; background-position: center; align-items: center; flex: 10;",
          );
          imgDiv.style.backgroundImage = `url(${url})`;
          if (configBoxItem.imageSquare) {
            imgDiv.style.height = "0";
            imgDiv.style.paddingBottom = "100%";
            imgDiv.style.backgroundSize = configBoxItem.imageRepeat
              ? "contain"
              : "cover";
            imgDiv.style.backgroundRepeat = configBoxItem.imageRepeat
              ? "repeat"
              : "no-repeat";
          } else {
            imgDiv.style.height = "100%";
            imgDiv.style.backgroundSize = "cover";
            imgDiv.style.backgroundRepeat = "no-repeat";
          }
          itemDivContent.appendChild(imgDiv);
        })();
        return itemDivContent;
      };

      const x = new SlideX23424({
        scale: 1,
        threshold: [0.9999, 0.5, 0.0001],
        section: document.getElementById("view"),
      });
      document.getElementById("prev").onclick = x.prev;
      document.getElementById("next").onclick = x.next;
      const addItem = x.addItem;

      [
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
        "https://picsum.photos/300/300",
      ].forEach((value) => {
        addItem(createItem(value));
      });

      setTimeout(function () {
        alert("Before changing the list");
        [
          "https://picsum.photos/300/300",
          "https://picsum.photos/300/300",
          "https://picsum.photos/300/300",
          "https://picsum.photos/300/300",
          "https://picsum.photos/300/300",

          "https://picsum.photos/300/300",
          "https://picsum.photos/300/300",
          "https://picsum.photos/300/300",
          "https://picsum.photos/300/300",
          "https://picsum.photos/300/300",
          "https://picsum.photos/300/300",
          "https://picsum.photos/300/300",
          "https://picsum.photos/300/300",
        ].forEach((value) => {
          addItem(createItem(value));
        });
      }, 1000);
    </script>
  </body>
</html>
```

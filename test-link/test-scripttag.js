const origin = new URL(document.currentScript.src)?.origin;
console.log(origin);

(async () => {
  if (top === window) return;

  const shop = window.Shopify?.shop;
  const role = window.Shopify?.theme?.role;
  if (!shop || role !== "main") return;

  const searchLocal = new URLSearchParams(location.search);
  const source = searchLocal.get("source");
  const oseid = searchLocal.get("oseid");
  if (source || !oseid) return;

  if (window[shop]) return;
  window[shop] = oseid;

  const listOnApp = btoa(shop + oseid).replace(/=+$/, "");
  const oldList = await cookieStore.get(listOnApp);

  const list = [];
  for await (const v of document.head.querySelectorAll(
    'script[defer="defer"][data-app-id]',
  )) {
    const dataAppId = parseInt(v.getAttribute("data-app-id"), 10);
    if (dataAppId) {
      list.push(dataAppId);
    }
  }
  list.sort((a, b) => a - b);
  const newListStr = JSON.stringify(list);
  document.cookie = `${listOnApp}=${newListStr}; Path=/; SameSite=None; Secure`;

  const oldListStr = oldList?.value;
  if (oldListStr === newListStr) {
    console.log(shop, list, origin);
  }
})();


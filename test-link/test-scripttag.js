const currentScriptSrc = new URL(document.currentScript.src);

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
  const newListStr = btoa(JSON.stringify(list));

  const newCookie = `${listOnApp}=${newListStr}; Path=/; SameSite=None; Secure`;
  document.cookie = newCookie;

  const oldListStr = oldList?.value;
  if (oldListStr === newListStr) {
    const searchParams = currentScriptSrc.searchParams;
    const pingUrl = `${atob(searchParams.get("p"))}?shop=${searchParams.get("shop")}`;
    await fetch(pingUrl);
    document.cookie = newCookie + "; Max-Age=0";
  }
})();

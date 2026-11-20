// LINE service worker: a push arrives with no payload, so ask the exchange what happened
const API = "https://neuromancer-read.jerryshi.workers.dev";
async function myId() { const c = await caches.open("line"); const r = await c.match("id"); return r ? r.text() : ""; }
self.addEventListener("install", (e) => self.skipWaiting());
self.addEventListener("activate", (e) => e.waitUntil(self.clients.claim()));
self.addEventListener("push", (e) => {
  e.waitUntil((async () => {
    let ev = null, count = 0;
    try { const id = await myId(); const r = await (await fetch(API + "/line/latest?id=" + encodeURIComponent(id), { cache: "no-store" })).json(); ev = r.event; count = r.count; } catch (err) {}
    const title = ev ? ev.title : "LINE";
    const body = ev ? ev.body : "activity on the exchange";
    try { if (self.navigator.setAppBadge) await self.navigator.setAppBadge(count || 1); } catch (err) {}
    await self.registration.showNotification(title, { body, tag: "line-" + (ev ? ev.step : "x"), data: { url: "/neuromancer/line/?e=" + (ev ? ev.step : "") }, icon: "/neuromancer/line/icon-180.png" });
  })());
});
self.addEventListener("notificationclick", (e) => {
  e.notification.close();
  const url = (e.notification.data && e.notification.data.url) || "/neuromancer/line/";
  e.waitUntil((async () => {
    const all = await self.clients.matchAll({ type: "window", includeUncontrolled: true });
    for (const c of all) { if ("navigate" in c) { await c.focus(); return c.navigate(url); } }
    return self.clients.openWindow(url);
  })());
});

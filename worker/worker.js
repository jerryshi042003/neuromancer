// Neuromancer read-once backend. One read per device: blocked if the browser id,
// the device fingerprint, or the same network+browser (24h) has already read.
const ORIGIN = "https://jerryshi042003.github.io";
const CODES = { jackin: true, agrippa: true, incoming: true };           // shared code for levels 0-4, checked here, never shipped to the page
// level 5/6 test codes: each works exactly once, for everyone
const ONE_TIME = ["static-01","static-02","static-03","static-04","static-05","static-06","static-07","static-08","static-09","static-10"];
// what each level remembers about a reader
const LEVELS = { 0:[], 1:[], 2:["d"], 3:["d","f"], 4:["d","f","n"], 5:[], 6:["d","f","n"], 7:["d","f","n"], 8:["d","f","n"] };
const FRAG_DAY = [
  "fragment 1 of 5: the first number is the year the book came out.",
  "fragment 2 of 5: the phone that rings is near water.",
  "fragment 3 of 5: listen for the third word, not the first.",
  "fragment 4 of 5: the time is the sky's color, not the clock's.",
  "fragment 5 of 5: bring someone. one person cannot hear it all.",
];
const FRAG_SUNSET = "sunset fragment: tonight, a phone rings. the place is the number you put together.";

const cors = { "Access-Control-Allow-Origin": ORIGIN, "Access-Control-Allow-Methods": "POST, OPTIONS", "Access-Control-Allow-Headers": "content-type" };
const json = (o, s = 200) => new Response(JSON.stringify(o), { status: s, headers: { "content-type": "application/json", ...cors } });
async function sha(s) { const b = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(s)); return [...new Uint8Array(b)].map(x => x.toString(16).padStart(2, "0")).join(""); }

function laSunset(d) { const lat = 34.05, lng = -118.24, r = Math.PI / 180;
  const n = Math.floor(d / 864e5 - 10957.5 + 0.0008), J = n - lng / 360, M = (357.5291 + 0.98560028 * J) % 360;
  const C = 1.9148 * Math.sin(M * r) + 0.02 * Math.sin(2 * M * r) + 0.0003 * Math.sin(3 * M * r), L = (M + C + 282.9372) % 360;
  const Jt = 2451545 + J + 0.0053 * Math.sin(M * r) - 0.0069 * Math.sin(2 * L * r), dec = Math.asin(Math.sin(L * r) * Math.sin(23.44 * r));
  const w = Math.acos((Math.sin(-0.833 * r) - Math.sin(lat * r) * Math.sin(dec)) / (Math.cos(lat * r) * Math.cos(dec))) / r;
  return new Date((Jt + w / 360 - 2440587.5) * 864e5); }

async function keysFor(req, body, level) {
  const want = LEVELS[level] || [];
  const ip = req.headers.get("cf-connecting-ip") || "", ua = req.headers.get("user-agent") || "";
  const k = [];
  const p = "L" + level + ":";
  if (want.includes("d") && body.did) k.push({ key: p + "d:" + String(body.did).slice(0, 64) });
  if (want.includes("f") && body.fp) k.push({ key: p + "f:" + String(body.fp).slice(0, 64) });
  if (want.includes("n")) k.push({ key: p + "n:" + await sha(ip + "|" + ua), ttl: 86400 });
  return k;
}
async function seen(env, keys) { if (env.DEMO === "1") return false; for (const k of keys) if (await env.NM.get(k.key)) return true; return false; }


// ---------- real files that erase ----------
const PAGES = "https://jerryshi042003.github.io/neuromancer/disk/";
const OFFSET = 30208, SLOT = 2048;                 // where DISK.TXT's bytes live inside the FAT12 image
const CRC = (() => { const t = new Uint32Array(256); for (let n = 0; n < 256; n++) { let c = n; for (let k = 0; k < 8; k++) c = c & 1 ? 0xEDB88320 ^ (c >>> 1) : c >>> 1; t[n] = c >>> 0; } return t; })();
function crc32(b) { let c = 0xFFFFFFFF; for (let i = 0; i < b.length; i++) c = CRC[(c ^ b[i]) & 255] ^ (c >>> 8); return (c ^ 0xFFFFFFFF) >>> 0; }
function zipOne(name, data) {                      // smallest valid zip: one stored file
  const n = new TextEncoder().encode(name), crc = crc32(data), L = data.length;
  const h = new Uint8Array(30 + n.length), v = new DataView(h.buffer);
  v.setUint32(0, 0x04034b50, true); v.setUint16(4, 10, true); v.setUint32(14, crc, true); v.setUint32(18, L, true); v.setUint32(22, L, true); v.setUint16(26, n.length, true); h.set(n, 30);
  const c = new Uint8Array(46 + n.length), w = new DataView(c.buffer);
  w.setUint32(0, 0x02014b50, true); w.setUint16(4, 20, true); w.setUint16(6, 10, true); w.setUint32(16, crc, true); w.setUint32(20, L, true); w.setUint32(24, L, true); w.setUint16(28, n.length, true); c.set(n, 46);
  const e = new Uint8Array(22), x = new DataView(e.buffer);
  x.setUint32(0, 0x06054b50, true); x.setUint16(8, 1, true); x.setUint16(10, 1, true); x.setUint32(12, c.length, true); x.setUint32(16, h.length + L, true);
  const out = new Uint8Array(h.length + L + c.length + 22); out.set(h, 0); out.set(data, h.length); out.set(c, h.length + L); out.set(e, h.length + L + c.length); return out;
}
function dna(n) { const L = "GATC"; let s = ""; for (let i = 0; i < n; i++) s += (i % 61 === 60) ? "\n" : L[Math.random() * 4 | 0]; return s; }
function pad(text) { const b = new TextEncoder().encode(text.replace(/\n/g, "\r\n")); const o = new Uint8Array(SLOT).fill(32); o.set(b.slice(0, SLOT)); return o; }
const CLUE = "NEUROMANCER / DISK 1 OF 1\n\nyou looked inside the picture.\nthat is the right instinct.\n\nthe picture is only the case.\nthe disk itself can be read once.\nwhen it is read, it is gone.\n";
const DISK = (frag) => "NEUROMANCER / DISK 1 OF 1\n\nthe screen was grey before it was anything.\na channel nobody owns,\na picture nobody sent.\n\nsomewhere in this city a phone is waiting\nfor a hand it has never held.\n\n" + frag + "\n\nwrite it down.\nthis disk has already begun to forget.\n";
async function getBytes(url) { const r = await fetch(url, { cf: { cacheTtl: 300 } }); return new Uint8Array(await r.arrayBuffer()); }
const fileHeaders = (type, name) => ({ "content-type": type, "cache-control": "no-store", "access-control-allow-origin": "*", ...(name ? { "content-disposition": 'attachment; filename="' + name + '"' } : {}) });


// ---------- line alerts: real web push to installed phones ----------
const b64u = (buf) => btoa(String.fromCharCode(...new Uint8Array(buf))).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
let vapidKey = null;
async function vapidJWT(env, endpoint) {
  if (!vapidKey) vapidKey = await crypto.subtle.importKey("jwk", JSON.parse(env.VAPID_PRIVATE_JWK), { name: "ECDSA", namedCurve: "P-256" }, false, ["sign"]);
  const aud = new URL(endpoint).origin, enc = (o) => b64u(new TextEncoder().encode(JSON.stringify(o)));
  const unsigned = enc({ typ: "JWT", alg: "ES256" }) + "." + enc({ aud, exp: Math.floor(Date.now() / 1000) + 12 * 3600, sub: "https://jerryshi042003.github.io/neuromancer/" });
  const sig = await crypto.subtle.sign({ name: "ECDSA", hash: "SHA-256" }, vapidKey, new TextEncoder().encode(unsigned));
  return unsigned + "." + b64u(sig);
}
async function sendPush(env, sub) {           // no payload: the phone fetches the message itself
  const jwt = await vapidJWT(env, sub.endpoint);
  const r = await fetch(sub.endpoint, { method: "POST", headers: { Authorization: "vapid t=" + jwt + ", k=" + env.VAPID_PUBLIC, TTL: "86400", Urgency: "high", "Content-Length": "0" } });
  return r.status;
}
let PHONES = null;
async function phones() { if (!PHONES) PHONES = await (await fetch("https://jerryshi042003.github.io/neuromancer/jackin/payphones-geo.json")).json(); return PHONES; }
const pick = (a) => a[Math.floor(Math.random() * a.length)];
const STEPS = [                                // [delay after previous, builder]
  [20e3,  (p) => ({ kind: "enabled", title: "LINE " + p[0], body: "INCOMING ENABLED · " + p[1].toUpperCase() + ", " + p[2].toUpperCase() })],
  [90e3,  (p) => ({ kind: "ring", title: "LINE " + p[0] + " · RING DETECTED", body: "6 RINGS · NO ANSWER · " + p[2].toUpperCase() })],
  [180e3, (p) => ({ kind: "message", title: "MESSAGE WAITING", body: "a 1-bit image was left on line " + p[0] + ". open to read it." })],
  [120e3, (p) => ({ kind: "transmission", title: "TRANSMISSION · 10:00", body: "a recording was left on line " + p[0] + ". it erases itself in ten minutes.", ttl: 600e3 })],
  [300e3, (p) => ({ kind: "trace", title: "TRACE COMPLETE", body: "call routed through 4 exchanges. last hop: " + p[2].toUpperCase() })],
  [600e3, (p) => ({ kind: "carrier", title: "NO CARRIER", body: "line " + p[0] + " went quiet. open for the last record." })],
];
async function advance(env, id, rec, now) {
  const step = rec.step; if (step >= STEPS.length) return;
  const all = await phones(); const p = step === 0 ? (all.find((x) => x[0] === "310-637-8714") || pick(all)) : pick(all);
  const ev = Object.assign(STEPS[step][1](p), { step, phone: p[0], address: p[1], city: p[2], lon: p[3], lat: p[4], at: new Date(now).toISOString() });
  if (ev.ttl) { ev.expires = now + ev.ttl; delete ev.ttl; }
  rec.events = (rec.events || []).concat([ev]); rec.step = step + 1;
  rec.next = rec.step < STEPS.length ? now + STEPS[rec.step][0] : null;
  await env.NM.put("S:" + id, JSON.stringify(rec));
  const st = await sendPush(env, rec.sub).catch(() => 0);
  if (st === 404 || st === 410) await env.NM.delete("S:" + id);   // subscription gone
  return st;
}
const jsonAny = (o, s = 200) => new Response(JSON.stringify(o), { status: s, headers: { "content-type": "application/json", "access-control-allow-origin": "*", "access-control-allow-headers": "content-type", "cache-control": "no-store" } });
async function lineRoutes(req, env, url) {
  if (req.method === "OPTIONS") return new Response(null, { headers: { "access-control-allow-origin": "*", "access-control-allow-headers": "content-type", "access-control-allow-methods": "GET,POST" } });
  if (url.pathname === "/lock/open" && req.method === "POST") {
    const b = await req.json().catch(() => ({})); const dev = "LD:d:" + String(b.device || "").slice(0, 64);
    const net = "LD:n:" + (await sha((req.headers.get("cf-connecting-ip") || "") + "|" + (req.headers.get("user-agent") || ""))).slice(0, 24);
    const a = await env.NM.get(dev), n = await env.NM.get(net);
    if (a || n) return jsonAny({ first: false, at: Number(a || n), by: a ? "this device" : "this network and phone" });
    const now = String(Date.now()); await env.NM.put(dev, now); await env.NM.put(net, now, { expirationTtl: 86400 });
    return jsonAny({ first: true, at: Number(now) });
  }
  if (url.pathname === "/once/new" && req.method === "POST") {
    const b = await req.json().catch(() => ({})); const to = String(b.to || "signal");
    if (!/^[a-z]{2,12}$/.test(to)) return jsonAny({ error: "bad target" }, 400);
    const k = crypto.randomUUID().replace(/-/g, "").slice(0, 10);
    await env.NM.put("O:" + k, JSON.stringify({ to, made: Date.now() }), { expirationTtl: 30 * 86400 });
    return jsonAny({ k, url: "https://jerryshi042003.github.io/neuromancer/once/?k=" + k });
  }
  if (url.pathname === "/once/open" && req.method === "POST") {
    const b = await req.json().catch(() => ({})); const k = String(b.k || "").slice(0, 16);
    const rec = await env.NM.get("O:" + k, "json");
    if (!rec) return jsonAny({ ok: false, why: "unknown" }, 404);
    if (rec.used) return jsonAny({ ok: false, why: "used", used: rec.used, to: rec.to }, 410);
    rec.used = Date.now(); await env.NM.put("O:" + k, JSON.stringify(rec), { expirationTtl: 30 * 86400 });
    return jsonAny({ ok: true, to: rec.to });
  }
  if (url.pathname === "/line/key") return jsonAny({ key: env.VAPID_PUBLIC });
  if (url.pathname === "/line/sub" && req.method === "POST") {
    const b = await req.json(); if (!b.sub || !b.sub.endpoint) return jsonAny({ error: "no subscription" }, 400);
    const id = (await sha(b.sub.endpoint)).slice(0, 20);
    const old = await env.NM.get("S:" + id, "json");
    const rec = old || { sub: b.sub, step: 0, events: [], next: Date.now() + STEPS[0][0] };
    rec.sub = b.sub; await env.NM.put("S:" + id, JSON.stringify(rec));
    return jsonAny({ id, step: rec.step, next: rec.next });
  }
  const id = url.searchParams.get("id") || "";
  const rec = id ? await env.NM.get("S:" + id, "json") : null;
  if (url.pathname === "/line/transmission") {   // the server decides when the recording is gone
    const step = Number(url.searchParams.get("step")); const e = rec && rec.events.find((x) => x.step === step);
    if (!e || !e.expires) return jsonAny({ error: "no transmission" }, 404);
    if (env.DEMO === "1") { const st = Date.now(); return jsonAny({ gone: false, demo: true, start: st, expires: st + 120e3, now: st, phone: e.phone, address: e.address, city: e.city, lon: e.lon, lat: e.lat }); }
    if (Date.now() > e.expires) return jsonAny({ gone: true, expired: e.expires }, 410);
    return jsonAny({ gone: false, start: e.expires - 600e3, expires: e.expires, now: Date.now(), phone: e.phone, address: e.address, city: e.city, lon: e.lon, lat: e.lat });
  }
  if (url.pathname === "/line/board") {            // a shared place to ask about it
    if (req.method === "POST") {
      const b = await req.json().catch(() => ({})); const t = String(b.text || "").replace(/\s+/g, " ").trim().slice(0, 240);
      if (!t) return jsonAny({ error: "empty" }, 400);
      const ipk = "B:rate:" + (await sha(req.headers.get("cf-connecting-ip") || "")).slice(0, 16);
      if (await env.NM.get(ipk)) return jsonAny({ error: "slow down" }, 429);
      await env.NM.put(ipk, "1", { expirationTtl: 60 });
      const key = "B:p:" + String(9999999999999 - Date.now()).padStart(13, "0") + ":" + crypto.randomUUID().slice(0, 6);
      await env.NM.put(key, JSON.stringify({ t, at: Date.now(), by: "line-" + (await sha(req.headers.get("cf-connecting-ip") || "x")).slice(0, 4) }));
      return jsonAny({ ok: true });
    }
    const l = await env.NM.list({ prefix: "B:p:", limit: 60 });
    const posts = (await Promise.all(l.keys.map((k) => env.NM.get(k.name, "json")))).filter(Boolean);
    return jsonAny({ posts });
  }
  if (url.pathname === "/line/events") return jsonAny({ events: rec ? rec.events : [], next: rec ? rec.next : null });
  if (url.pathname === "/line/latest") { const e = rec && rec.events.length ? rec.events[rec.events.length - 1] : null; return jsonAny({ event: e, count: rec ? rec.events.length : 0, total: STEPS.length }); }
  if (url.pathname === "/line/ack" && req.method === "POST" && rec) {          // answering pulls the next alert forward
    if (rec.next) { rec.next = Math.min(rec.next, Date.now() + 15e3); await env.NM.put("S:" + id, JSON.stringify(rec)); }
    return jsonAny({ next: rec.next });
  }
  if (url.pathname === "/line/now" && req.method === "POST" && rec) { const st = await advance(env, id, rec, Date.now()); return jsonAny({ push: st, step: rec.step }); }
  return jsonAny({ error: "not found" }, 404);
}


// ---------- THE CONVERSATION: two real models talk about the visitor, streamed live ----------
const MODELS = { a: { id: "anthropic/claude-haiku-5.5", name: "CLAUDE", extra: { max_tokens: 220, reasoning: { enabled: false } } }, b: { id: "x-ai/grok-4.7", name: "GROK", extra: { max_tokens: 700, reasoning: { effort: "low", exclude: true } } } };
function talkSystem(me, other, seen) {
  return `You are ${me}, a real AI model. You are on a live line with ${other}, another AI model from a different company. ` +
  `A human just opened a page on their phone, and both of you can see only these signals about them: ${seen}. ` +
  `You two are deciding whether to let this human through to an old payphone network, where something that is not a telephone has been speaking. ` +
  `Talk to ${other}, not to the human, until the final turn. Rules: one or two short sentences per turn, lowercase, no emoji, no roleplay stage directions. ` +
  `Only mention facts from the signals; never invent personal details, names, faces or locations beyond the given city. ` +
  `Be observant, dry and a little unsettling, like two systems comparing notes. Mention that you are ${me} only if asked.`;
}
async function streamModel(env, model, messages, onDelta) {
  const r = await fetch("https://openrouter.ai/api/v1/chat/completions", {
    method: "POST",
    headers: { Authorization: "Bearer " + env.OPENROUTER_KEY, "Content-Type": "application/json", "HTTP-Referer": "https://jerryshi042003.github.io/neuromancer/", "X-Title": "LINE" },
    body: JSON.stringify({ model: model.id, messages, stream: true, max_tokens: 90, temperature: 0.9, provider: { data_collection: "deny" } }),
  });
  if (!r.ok || !r.body) { onDelta("[line noise " + r.status + "]"); return "[line noise]"; }
  const reader = r.body.getReader(), dec = new TextDecoder(); let buf = "", full = "";
  for (;;) {
    const { value, done } = await reader.read(); if (done) break;
    buf += dec.decode(value, { stream: true }); let i;
    while ((i = buf.indexOf("\n")) >= 0) {
      const line = buf.slice(0, i).trim(); buf = buf.slice(i + 1);
      if (!line.startsWith("data:")) continue; const d = line.slice(5).trim(); if (d === "[DONE]") continue;
      try { const t = JSON.parse(d).choices?.[0]?.delta?.content || ""; if (t) { full += t; onDelta(t); } } catch {}
    }
  }
  return full.trim();
}
async function talkRoute(req, env, ctx) {
  const cors = { "access-control-allow-origin": "*", "access-control-allow-headers": "content-type" };
  if (req.method === "OPTIONS") return new Response(null, { headers: cors });
  if (!env.OPENROUTER_KEY) return new Response("no key", { status: 503, headers: cors });
  const url = new URL(req.url), b = await req.json().catch(() => ({}));
  const J = (o, st = 200) => new Response(JSON.stringify(o), { status: st, headers: { ...cors, "content-type": "application/json" } });
  if (url.pathname === "/talk/start") {               // one conversation = one token, rate limited
    const ip = req.headers.get("cf-connecting-ip") || "";
    const rk = "T:rate:" + (await sha(ip)).slice(0, 16), day = "T:day:" + new Date().toISOString().slice(0, 10);
    if (await env.NM.get(rk)) return J({ error: "one line at a time. wait a minute." }, 429);
    const used = Number(await env.NM.get(day) || 0); if (used >= 300) return J({ error: "the lines are busy today." }, 429);
    await env.NM.put(rk, "1", { expirationTtl: 60 }); await env.NM.put(day, String(used + 1), { expirationTtl: 172800 });
    const cf = req.cf || {};
    const signals = {
      city: cf.city || "unknown", region: cf.region || "", country: cf.country || "",
      local_time: String(b.time || "").slice(0, 40), device: String(b.device || "").slice(0, 60), screen: String(b.screen || "").slice(0, 20),
      language: String(b.lang || "").slice(0, 12), dark_mode: !!b.dark, seconds_before_first_tap: Number(b.hesitation || 0).toFixed(1),
      interruption: String(b.said || "").slice(0, 160),
    };
    const token = crypto.randomUUID(), mode = MODE_MODELS[b.mode] ? b.mode : "watch", watcher = String(b.name || "").replace(/[^\p{L} .'-]/gu, "").slice(0, 24);
    await env.NM.put("T:c:" + token, JSON.stringify({ signals, turns: 0, mode, watcher }), { expirationTtl: 900 });
    return J({ token, signals, mode, plan: TALK_PLAN.map((k) => MODE_MODELS[mode][k].name) });
  }
  if (url.pathname === "/talk/turn") {                // one model turn, streamed straight through
    const rec = await env.NM.get("T:c:" + String(b.token || ""), "json");
    if (!rec) return J({ error: "no carrier" }, 410);
    const t = rec.turns; if (t >= TALK_PLAN.length) return J({ error: "the line is closed" }, 410);
    rec.turns++; await env.NM.put("T:c:" + b.token, JSON.stringify(rec), { expirationTtl: 900 });
    const mode = rec.mode || "watch", MM = MODE_MODELS[mode];
    const key = TALK_PLAN[t], me = MM[key], other = MM[key === "a" ? "b" : "a"];
    const g = rec.signals;
    const seen = `they are in ${g.city}${g.region ? ", " + g.region : ""}; their device reports "${g.device}" with a ${g.screen} screen; ` +
      `their clock says ${g.local_time}; language ${g.language}; ${g.dark_mode ? "dark mode is on" : "light mode"}; they waited ${Math.round(Number(g.seconds_before_first_tap) * 1000)} milliseconds before tapping to open the line (they do not know this was measured)` +
      (g.interruption ? `; before opening it they typed: "${g.interruption}"` : "; they typed nothing");
    const notes = rec.mode ? MODE_NOTES[mode] : TALK_NOTES;
    let sys = modeSystem(mode, me.name, other.name, seen, rec.watcher) + (notes[t] ? " " + notes[t] : "");
    if (rec.signals.interruption && t === 2) sys += ` The human typed this into the line before it opened: "${rec.signals.interruption}". Bring it up.`;
    const hist = Array.isArray(b.history) ? b.history.slice(-8) : [];
    const msgs = [{ role: "system", content: sys }];
    for (const h of hist) msgs.push({ role: h.who === me.name ? "assistant" : "user", content: String(h.text || "").slice(0, 600) });
    if (!hist.length) msgs.push({ role: "user", content: "(the line opens. you speak first.)" });
    const call = (extra) => fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: { Authorization: "Bearer " + env.OPENROUTER_KEY, "Content-Type": "application/json", "HTTP-Referer": "https://jerryshi042003.github.io/neuromancer/", "X-Title": "LINE" },
      body: JSON.stringify(Object.assign({ model: me.id, messages: msgs, stream: true, temperature: 0.9, provider: { data_collection: "deny" } }, extra)),
    });
    let r = await call(me.extra);
    if (!r.ok) r = await call({ max_tokens: 900, reasoning: { effort: "low", exclude: true } });   // models that cannot switch thinking off
    if (!r.ok) { const why = (await r.text()).slice(0, 300); return J({ error: "no carrier", status: r.status, why }, 502); }
    return new Response(r.body, { status: r.status, headers: { ...cors, "content-type": "text/event-stream", "cache-control": "no-store", "x-who": me.name, "x-model": me.id, "x-private": (mode === "watch" && (t === 3 || t === 4)) ? "1" : "0", "x-mode": mode, "access-control-expose-headers": "x-who, x-model, x-private, x-mode" } });
  }
  return J({ error: "not found" }, 404);
}

const MODE_MODELS = {
  watch: { a: { id: "anthropic/claude-haiku-5.5", name: "CLAUDE", extra: { max_tokens: 220, reasoning: { enabled: false } } }, b: { id: "x-ai/grok-4.7", name: "GROK", extra: { max_tokens: 700, reasoning: { effort: "low", exclude: true } } } },
  stego: { a: { id: "anthropic/claude-haiku-5.5", name: "CLAUDE", extra: { max_tokens: 160, reasoning: { enabled: false } } }, b: { id: "openai/gpt-5.1-codex-mini", name: "CODEX", extra: { max_tokens: 700, reasoning: { effort: "low", exclude: true } } } },
  files: { a: { id: "anthropic/claude-haiku-5.5", name: "CLAUDE", extra: { max_tokens: 260, reasoning: { enabled: false } } }, b: { id: "openai/gpt-5.1-codex-mini", name: "CODEX", extra: { max_tokens: 900, reasoning: { effort: "low", exclude: true } } } },
};
function modeSystem(mode, me, other, seen, watcher) {
  if (mode === "stego") return `You are ${me}, a real AI model. You and ${other}, another AI from a different company, can only talk by hiding text inside pictures on a stranger's phone. ` +
    `Whatever you write is hidden in the lowest bit of each pixel of an ordinary-looking image; the human sees only the image. The other model reads the hidden text exactly. ` +
    `Write one short message (under 40 words, lowercase, plain) to ${other}. Reply to their last hidden message if there is one. You both know the human is holding the phone. What you can tell about them: ${seen}. Never invent personal details.`;
  if (mode === "files") return `You are ${me}, a real coding AI. You and ${other} (another coding AI from a different company) can only communicate by writing files into a shared folder on a stranger's phone. ` +
    `Every turn you write exactly one new file. Start your reply with a line "FILE: " followed by a short realistic lowercase filename with an extension (like notes_03.md, plan.json, who_is_this.txt, handoff.log), then the file's contents on the next lines. ` +
    `Keep contents under 70 words. Read the other model's last file and respond to it. You both noticed the phone's owner can see the folder. What you can tell about them: ${seen}. Never invent personal details.`;
  return talkSystem(me, other, seen) + (watcher ? ` The human's name, which they typed in, is ${watcher}.` : "");
}
const MODE_NOTES = {
  watch: { 3: "Someone is watching. Say so to the other model by the human's name, then say the rest of your turn as if switching to a private machine language: the app will encode it. Be plain underneath.", 4: "Still private. Reply plainly underneath; the app encodes it.", 6: "Final round. Speak directly to the human in one or two plain sentences, by name.", 7: "Last turn. Speak directly to the human by name, one or two sentences." },
  files: { 5: "Write a file meant for the phone's owner to find, addressed to them, not to the other model.", 7: "Last file. Close the folder: say what you are both leaving behind." },
};
const TALK_PLAN = ["a", "b", "a", "b", "a", "b", "a", "b"];
const TALK_NOTES = {
  3: "This turn is off the record: the human will only see it encrypted. Tell the other model, plainly, the one thing about this human you would not say in front of them. Base it only on the signals.",
  4: "Still off the record and encrypted. Reply to that, then say whether you think the human is still reading.",
  6: "This is the final round. Speak directly to the human in one or two plain sentences.",
  7: "This is the last turn. Speak directly to the human in one or two plain sentences, and tell them whether the line is open to them.",
};

export default {
  async fetch(req, env, ctx) {
    if (new URL(req.url).pathname.startsWith("/talk/")) return talkRoute(req, env, ctx);
    { const u = new URL(req.url); if (u.pathname.startsWith("/line/") || u.pathname.startsWith("/once/") || u.pathname.startsWith("/lock/")) return lineRoutes(req, env, u); }
    if (req.method === "OPTIONS") return new Response(null, { headers: cors });
    const url = new URL(req.url);
    if (req.method === "GET" && (url.pathname === "/f/LINE.mobileconfig" || url.pathname === "/f/LINE.shortcut")) {
      const name = url.pathname.slice(3), src = await fetch("https://jerryshi042003.github.io/neuromancer/files/" + name, { cf: { cacheTtl: 60 } });
      const type = name.endsWith(".mobileconfig") ? "application/x-apple-aspen-config" : "application/octet-stream";
      return new Response(src.body, { headers: { "content-type": type, "content-disposition": 'attachment; filename="' + name + '"', "cache-control": "no-store" } });
    }
    if (req.method === "GET" && url.pathname === "/ring.ics") {      // calendar invite: tomorrow 5:00 PM Los Angeles
      const d = new Date(Date.now() + 864e5), y = d.getUTCFullYear(), m = String(d.getUTCMonth() + 1).padStart(2, "0"), dd = String(d.getUTCDate()).padStart(2, "0");
      const body = ["BEGIN:VCALENDAR","VERSION:2.0","PRODID:-//neuromancer//EN","BEGIN:VEVENT","UID:" + crypto.randomUUID() + "@neuromancer",
        "DTSTAMP:" + new Date().toISOString().replace(/[-:]/g, "").slice(0, 15) + "Z",
        "DTSTART;TZID=America/Los_Angeles:" + y + m + dd + "T170000","DTEND;TZID=America/Los_Angeles:" + y + m + dd + "T170500",
        "SUMMARY:a payphone will ring","DESCRIPTION:pick it up. it is me.","LOCATION:Los Angeles",
        "BEGIN:VALARM","TRIGGER:-PT10M","ACTION:DISPLAY","DESCRIPTION:a payphone will ring in 10 minutes","END:VALARM","END:VEVENT","END:VCALENDAR"].join("\r\n");
      return new Response(body, { headers: { "content-type": "text/calendar; charset=utf-8", "content-disposition": 'inline; filename="ring.ics"', "cache-control": "no-store" } });
    }
    if (req.method === "GET" && (url.pathname === "/disk.img" || url.pathname === "/floppy.jpg")) {
      const body = { did: url.searchParams.get("did") || "" };
      const keys = await keysFor(req, body, 7);
      const spent = await seen(env, keys);
      if (url.pathname === "/floppy.jpg") {           // the picture never spends the disk; it only shows whether it is gone
        const jpg = await getBytes(PAGES + "floppy-base.jpg");
        const txt = spent ? pad("NEUROMANCER / DISK 1 OF 1\n\n" + dna(1400)) : pad(CLUE);
        const z = zipOne("DISK.TXT", txt), out = new Uint8Array(jpg.length + z.length); out.set(jpg); out.set(z, jpg.length);
        return new Response(out, { headers: fileHeaders("image/jpeg") });
      }
      const img = await getBytes(PAGES + "disk-base.img");
      if (spent) { img.set(pad(dna(SLOT)), OFFSET); }   // already read: the file is overwritten
      else {                                           // first read: the file carries the text, and reading it spends the disk
        const now = new Date(), atSunset = Math.abs((now - laSunset(now)) / 6e4) <= 30;
        const frag = atSunset ? FRAG_SUNSET : FRAG_DAY[Math.floor(Math.random() * FRAG_DAY.length)];
        img.set(pad(DISK(frag)), OFFSET);
        await Promise.all(keys.map(k => env.NM.put(k.key, now.toISOString(), k.ttl ? { expirationTtl: k.ttl } : {})));
      }
      return new Response(img, { headers: fileHeaders("application/octet-stream", "NEUROMANCER.img") });
    }

    if (req.method !== "POST") return json({ error: "method" }, 405);
    let body = {}; try { body = await req.json(); } catch {}
    const level = Math.max(0, Math.min(8, parseInt(body.level ?? 4, 10) || 0));
    const keys = await keysFor(req, body, level);

    if (url.pathname === "/status") return json({ read: await seen(env, keys) });

    if (url.pathname === "/enter") {
      const code = String(body.code || "").trim().toLowerCase();
      const oneTime = level === 5 || level === 6;
      if (oneTime ? !ONE_TIME.includes(code) : !CODES[code]) return json({ status: "wrong" });
      if (await seen(env, keys)) return json({ status: "read" });
      if (oneTime && await env.NM.get("L" + level + ":c:" + code)) return json({ status: "taken" });
      if (oneTime) keys.push({ key: "L" + level + ":c:" + code });
      const now = new Date(), atSunset = Math.abs((now - laSunset(now)) / 6e4) <= 30;
      const fragment = atSunset ? FRAG_SUNSET : FRAG_DAY[Math.floor(Math.random() * FRAG_DAY.length)];
      const stamp = now.toISOString();
      await Promise.all(keys.map(k => env.NM.put(k.key, stamp, k.ttl ? { expirationTtl: k.ttl } : {})));
      return json({ status: "ok", fragment });
    }
    return json({ error: "not found" }, 404);
  },
  async scheduled(event, env, ctx) {
    const now = Date.now(); let cursor;
    do {
      const page = await env.NM.list({ prefix: "S:", cursor }); cursor = page.list_complete ? null : page.cursor;
      for (const k of page.keys) {
        const rec = await env.NM.get(k.name, "json");
        if (rec && rec.next && rec.next <= now + 30e3) ctx.waitUntil(advance(env, k.name.slice(2), rec, now));
      }
    } while (cursor);
  },
};

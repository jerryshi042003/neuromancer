// Neuromancer read-once backend. One read per device: blocked if the browser id,
// the device fingerprint, or the same network+browser (24h) has already read.
const ORIGIN = "https://jerryshi042003.github.io";
const CODES = { jackin: true, agrippa: true };           // shared code for levels 0-4, checked here, never shipped to the page
// level 5/6 test codes: each works exactly once, for everyone
const ONE_TIME = ["static-01","static-02","static-03","static-04","static-05","static-06","static-07","static-08","static-09","static-10"];
// what each level remembers about a reader
const LEVELS = { 0:[], 1:[], 2:["d"], 3:["d","f"], 4:["d","f","n"], 5:[], 6:["d","f","n"], 7:["d","f","n"] };
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
async function seen(env, keys) { for (const k of keys) if (await env.NM.get(k.key)) return true; return false; }

export default {
  async fetch(req, env) {
    if (req.method === "OPTIONS") return new Response(null, { headers: cors });
    const url = new URL(req.url);
    if (req.method !== "POST") return json({ error: "method" }, 405);
    let body = {}; try { body = await req.json(); } catch {}
    const level = Math.max(0, Math.min(7, parseInt(body.level ?? 4, 10) || 0));
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
};

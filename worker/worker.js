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

export default {
  async fetch(req, env) {
    if (req.method === "OPTIONS") return new Response(null, { headers: cors });
    const url = new URL(req.url);
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

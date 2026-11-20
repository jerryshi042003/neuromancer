# Neuromancer deep references (built 2026-11-19/20)

Private study library. Not for publishing: film frames, stills and screenshots stay in `~/Scratch/neuromancer-refs/` and must not go on any website or into this public repo. This file holds only links, paths and notes.

How it was checked:
- Film frames were cut from YouTube clips at exact timestamps with ffmpeg. Each one was looked at, and re-cutting at the same timestamps gave identical files.
- GitHub repos were checked with `gh api` (stars, last push, license) and their demos with curl.
- ARG and retro pages were checked with curl (HTTP 200/301/302) and photographed with headless Chromium. Hidden-in-source quotes were grepped from saved archive HTML.
- Every Muse link was opened (yt-dlp metadata for YouTube, the logged-in page for Instagram).
- Every local path below was confirmed to exist on 2026-11-20.

Full per-item notes (colours, framing, evidence quotes, licenses, "use in our game") are in each lane's `LANE.md`. The file-to-URL map is in each lane's `SOURCES.md`, under `~/Scratch/neuromancer-refs/<lane>/`.

| Lane | Items | Full notes |
|---|---|---|
| 1. Film frames | 129 frames from 9 films/series (27 clips), plus ~310 FILMGRAB stills | `~/Scratch/neuromancer-refs/film/LANE.md` |
| 2. GitHub code | 56 repos verified with gh api (+13 leads with stars only), 9 cloned | `~/Scratch/neuromancer-refs/github/LANE.md` |
| 3. ARGs and puzzle sites | 26 ARGs, 40 screenshots, 38 raw archived HTML/JS files | `~/Scratch/neuromancer-refs/arg/LANE.md` |
| 4. Retro UI you can open live | 44 items, 58 screenshots | `~/Scratch/neuromancer-refs/retro/LANE.md` |
| 5. NFC, Wi-Fi names and captive portals (added) | 29 items, 31 screenshots | `~/Scratch/neuromancer-refs/nfc-ssid/LANE.md` |
| 6. Muse YouTube + Instagram leads (audited) | 38 links (26 YouTube, 12 Instagram) | `~/Scratch/neuromancer-refs/muse/LANE.md` |

## Top 15 for a 1990s phone-network hacking game

1. **I Love Bees payphone schedule, `fable.html` (2004).** A real archived table of payphone GPS coordinates and PDT times, each marked "CONNECTED / AXON HOT". This is the exact mechanic for rings at scheduled payphones. https://web.archive.org/web/20040912022742/http://www.ilovebees.com:80/fable.html — `~/Scratch/neuromancer-refs/arg/i-love-bees/ilb-axon-payphone-gps-table.png`, source `~/Scratch/neuromancer-refs/arg/raw/ilovebees-fable.html`
2. **WarGames war-dialer screen, "TO SCAN FOR CARRIER TONES".** One colour on black, an area-code/prefix table and a block cursor. Turn it 1-bit and it is the dialer UI. `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_09_scan-carrier-tones.png`
3. **The Matrix ringing booth payphone, handset close-up.** The hero prop and the "exit". `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_06_payphone-handset-ringing.png` (also `matrix_21_neo-hangs-up-payphone.png`, `matrix_20_handset-grille.png`)
4. **Sneakers call-trace map.** Boxed relay nodes (SFO GL482, CHICAG AT408, BANGOR TL802) joined by route lines; a model for the call-bounce / trace screen. `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_02_trace-nodes-usa.png`
5. **"Wake up, Neo" / "Knock, knock, Neo."** A small monospace line top-left on an empty black CRT; the pacing and negative space for the AI's first message. `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_11_wake-up-neo.png`, `matrix_15_knock-knock-neo.png`
6. **WarGames payphone tab hack.** The mouthpiece unscrewed and a metal tab shorting the contacts for a free call. A real physical phreak, good for a mini-game. `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_04_handset-tab-close.png`
7. **Pacific Bell home page, 1997 (Wayback).** Letterspaced lowercase labels, black-and-white family photo, ISDN banner. The best model for the fake 1996 phone-company page. `~/Scratch/neuromancer-refs/retro/pacbell-1997.png` (with AT&T WorldNet 1996 `att-worldnet-1996.png` and GTE.net 1996 `gtenet-1996.png` for real dial-up wording: "MEMBERS ONLY", "Access Dial-Up Numbers", "System Status")
8. **System 6 running live (system6.app).** The exact 1-bit window to copy: pinstripe title bar, dithered desktop, Chicago/Geneva type. https://system6.app — `~/Scratch/neuromancer-refs/retro/system6-window.png`
9. **DOOM column-melt wipe** (`mrdoob/three-doom/src/f_wipe.js`, `_initMelt()` / `wipe_ScreenWipe()`). Use it for the self-erasing floppy and the login-to-terminal cut. GPL-derived, so rewrite from the description (about 40 lines). `~/Scratch/neuromancer-refs/github/mrdoob_three-doom/src/f_wipe.js`
10. **Year Zero split HTML comments (2007).** One sentence cut into `<!-- -->` fragments across a page (`<!--nt wants you to forget.-->`). The model for view-source clues split across the 1996 site. `~/Scratch/neuromancer-refs/arg/raw/year-zero-artisresistance.html`, screenshot `~/Scratch/neuromancer-refs/arg/year-zero/artisresistance-2007.png`
11. **Mr. Robot fake terminal (whoismrrobot.com, 2016).** `root@fsociety:~# ` prompt, a fixed command list (prepare, fsociety, inform, question, wakeup, join), and an ASCII banner in view-source. `~/Scratch/neuromancer-refs/arg/mr-robot/whoismrrobot-terminal-2016.png`
12. **Portal ARG (2010): modem/SSTV audio → image → phone number + login → BBS.** The full phone-network chain in one real precedent. `~/Scratch/neuromancer-refs/arg/portal-arg/aperturescience-2010.png`; code for it: CKegel/Web-SSTV (MIT) and alexadam/img-encode `v3/js/engine.js` (image into spectrogram, MIT) `~/Scratch/neuromancer-refs/github/alexadam_img-encode`
13. **Sombra / LumériCo defaced power-company site (2016).** A `hacked-*.css` layer over a corporate page, an ASCII skull, a footer phone number and a literal `<!-- MISDIRECTION -->` comment. `~/Scratch/neuromancer-refs/arg/sombra/lumerico-hacked-2016.png`
14. **Connections Museum, "2600? How Phreaking Really Worked"**, plus Evan Doorbell's 1970 Kennedy Airport payphone tape. Real blue-box tones (Cap'n Crunch whistle at 12:57) and real recorded payphone-network sound. https://www.youtube.com/watch?v=8PmkUPBhL4U and https://www.youtube.com/watch?v=N8hgxmHnPZc ; tone code: DTMF/2600 Hz tables plus Goertzel detection (Ravenstine/goertzeljs, MIT)
15. **Booth Wi-Fi / captive portal as the level** (Bartholl's Dead Drops and Keepalive, Occupy.here, CCA Tel Aviv "Captive Portal"). A local network you must stand next to, landing on a page in story. This is how the game can extend into real booths. Pair it with an NFC sticker (Web NFC in Chrome on Android, plain URL on iPhone). https://deaddrops.com — `~/Scratch/neuromancer-refs/nfc-ssid/cca-captive-portal.png`, `~/Scratch/neuromancer-refs/nfc-ssid/bartholl-keepalive.png`

Honourable mentions: Hackers wireframe building with a "Networks → Telephone" menu (`film/hackers/frames/hackers_02_building-wireframe-networks-menu.png`), Johnny Mnemonic keypad over a world map (`film/johnny-mnemonic/frames/jm_03_world-map-keypad.png`), Person of Interest ringing payphone (`film/person-of-interest/frames/poi_12_reese-at-ringing-payphone.png`), Oldboy CCTV monitor wall (`film/oldboy/frames/oldboy_16_cctv-monitor-wall.png`), Agrippa poem in emulation (`retro/agrippa-emulation.png`), the Rezmason/matrix one-formula rain (`getRainBrightness()`, MIT).

Safety note carried from the ARG lane: keep every "hack" inside our own fake systems. No real numbers, no third-party targets, and no real fake-cell-tower or Wi-Fi interception. The Sombra ARG had players hack real people.

## Gaps (said plainly)
- Matrix: no clip showed the opening code rain (the rain frames come from the ending), the Wells St subway payphone exit or the end hotel phone. The FILMGRAB set has the opening "Matrix has you" terminal.
- Oldboy title cards come from the 2023 Arrow re-release trailer, not the 2003 cut.
- Some clips are fan uploads (WarGames payphone and war-dialer, Sneakers trace, Person of Interest, Johnny Mnemonic). The channel is named in `film/SOURCES.md`.
- FILMGRAB has no Sneakers, WarGames or Johnny Mnemonic page.
- No video found of the Neuromancer payphone scene, and no confirmed 1990s payphone footage (Muse also came up empty).
- Pacific Bell has no Wayback capture before 1997. Bell Atlantic's own 1996 site isn't archived (Bell Atlantic.net 1997 was used).
- Not confirmed: NIN "Survivalism" spectrogram, SSID clues in Mr. Robot / Westworld / Stranger Things promos, and the "Gregory" puzzle hunt.

## 1. Film frames (129)

Format: frame name — YouTube source at the timestamp — local file. FILMGRAB stills: `~/Scratch/neuromancer-refs/film/<film>/filmgrab/` (urls.txt maps each file).

- **1. matrix_01_heart-o-city-hotel-sign** — https://www.youtube.com/watch?v=bp4kJeMQ5uM&t=10s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_01_heart-o-city-hotel-sign.png`
- **2. matrix_02_trinity-laptop-cops** — https://www.youtube.com/watch?v=bp4kJeMQ5uM&t=15s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_02_trinity-laptop-cops.png`
- **3. matrix_03_trinity-phone-call** — https://www.youtube.com/watch?v=bp4kJeMQ5uM&t=50s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_03_trinity-phone-call.png`
- **4. matrix_04_payphone-booth-alley** — https://www.youtube.com/watch?v=bp4kJeMQ5uM&t=172s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_04_payphone-booth-alley.png`
- **5. matrix_05_truck-headlights** — https://www.youtube.com/watch?v=bp4kJeMQ5uM&t=179s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_05_truck-headlights.png`
- **6. matrix_06_payphone-handset-ringing** — https://www.youtube.com/watch?v=bp4kJeMQ5uM&t=181s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_06_payphone-handset-ringing.png`
- **7. matrix_07_booth-vs-truck** — https://www.youtube.com/watch?v=bp4kJeMQ5uM&t=187s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_07_booth-vs-truck.png`
- **8. matrix_08_trinity-answers-booth** — https://www.youtube.com/watch?v=bp4kJeMQ5uM&t=190s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_08_trinity-answers-booth.png`
- **9. matrix_09_agents-wreck-silhouette** — https://www.youtube.com/watch?v=bp4kJeMQ5uM&t=211s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_09_agents-wreck-silhouette.png`
- **10. matrix_10_neo-desk-overhead** — https://www.youtube.com/watch?v=sjoad6gcRzs&t=20s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_10_neo-desk-overhead.png`
- **11. matrix_11_wake-up-neo** — https://www.youtube.com/watch?v=sjoad6gcRzs&t=31s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_11_wake-up-neo.png`
- **12. matrix_12_the-matrix-has-you** — https://www.youtube.com/watch?v=sjoad6gcRzs&t=47s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_12_the-matrix-has-you.png`
- **13. matrix_13_crt-phosphor-macro** — https://www.youtube.com/watch?v=sjoad6gcRzs&t=55s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_13_crt-phosphor-macro.png`
- **14. matrix_14_follow-white-rabbit** — https://www.youtube.com/watch?v=sjoad6gcRzs&t=66s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_14_follow-white-rabbit.png`
- **15. matrix_15_knock-knock-neo** — https://www.youtube.com/watch?v=sjoad6gcRzs&t=67s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_15_knock-knock-neo.png`
- **16. matrix_16_esc-key-macro** — https://www.youtube.com/watch?v=sjoad6gcRzs&t=63s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_16_esc-key-macro.png`
- **17. matrix_17_carrier-anomaly-terminal** — https://www.youtube.com/watch?v=yyrhikYaRrk&t=9s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_17_carrier-anomaly-terminal.png`
- **18. matrix_18_code-rain** — https://www.youtube.com/watch?v=yyrhikYaRrk&t=15s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_18_code-rain.png`
- **19. matrix_19_system-failure** — https://www.youtube.com/watch?v=yyrhikYaRrk&t=30s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_19_system-failure.png`
- **20. matrix_23_neo-cellphone-corridor** — https://www.youtube.com/watch?v=rCQjv21V1iA&t=64s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_23_neo-cellphone-corridor.png`
- **21. matrix_21_neo-hangs-up-payphone** — https://www.youtube.com/watch?v=yyrhikYaRrk&t=51s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_21_neo-hangs-up-payphone.png`
- **22. matrix_22_street-phone-booth** — https://www.youtube.com/watch?v=yyrhikYaRrk&t=57s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_22_street-phone-booth.png`
- **23. matrix_24_system-failure-macro** — https://www.youtube.com/watch?v=yyrhikYaRrk&t=42s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_24_system-failure-macro.png`
- **24. matrix_25_code-tunnel** — https://www.youtube.com/watch?v=yyrhikYaRrk&t=45s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_25_code-tunnel.png`
- **25. matrix_20_handset-grille** — https://www.youtube.com/watch?v=yyrhikYaRrk&t=49s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_20_handset-grille.png`
- **26. matrix_26_subway-platform-wide** — https://www.youtube.com/watch?v=mZVsVQwlc9Y&t=45s — `~/Scratch/neuromancer-refs/film/matrix/frames/matrix_26_subway-platform-wide.png`
- **27. oldboy_01_corridor-gang-wait** — https://www.youtube.com/watch?v=gvQ7Z6ZCxTc&t=7s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_01_corridor-gang-wait.png`
- **28. oldboy_02_corridor-side-scroll** — https://www.youtube.com/watch?v=gvQ7Z6ZCxTc&t=105s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_02_corridor-side-scroll.png`
- **29. oldboy_03_corridor-aftermath** — https://www.youtube.com/watch?v=gvQ7Z6ZCxTc&t=189s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_03_corridor-aftermath.png`
- **30. oldboy_04_hazard-stripe-elevator** — https://www.youtube.com/watch?v=gvQ7Z6ZCxTc&t=210s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_04_hazard-stripe-elevator.png`
- **31. oldboy_05_cell-room-wide** — https://www.youtube.com/watch?v=nUcmrIpvq0E&t=1s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_05_cell-room-wide.png`
- **32. oldboy_06_cell-painting-korean-text** — https://www.youtube.com/watch?v=nUcmrIpvq0E&t=26s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_06_cell-painting-korean-text.png`
- **33. oldboy_07_cell-tv-static** — https://www.youtube.com/watch?v=nUcmrIpvq0E&t=91s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_07_cell-tv-static.png`
- **34. oldboy_08_tv-man-on-phone** — https://www.youtube.com/watch?v=nUcmrIpvq0E&t=182s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_08_tv-man-on-phone.png`
- **35. oldboy_09_tv-scanlines-hand** — https://www.youtube.com/watch?v=nUcmrIpvq0E&t=221s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_09_tv-scanlines-hand.png`
- **36. oldboy_10_desk-lamp-notebook** — https://www.youtube.com/watch?v=nUcmrIpvq0E&t=247s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_10_desk-lamp-notebook.png`
- **37. oldboy_11_prison-corridor** — https://www.youtube.com/watch?v=nUcmrIpvq0E&t=299s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_11_prison-corridor.png`
- **38. oldboy_12_shadowbox-taegukgi-tv** — https://www.youtube.com/watch?v=nUcmrIpvq0E&t=455s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_12_shadowbox-taegukgi-tv.png`
- **39. oldboy_14_asanoha-wallpaper-room** — https://www.youtube.com/watch?v=qCtDJH5PAGw&t=416s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_14_asanoha-wallpaper-room.png`
- **40. oldboy_15_festival-laurels-neon** — https://www.youtube.com/watch?v=w4UUGIIZxFU&t=12s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_15_festival-laurels-neon.png`
- **41. oldboy_16_cctv-monitor-wall** — https://www.youtube.com/watch?v=w4UUGIIZxFU&t=20s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_16_cctv-monitor-wall.png`
- **42. oldboy_17_imprisoned-for-15-card** — https://www.youtube.com/watch?v=w4UUGIIZxFU&t=28s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_17_imprisoned-for-15-card.png`
- **43. oldboy_18_subtitle-why-locked-up** — https://www.youtube.com/watch?v=w4UUGIIZxFU&t=60s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_18_subtitle-why-locked-up.png`
- **44. oldboy_13_villain-phone-split-screen** — https://www.youtube.com/watch?v=qCtDJH5PAGw&t=241s — `~/Scratch/neuromancer-refs/film/oldboy/frames/oldboy_13_villain-phone-split-screen.png`
- **45. hackers_01_student-record-ui** — https://www.youtube.com/watch?v=IESEcsjDcmM&t=85s — `~/Scratch/neuromancer-refs/film/hackers/frames/hackers_01_student-record-ui.png`
- **46. hackers_02_building-wireframe-networks-menu** — https://www.youtube.com/watch?v=IESEcsjDcmM&t=102s — `~/Scratch/neuromancer-refs/film/hackers/frames/hackers_02_building-wireframe-networks-menu.png`
- **47. hackers_03_cyan-numeric-terminal** — https://www.youtube.com/watch?v=IESEcsjDcmM&t=136s — `~/Scratch/neuromancer-refs/film/hackers/frames/hackers_03_cyan-numeric-terminal.png`
- **48. hackers_04_menu-scientific-expend** — https://www.youtube.com/watch?v=IESEcsjDcmM&t=187s — `~/Scratch/neuromancer-refs/film/hackers/frames/hackers_04_menu-scientific-expend.png`
- **49. hackers_05_concourse-bank-laptop** — https://www.youtube.com/watch?v=IESEcsjDcmM&t=204s — `~/Scratch/neuromancer-refs/film/hackers/frames/hackers_05_concourse-bank-laptop.png`
- **50. hackers_06_payphone-arcade** — https://www.youtube.com/watch?v=IESEcsjDcmM&t=238s — `~/Scratch/neuromancer-refs/film/hackers/frames/hackers_06_payphone-arcade.png`
- **51. hackers_07_gibson-towers** — https://www.youtube.com/watch?v=IESEcsjDcmM&t=357s — `~/Scratch/neuromancer-refs/film/hackers/frames/hackers_07_gibson-towers.png`
- **52. hackers_08_purple-circuit-city** — https://www.youtube.com/watch?v=IESEcsjDcmM&t=442s — `~/Scratch/neuromancer-refs/film/hackers/frames/hackers_08_purple-circuit-city.png`
- **53. hackers_09_circuit-city-flyover** — https://www.youtube.com/watch?v=Rn2cf_wJ4f4&t=22s — `~/Scratch/neuromancer-refs/film/hackers/frames/hackers_09_circuit-city-flyover.png`
- **54. hackers_10_status-deceased-ui** — https://www.youtube.com/watch?v=Rn2cf_wJ4f4&t=60s — `~/Scratch/neuromancer-refs/film/hackers/frames/hackers_10_status-deceased-ui.png`
- **55. hackers_11_wall-payphone-call** — https://www.youtube.com/watch?v=Rn2cf_wJ4f4&t=95s — `~/Scratch/neuromancer-refs/film/hackers/frames/hackers_11_wall-payphone-call.png`
- **56. hackers_12_title-decode-glyphs** — https://www.youtube.com/watch?v=Rn2cf_wJ4f4&t=150s — `~/Scratch/neuromancer-refs/film/hackers/frames/hackers_12_title-decode-glyphs.png`
- **57. jm_01_vr-rig-grid-desk** — https://www.youtube.com/watch?v=QQWNDoJRYvE&t=63s — `~/Scratch/neuromancer-refs/film/johnny-mnemonic/frames/jm_01_vr-rig-grid-desk.png`
- **58. jm_02_cyberspace-glove-hands** — https://www.youtube.com/watch?v=QQWNDoJRYvE&t=72s — `~/Scratch/neuromancer-refs/film/johnny-mnemonic/frames/jm_02_cyberspace-glove-hands.png`
- **59. jm_03_world-map-keypad** — https://www.youtube.com/watch?v=QQWNDoJRYvE&t=90s — `~/Scratch/neuromancer-refs/film/johnny-mnemonic/frames/jm_03_world-map-keypad.png`
- **60. jm_04_access-gold-cyberspace** — https://www.youtube.com/watch?v=QQWNDoJRYvE&t=108s — `~/Scratch/neuromancer-refs/film/johnny-mnemonic/frames/jm_04_access-gold-cyberspace.png`
- **61. jm_05_cyan-ring-nodes** — https://www.youtube.com/watch?v=QQWNDoJRYvE&t=153s — `~/Scratch/neuromancer-refs/film/johnny-mnemonic/frames/jm_05_cyan-ring-nodes.png`
- **62. jm_06_search-copyshop-found-hud** — https://www.youtube.com/watch?v=QQWNDoJRYvE&t=162s — `~/Scratch/neuromancer-refs/film/johnny-mnemonic/frames/jm_06_search-copyshop-found-hud.png`
- **63. jm_07_ice-face-frame** — https://www.youtube.com/watch?v=QQWNDoJRYvE&t=234s — `~/Scratch/neuromancer-refs/film/johnny-mnemonic/frames/jm_07_ice-face-frame.png`
- **64. jm_09_search-fax-buffer-hud** — https://www.youtube.com/watch?v=EFJY_BZ55sI&t=20s — `~/Scratch/neuromancer-refs/film/johnny-mnemonic/frames/jm_09_search-fax-buffer-hud.png`
- **65. jm_11_cyberspace-tunnel** — https://www.youtube.com/watch?v=EFJY_BZ55sI&t=40s — `~/Scratch/neuromancer-refs/film/johnny-mnemonic/frames/jm_11_cyberspace-tunnel.png`
- **66. jm_12_att-wall-phone-keypad** — https://www.youtube.com/watch?v=EFJY_BZ55sI&t=19s — `~/Scratch/neuromancer-refs/film/johnny-mnemonic/frames/jm_12_att-wall-phone-keypad.png`
- **67. jm_13_brain-scan-ui** — https://www.youtube.com/watch?v=EFJY_BZ55sI&t=28s — `~/Scratch/neuromancer-refs/film/johnny-mnemonic/frames/jm_13_brain-scan-ui.png`
- **68. jm_14_red-green-laser-scan** — https://www.youtube.com/watch?v=EFJY_BZ55sI&t=25s — `~/Scratch/neuromancer-refs/film/johnny-mnemonic/frames/jm_14_red-green-laser-scan.png`
- **69. gits_01_tower-night-cityscape** — https://www.youtube.com/watch?v=VaslYlFrGh8&t=0s — `~/Scratch/neuromancer-refs/film/ghost-in-the-shell/frames/gits_01_tower-night-cityscape.png`
- **70. gits_02_kusanagi-listening-coat** — https://www.youtube.com/watch?v=VaslYlFrGh8&t=12s — `~/Scratch/neuromancer-refs/film/ghost-in-the-shell/frames/gits_02_kusanagi-listening-coat.png`
- **71. gits_03_green-thermal-view** — https://www.youtube.com/watch?v=VaslYlFrGh8&t=30s — `~/Scratch/neuromancer-refs/film/ghost-in-the-shell/frames/gits_03_green-thermal-view.png`
- **72. gits_04_neck-jack-cable** — https://www.youtube.com/watch?v=VaslYlFrGh8&t=48s — `~/Scratch/neuromancer-refs/film/ghost-in-the-shell/frames/gits_04_neck-jack-cable.png`
- **73. gits_06_operator-console** — https://www.youtube.com/watch?v=VaslYlFrGh8&t=66s — `~/Scratch/neuromancer-refs/film/ghost-in-the-shell/frames/gits_06_operator-console.png`
- **74. gits_07_dive-over-city** — https://www.youtube.com/watch?v=VaslYlFrGh8&t=90s — `~/Scratch/neuromancer-refs/film/ghost-in-the-shell/frames/gits_07_dive-over-city.png`
- **75. gits_08_cyborg-assembly-green-code** — https://www.youtube.com/watch?v=rU6Matng9MU&t=6s — `~/Scratch/neuromancer-refs/film/ghost-in-the-shell/frames/gits_08_cyborg-assembly-green-code.png`
- **76. gits_09_title-circuit-glitch** — https://www.youtube.com/watch?v=rU6Matng9MU&t=18s — `~/Scratch/neuromancer-refs/film/ghost-in-the-shell/frames/gits_09_title-circuit-glitch.png`
- **77. gits_10_hong-kong-signage** — https://www.youtube.com/watch?v=rU6Matng9MU&t=24s — `~/Scratch/neuromancer-refs/film/ghost-in-the-shell/frames/gits_10_hong-kong-signage.png`
- **78. gits_11_kusanagi-under-signs** — https://www.youtube.com/watch?v=rU6Matng9MU&t=30s — `~/Scratch/neuromancer-refs/film/ghost-in-the-shell/frames/gits_11_kusanagi-under-signs.png`
- **79. gits_05_overhead-grey-surveillance** — https://www.youtube.com/watch?v=VaslYlFrGh8&t=57s — `~/Scratch/neuromancer-refs/film/ghost-in-the-shell/frames/gits_05_overhead-grey-surveillance.png`
- **80. sd_01_squid-minidisc** — https://www.youtube.com/watch?v=I_CRzVM1GuM&t=18s — `~/Scratch/neuromancer-refs/film/strange-days/frames/sd_01_squid-minidisc.png`
- **81. sd_02_title-over-city** — https://www.youtube.com/watch?v=I_CRzVM1GuM&t=42s — `~/Scratch/neuromancer-refs/film/strange-days/frames/sd_02_title-over-city.png`
- **82. sd_03_blue-club-light** — https://www.youtube.com/watch?v=I_CRzVM1GuM&t=48s — `~/Scratch/neuromancer-refs/film/strange-days/frames/sd_03_blue-club-light.png`
- **83. sd_05_blue-gloved-hand** — https://www.youtube.com/watch?v=I_CRzVM1GuM&t=72s — `~/Scratch/neuromancer-refs/film/strange-days/frames/sd_05_blue-gloved-hand.png`
- **84. sd_06_y2k-crowd** — https://www.youtube.com/watch?v=I_CRzVM1GuM&t=126s — `~/Scratch/neuromancer-refs/film/strange-days/frames/sd_06_y2k-crowd.png`
- **85. sd_08_purple-glyph-burst** — https://www.youtube.com/watch?v=I_CRzVM1GuM&t=180s — `~/Scratch/neuromancer-refs/film/strange-days/frames/sd_08_purple-glyph-burst.png`
- **86. sneakers_01_world-trace-monitor** — https://www.youtube.com/watch?v=2MksA819Bug&t=63s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_01_world-trace-monitor.png`
- **87. sneakers_02_trace-nodes-usa** — https://www.youtube.com/watch?v=2MksA819Bug&t=126s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_02_trace-nodes-usa.png`
- **88. sneakers_03_desk-phone-keypad** — https://www.youtube.com/watch?v=2MksA819Bug&t=133s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_03_desk-phone-keypad.png`
- **89. sneakers_04_trace-cairo** — https://www.youtube.com/watch?v=2MksA819Bug&t=140s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_04_trace-cairo.png`
- **90. sneakers_05_seismograph-pen** — https://www.youtube.com/watch?v=2MksA819Bug&t=147s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_05_seismograph-pen.png`
- **91. sneakers_06_whistler-headphones-map** — https://www.youtube.com/watch?v=2MksA819Bug&t=154s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_06_whistler-headphones-map.png`
- **92. sneakers_07_full-trace-map** — https://www.youtube.com/watch?v=2MksA819Bug&t=168s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_07_full-trace-map.png`
- **93. sneakers_08_whistler-terminal** — https://www.youtube.com/watch?v=F5bAa6gFvLs&t=0s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_08_whistler-terminal.png`
- **94. sneakers_09_garbled-decrypt** — https://www.youtube.com/watch?v=F5bAa6gFvLs&t=48s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_09_garbled-decrypt.png`
- **95. sneakers_10_whistler-crease-terminal** — https://www.youtube.com/watch?v=F5bAa6gFvLs&t=54s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_10_whistler-crease-terminal.png`
- **96. sneakers_11_dark-office-lamp** — https://www.youtube.com/watch?v=F5bAa6gFvLs&t=90s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_11_dark-office-lamp.png`
- **97. sneakers_12_federal-reserve-menu** — https://www.youtube.com/watch?v=F5bAa6gFvLs&t=53s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_12_federal-reserve-menu.png`
- **98. sneakers_13_energy-grid-map** — https://www.youtube.com/watch?v=F5bAa6gFvLs&t=88s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_13_energy-grid-map.png`
- **99. sneakers_14_goldstar-terminal-text** — https://www.youtube.com/watch?v=F5bAa6gFvLs&t=75s — `~/Scratch/neuromancer-refs/film/sneakers/frames/sneakers_14_goldstar-terminal-text.png`
- **100. wargames_01_roadside-booth-truck** — https://www.youtube.com/watch?v=zkMX4s6ZstQ&t=15s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_01_roadside-booth-truck.png`
- **101. wargames_02_david-in-booth** — https://www.youtube.com/watch?v=zkMX4s6ZstQ&t=25s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_02_david-in-booth.png`
- **102. wargames_03_unscrew-mouthpiece** — https://www.youtube.com/watch?v=zkMX4s6ZstQ&t=40s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_03_unscrew-mouthpiece.png`
- **103. wargames_04_handset-tab-close** — https://www.youtube.com/watch?v=zkMX4s6ZstQ&t=70s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_04_handset-tab-close.png`
- **104. wargames_05_through-booth-glass** — https://www.youtube.com/watch?v=zkMX4s6ZstQ&t=85s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_05_through-booth-glass.png`
- **105. wargames_06_rotary-dial-close** — https://www.youtube.com/watch?v=zkMX4s6ZstQ&t=125s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_06_rotary-dial-close.png`
- **106. wargames_07_bedroom-phone-call** — https://www.youtube.com/watch?v=zb1r_uKOew4&t=0s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_07_bedroom-phone-call.png`
- **107. wargames_08_bedroom-rig-wide** — https://www.youtube.com/watch?v=zb1r_uKOew4&t=24s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_08_bedroom-rig-wide.png`
- **108. wargames_09_scan-carrier-tones** — https://www.youtube.com/watch?v=zb1r_uKOew4&t=48s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_09_scan-carrier-tones.png`
- **109. wargames_10_dialing-list-prefixes** — https://www.youtube.com/watch?v=zb1r_uKOew4&t=69s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_10_dialing-list-prefixes.png`
- **110. wargames_11_launch-code-readout** — https://www.youtube.com/watch?v=F7qOV8xonfY&t=4s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_11_launch-code-readout.png`
- **111. wargames_12_wopr-tic-tac-toe** — https://www.youtube.com/watch?v=F7qOV8xonfY&t=36s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_12_wopr-tic-tac-toe.png`
- **112. wargames_15_wopr-led-banks** — https://www.youtube.com/watch?v=F7qOV8xonfY&t=52s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_15_wopr-led-banks.png`
- **113. wargames_16_david-looks-up** — https://www.youtube.com/watch?v=F7qOV8xonfY&t=66s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_16_david-looks-up.png`
- **114. wargames_17_wopr-led-face** — https://www.youtube.com/watch?v=F7qOV8xonfY&t=79s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_17_wopr-led-face.png`
- **115. wargames_18_tic-tac-toe-fullscreen** — https://www.youtube.com/watch?v=F7qOV8xonfY&t=83s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_18_tic-tac-toe-fullscreen.png`
- **116. wargames_19_game-time-remaining** — https://www.youtube.com/watch?v=F7qOV8xonfY&t=75s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_19_game-time-remaining.png`
- **117. wargames_20_wopr-map-screens-tictactoe** — https://www.youtube.com/watch?v=F7qOV8xonfY&t=63s — `~/Scratch/neuromancer-refs/film/wargames/frames/wargames_20_wopr-map-screens-tictactoe.png`
- **118. poi_01_reese-and-root-street** — https://www.youtube.com/watch?v=SE0VfoKmlpo&t=18s — `~/Scratch/neuromancer-refs/film/person-of-interest/frames/poi_01_reese-and-root-street.png`
- **119. poi_02_cctv-park-zone-payphone** — https://www.youtube.com/watch?v=SE0VfoKmlpo&t=30s — `~/Scratch/neuromancer-refs/film/person-of-interest/frames/poi_02_cctv-park-zone-payphone.png`
- **120. poi_03_threat-confirmed-hud** — https://www.youtube.com/watch?v=SE0VfoKmlpo&t=33s — `~/Scratch/neuromancer-refs/film/person-of-interest/frames/poi_03_threat-confirmed-hud.png`
- **121. poi_04_locating-hud** — https://www.youtube.com/watch?v=SE0VfoKmlpo&t=36s — `~/Scratch/neuromancer-refs/film/person-of-interest/frames/poi_04_locating-hud.png`
- **122. poi_07_day-3791-surveillance** — https://www.youtube.com/watch?v=VM3uOmmEnGw&t=2s — `~/Scratch/neuromancer-refs/film/person-of-interest/frames/poi_07_day-3791-surveillance.png`
- **123. poi_08_street-payphone-crowd** — https://www.youtube.com/watch?v=VM3uOmmEnGw&t=22s — `~/Scratch/neuromancer-refs/film/person-of-interest/frames/poi_08_street-payphone-crowd.png`
- **124. poi_09_handset-at-ear** — https://www.youtube.com/watch?v=VM3uOmmEnGw&t=28s — `~/Scratch/neuromancer-refs/film/person-of-interest/frames/poi_09_handset-at-ear.png`
- **125. poi_10_payphone-wide-street** — https://www.youtube.com/watch?v=VM3uOmmEnGw&t=38s — `~/Scratch/neuromancer-refs/film/person-of-interest/frames/poi_10_payphone-wide-street.png`
- **126. poi_11_cctv-street-corner** — https://www.youtube.com/watch?v=VM3uOmmEnGw&t=42s — `~/Scratch/neuromancer-refs/film/person-of-interest/frames/poi_11_cctv-street-corner.png`
- **127. poi_06_payphone-close** — https://www.youtube.com/watch?v=SE0VfoKmlpo&t=17s — `~/Scratch/neuromancer-refs/film/person-of-interest/frames/poi_06_payphone-close.png`
- **128. poi_12_reese-at-ringing-payphone** — https://www.youtube.com/watch?v=SE0VfoKmlpo&t=29s — `~/Scratch/neuromancer-refs/film/person-of-interest/frames/poi_12_reese-at-ringing-payphone.png`
- **129. poi_13_location-found-hud** — https://www.youtube.com/watch?v=SE0VfoKmlpo&t=39s — `~/Scratch/neuromancer-refs/film/person-of-interest/frames/poi_13_location-found-hud.png`

## 2. GitHub code

Stars and license from `gh api`, checked 2026-11-19. GPL or no license means study only. The core-technique file and function for each of the 9 clones is in `github/LANE.md`. The last 13 or so entries are search-only leads.

- **Rezmason/matrix** — https://github.com/Rezmason/matrix — 3,869 stars, MIT (cloned: `~/Scratch/neuromancer-refs/github/Rezmason_matrix`)
- **tidwall/digitalrain** — https://github.com/tidwall/digitalrain — 389 stars, MIT
- **emilyxxie/green_rain** — https://github.com/emilyxxie/green_rain — 265 stars, NO LICENSE (study only)
- **domsson/fakesteak** — https://github.com/domsson/fakesteak — 132 stars, CC0
- **Swordfish90/cool-retro-term** — https://github.com/Swordfish90/cool-retro-term — 26,576 stars, GitHub reports no SPDX
- **remojansen/cool-retro-term-webgl** — https://github.com/remojansen/cool-retro-term-webgl — 43 stars, **GPL-3.0 (cloned: `~/Scratch/neuromancer-refs/github/remojansen_cool-retro-term-webgl`)
- **RetroCrisis/Retro-Crisis-GDV-NTSC** — https://github.com/RetroCrisis/Retro-Crisis-GDV-NTSC — 482 stars, license not checked in detail (libretro presets). Reference for NTSC artifact settings only.

**luiscarlospando/crt-shader-with-chromatic-aberration-glow-scanlines-dot-matrix**. 82 stars
- **luiscarlospando/crt-shader-with-chromatic-aberration-glow-scanlines-dot-matrix** — https://github.com/luiscarlospando/crt-shader-with-chromatic-aberration-glow-scanlines-dot-matrix — 82 stars, ?
- **qarlosh/CRTSim-WebGL** — https://github.com/qarlosh/CRTSim-WebGL — 2 stars, MIT
- **duiker101/Hacker-Typer** — https://github.com/duiker101/Hacker-Typer — 715 stars, MIT (cloned: `~/Scratch/neuromancer-refs/github/duiker101_Hacker-Typer`)
- **jarne/HackerDesktop** — https://github.com/jarne/HackerDesktop — 3 stars, MIT
- **dzumq/Hackermode** — https://github.com/dzumq/Hackermode — 28 stars, MIT
- **xtermjs/xterm.js** — https://github.com/xtermjs/xterm.js — 21,371 stars, MIT
- **wavesoft/local-echo** — https://github.com/wavesoft/local-echo — 166 stars, Apache-2.0
- **coder/ghostty-web** — https://github.com/coder/ghostty-web — 3,073 stars, MIT
- **jcubic/jquery.terminal** — https://github.com/jcubic/jquery.terminal — 3,242 stars, MIT
- **chromakode/xkcdfools** — https://github.com/chromakode/xkcdfools — 569 stars, **GPL-2.0 (cloned: `~/Scratch/neuromancer-refs/github/chromakode_xkcdfools`)
- **satnaing/terminal-portfolio** — https://github.com/satnaing/terminal-portfolio — 832 stars, MIT
- **billchurch/webssh2** — https://github.com/billchurch/webssh2 — 2,784 stars, ?
- **cryptool-org/openssl-webterm** — https://github.com/cryptool-org/openssl-webterm — 113 stars, MIT
- **galacticpuzzlehunt/gph-site** — https://github.com/galacticpuzzlehunt/gph-site — 83 stars, MIT
- **teammatehunt/tph-site** — https://github.com/teammatehunt/tph-site — 10 stars, MIT
- **dlareau/puzzlehunt_server** — https://github.com/dlareau/puzzlehunt_server — 19 stars, MIT
- **galacticpuzzlehunt/puzzlord** — https://github.com/galacticpuzzlehunt/puzzlord — 33 stars, NO LICENSE (study only)
- **orangetw/My-CTF-Web-Challenges** — https://github.com/orangetw/My-CTF-Web-Challenges — 2,862 stars, NO LICENSE (study only)
- **LiveOverflow/ctf-screenshotter** — https://github.com/LiveOverflow/ctf-screenshotter — 225 stars, NO LICENSE (study only)
- **feross/filldisk.com** — https://github.com/feross/filldisk.com — 914 stars, NO LICENSE (study only)
- **schappim/90s-components** — https://github.com/schappim/90s-components — 0 stars, MIT
- **disconnex/carrier** — https://github.com/disconnex/carrier — 0 stars, MIT (cloned: `~/Scratch/neuromancer-refs/github/disconnex_carrier`)
- **mrdoob/three-doom** — https://github.com/mrdoob/three-doom — 25 stars, NO LICENSE file (derived from GPL-2 DOOM source: **study only**) (cloned: `~/Scratch/neuromancer-refs/github/mrdoob_three-doom`)
- **greggman/WebGPU-DOOM** — https://github.com/greggman/WebGPU-DOOM — 13 stars, **GPL-2.0
- **gl-transitions/gl-transitions** — https://github.com/gl-transitions/gl-transitions — 2,261 stars, NOASSERTION at repo level (each transition carries its own license header
- **kant003/doomJavascript** — https://github.com/kant003/doomJavascript — 0 stars, GPL-2.0. Another TS port with `f_wipe.ts`; redundant.
## 7. Classic Mac UI and 1-bit dithering
**npjg/classic.css** (CLONED). 240 stars
- **npjg/classic.css** — https://github.com/npjg/classic.css — 240 stars, MIT (cloned: `~/Scratch/neuromancer-refs/github/npjg_classic.css`)
- **mihaip/infinite-mac** — https://github.com/mihaip/infinite-mac — 1,656 stars, Apache-2.0
- **bzotto/ClassicMacTypography** — https://github.com/bzotto/ClassicMacTypography — 122 stars, MIT. Extracted original Mac bitmap fonts and tooling; source for pixel-exact Chicago/Geneva/Monaco.
**Kelsidavis/System7**. 379 stars
- **Kelsidavis/System7** — https://github.com/Kelsidavis/System7 — 379 stars, MIT. From-scratch reimplementation of System 7 (C
- **gazs/canvas-atkinson-dither** — https://github.com/gazs/canvas-atkinson-dither — 90 stars, **GPL-3.0
- **makew0rld/didder** — https://github.com/makew0rld/didder — 533 stars, **GPL-3.0
- **Tezumie/Image-to-Pixel** — https://github.com/Tezumie/Image-to-Pixel — 564 stars, MIT
- **alexadam/img-encode** — https://github.com/alexadam/img-encode — 292 stars, MIT (cloned: `~/Scratch/neuromancer-refs/github/alexadam_img-encode`)
- **kylophone/ascii-audio** — https://github.com/kylophone/ascii-audio — 45 stars, MIT. Same trick for text strings; smaller
- **CKegel/Web-SSTV** — https://github.com/CKegel/Web-SSTV — 101 stars, MIT
- **pefech/js-sstv** — https://github.com/pefech/js-sstv — 255 stars, ?
- **olgamiller/SSTVEncoder2** — https://github.com/olgamiller/SSTVEncoder2 — 255 stars, Apache-2.0. Android SSTV encoder; clean reference implementation of Martin/Scottie/Robot modes.
**dnet/pySSTV**. 190 stars
- **dnet/pySSTV** — https://github.com/dnet/pySSTV — 190 stars, MIT. Python SSTV generator; easiest offline tool to bake SSTV WAVs for the game.
**xdsopl/robot36**. 523 stars
- **xdsopl/robot36** — https://github.com/xdsopl/robot36 — 523 stars, 0BSD. SSTV decoder (Android). What players would use to decode; test target.
**Ravenstine/goertzeljs**. 79 stars
- **Ravenstine/goertzeljs** — https://github.com/Ravenstine/goertzeljs — 79 stars, MIT. Goertzel algorithm in JS with a DTMF detector. Lets the game *listen* for DTMF/2600 Hz played by the player (mic or keypad)
- **code4sabae/dtmf** — https://github.com/code4sabae/dtmf — 6 stars, MIT. Tiny DTMF tone generator (`DTMF.js`) plus Pokebell (Japanese pager) encoding. Minimal row/column frequency table + two oscillators.
**treasonx/DTMFDialPad**. 11 stars
- **treasonx/DTMFDialPad** — https://github.com/treasonx/DTMFDialPad — 11 stars, NO LICENSE (study only). WebAudio dial pad; old but simple.
**ribt/dtmf-decoder**. 329 stars
- **ribt/dtmf-decoder** — https://github.com/ribt/dtmf-decoder — 329 stars, NO LICENSE (study only). Python: extract dialed numbers from a recording. Puzzle idea: the player decodes a number from a recorded call.
**zeyus/Python3BlueBox**. 23 stars
- **zeyus/Python3BlueBox** — https://github.com/zeyus/Python3BlueBox — 23 stars, MIT. Blue box: 2600 Hz + MF (multi-frequency) tones
- **litui/dtmf_dolphin** — https://github.com/litui/dtmf_dolphin — 215 stars, **GPL-3.0
- **Fortyseven/ToneDef** — https://github.com/Fortyseven/ToneDef — 73 stars, NO LICENSE (study only)
- **fagci/dsp** — https://github.com/fagci/dsp — 3 stars, NO LICENSE (study only)
- **petereigenschink/steganography.js** — https://github.com/petereigenschink/steganography.js — 374 stars, MIT (cloned: `~/Scratch/neuromancer-refs/github/petereigenschink_steganography.js`)
- **thavixt/steganography-js** — https://github.com/thavixt/steganography-js — 12 stars, ?
- **metallurgical/LSB-steganography-javascript** — https://github.com/metallurgical/LSB-steganography-javascript — 12 stars, NOASSERTION (study only until license file checked)
- **atdt/escapes.js** — https://github.com/atdt/escapes.js — 420 stars, NOASSERTION (study only until license file checked)
- **drudru/ansi_up** — https://github.com/drudru/ansi_up — 877 stars, MIT. ANSI escape codes to HTML
- **rickparrish/fTelnet** — https://github.com/rickparrish/fTelnet — 78 stars, **AGPL-3.0
- **mkrueger/icy_tools** — https://github.com/mkrueger/icy_tools — 201 stars, Apache-2.0. IcyDraw/IcyTerm/IcyView: modern ANSI editor + BBS terminal (Rust). Tool to author the game's ANSI screens.
**durdraw/durdraw**. 1
- **durdraw/durdraw** — https://github.com/durdraw/durdraw — 1,862 stars, ?
- **yaronn/blessed-contrib** — https://github.com/yaronn/blessed-contrib — 15,773 stars, ?

## 3. ARGs and puzzle sites (26)

Format: name — archived link — local screenshot. Exact source quotes and write-up links are in `arg/LANE.md`.

- **1. I Love Bees (Halo 2, 42 Entertainment) — 2004** — https://web.archive.org/web/20040718062356/http://ilovebees.com/ — `~/Scratch/neuromancer-refs/arg/i-love-bees/ilb-home-2004-07-18.png`
- **2. Cicada 3301 — 2012 (and 2013, 2014)** — https://web.archive.org/web/20131001102524/http://uncovering-cicada.wikia.com/wiki/Category:LINKS_AND_INFORMATIONS_ON_CICADA_PUZZLES_FROM_2012 — `~/Scratch/neuromancer-refs/arg/cicada-3301/cicada-wikipedia.png`
- **3. Year Zero (Nine Inch Nails, 42 Entertainment) — 2007** — https://web.archive.org/web/20070301203934/http://iamtryingtobelieve.com:80/ — `~/Scratch/neuromancer-refs/arg/year-zero/iamtryingtobelieve-2007.png`
- **4. The Lost Experience (ABC, Lost) — 2006** — https://web.archive.org/web/20060525092343/http://thehansofoundation.org:80/ — `~/Scratch/neuromancer-refs/arg/lost-experience/hanso-foundation-2006.png`
- **5. Why So Serious? (The Dark Knight, 42 Entertainment) — 2007–08** — https://web.archive.org/web/20070714013816/http://ibelieveinharveydent.com/ — `~/Scratch/neuromancer-refs/arg/why-so-serious/whysoserious-steprightup-2008.png`
- **6. Majestic (EA) — 2001** — https://web.archive.org/web/20010926093124/http://majestic.ea.com:80/ — `~/Scratch/neuromancer-refs/arg/majestic/majestic-wikipedia.png`
- **7. The Beast (A.I. Artificial Intelligence, Microsoft) — 2001** — https://web.archive.org/web/20010505214519/http://www.jeaninesalla.com:80/ — `~/Scratch/neuromancer-refs/arg/the-beast/jeaninesalla-2001.png`
- **8. Webdriver Torso — 2013–14** — https://en.wikipedia.org/wiki/Webdriver_Torso — `~/Scratch/neuromancer-refs/arg/webdriver-torso/webdriver-torso-wikipedia.png`
- **9. Petscop — 2017–19** — https://en.wikipedia.org/wiki/Petscop — `~/Scratch/neuromancer-refs/arg/petscop/petscop-wikipedia.png`
- **10. Notpron — 2004–** — https://web.archive.org/web/20050731075310/http://www.notpron.com/notpron.htm — `~/Scratch/neuromancer-refs/arg/notpron/notpron-2005.png`
- **11. Perplex City (Mind Candy) — 2005–07** — https://web.archive.org/web/20060101090656/http://www.perplexcity.com:80/ — `~/Scratch/neuromancer-refs/arg/perplex-city/perplexcity-2006.png`
- **12. Aphex Twin, "Windowlicker" EP — 1999** — https://en.wikipedia.org/wiki/Windowlicker — `~/Scratch/neuromancer-refs/arg/windowlicker/windowlicker-wikipedia.png`
- **13. Portal ARG (Valve, "Transmission Received") — March 2010** — https://web.archive.org/web/20100308011912/http://aperturescience.com:80/ — `~/Scratch/neuromancer-refs/arg/portal-arg/portalwiki-portal-arg.png`
- **14. Cloverfield (Slusho / 1-18-08) — 2007** — https://web.archive.org/web/20071028175905/http://www.1-18-08.com:80/ — `~/Scratch/neuromancer-refs/arg/cloverfield/1-18-08-2007.png`
- **15. Mr. Robot — whoismrrobot.com fsociety terminal — 2015–16** — https://web.archive.org/web/20160103103806/http://www.whoismrrobot.com:80/ — `~/Scratch/neuromancer-refs/arg/mr-robot/whoismrrobot-terminal-2016.png`
- **16. Westworld — discoverwestworld.com / Delos — 2016** — https://web.archive.org/web/20161029235555/https://www.discoverwestworld.com/ — `~/Scratch/neuromancer-refs/arg/westworld/discoverwestworld-2016.png`
- **17. Sombra ARG (Overwatch, Blizzard) — 2016** — https://web.archive.org/web/20161102151132/https://lumerico.mx/ — `~/Scratch/neuromancer-refs/arg/sombra/lumerico-hacked-2016.png`
- **18. Fez (Polytron) — 2012** — https://en.wikipedia.org/wiki/Fez_(video_game) — `~/Scratch/neuromancer-refs/arg/fez/fez-wikipedia.png`
- **19. Frog Fractions 2 ARG (Twinbeard) — 2014–16** — http://twinbread.com — `~/Scratch/neuromancer-refs/arg/frog-fractions-2/twinbread-2016.png`
- **20. Year Walk (Simogo) — 2013** — https://en.wikipedia.org/wiki/Year_Walk — `~/Scratch/neuromancer-refs/arg/year-walk/year-walk-wikipedia.png`
- **21. DOOM (2016) soundtrack spectrogram — Mick Gordon** — https://www.engadget.com/2016/05/29/doom-hides-images-in-soundtrack/ — `~/Scratch/neuromancer-refs/arg/doom-2016-spectrogram/engadget-doom-spectrogram.png`
- **22. The Jejune Institute (Nonchalance, San Francisco) — 2008–11** — https://web.archive.org/web/20081217030520/http://jejuneinstitute.org:80/ — `~/Scratch/neuromancer-refs/arg/jejune-institute/jejuneinstitute-2008.png`
- **23. The Python Challenge — 2005–** — https://web.archive.org/web/20051225090521/http://www.pythonchallenge.com:80/ — `~/Scratch/neuromancer-refs/arg/python-challenge/pythonchallenge-level2-ocr.png`
- **24. MIT Mystery Hunt — 1981–** — https://web.archive.org/web/20100115222427/http://www.mit.edu:80/~puzzle/ — `~/Scratch/neuromancer-refs/arg/mit-mystery-hunt/mit-puzzle-2010.png`
- **25. Microsoft Puzzlehunt — 1999–** — https://en.wikipedia.org/wiki/Microsoft_Puzzlehunt — `~/Scratch/neuromancer-refs/arg/microsoft-puzzlehunt/microsoft-puzzlehunt-wikipedia.png`
- **26. Hack This Site — 2003– (CTF-like wargame)** — https://web.archive.org/web/20050102091651/http://www.hackthissite.org:80/ — `~/Scratch/neuromancer-refs/arg/hackthissite/hackthissite-2005.png`

## 4. Retro UI you can open live (44)

- **1. System 6.0.8 via system6.app (Infinite Mac)** — https://system6.app — `~/Scratch/neuromancer-refs/retro/system6.png`
- **2. System 7.5.3 via system7.app** — https://system7.app — `~/Scratch/neuromancer-refs/retro/system7.png`
- **3. Infinite Mac: System 1.0 (1984)** — https://infinitemac.org/1984/System%201.0 — `~/Scratch/neuromancer-refs/retro/infinitemac-system1.png`
- **4. Infinite Mac: Mac OS 8.1, plus the home index** — https://infinitemac.org/1998/Mac%20OS%208.1 — `~/Scratch/neuromancer-refs/retro/infinitemac-macos81.png`
- **5. HyperCard Simulator** — https://hcsimulator.com — `~/Scratch/neuromancer-refs/retro/hcsimulator.png`
- **6. Internet Archive: HyperCard Stacks, including NEUROBLAST Cyberdelia running in emulation** — https://archive.org/details/hypercardstacks — `~/Scratch/neuromancer-refs/retro/ia-hypercardstacks.png`
- **7. Internet Archive Software Library: Macintosh** — https://archive.org/details/softwarelibrary_mac — `~/Scratch/neuromancer-refs/retro/ia-softwarelibrary-mac.png`
- **8. os.ryo.lu (ryOS)** — https://os.ryo.lu — `~/Scratch/neuromancer-refs/retro/os-ryo-lu.png`
- **9. Poolsuite** — https://poolsuite.net — `~/Scratch/neuromancer-refs/retro/poolsuite.png`
- **10. Pacific Bell, 1997** — https://web.archive.org/web/19971211083351/http://www.pacbell.com:80/home.html — `~/Scratch/neuromancer-refs/retro/pacbell-1997.png`
- **11. AT&T, 1996** — https://web.archive.org/web/19961220023653/http://www.att.com:80/ — `~/Scratch/neuromancer-refs/retro/att-1996.png`
- **12. AT&T WorldNet, 1996 and 1997 (dial-up ISP)** — https://web.archive.org/web/19961221050912/http://www.att.com:80/worldnet/ — `~/Scratch/neuromancer-refs/retro/att-worldnet-1996.png`
- **13. GTE and GTE.net, 1996** — https://web.archive.org/web/19961227201753/http://www.gte.com:80/ — `~/Scratch/neuromancer-refs/retro/gte-1996.png`
- **14. US West and US West !NTERACT, 1996–97** — https://web.archive.org/web/19970208045046/http://www.uswest.com:80/ — `~/Scratch/neuromancer-refs/retro/uswest-1997.png`
- **15. Bell Atlantic.net, 1997** — https://web.archive.org/web/19970404152006/http://www.bellatlantic.net:80/ — `~/Scratch/neuromancer-refs/retro/bellatlanticnet-1997.png`
- **16. NYNEX, 1996** — https://web.archive.org/web/19961222170744/http://www.nynex.com:80/ — `~/Scratch/neuromancer-refs/retro/nynex-1996.png`
- **17. Bell System Memorial (modern fan archive)** — https://bellsystemmemorial.com — `~/Scratch/neuromancer-refs/retro/bellsystemmemorial.png`
- **18. 2600, 1996** — https://web.archive.org/web/19961218214247/http://www.2600.com:80/ — `~/Scratch/neuromancer-refs/retro/2600-1996.png`
- **19. Phrack** — http://phrack.org — `~/Scratch/neuromancer-refs/retro/phrack.png`
- **20. textfiles.com phreak section and 1AESS file** — http://textfiles.com/phreak/ — `~/Scratch/neuromancer-refs/retro/textfiles-phreak.png`
- **21. Telehack (telnet-style BBS in the browser)** — https://telehack.com — `~/Scratch/neuromancer-refs/retro/telehack.png`
- **22. SDF Public Access UNIX** — https://www.sdf.org — `~/Scratch/neuromancer-refs/retro/sdf.png`
- **23. MUD1: Richard Bartle's site** — https://www.mud.co.uk/richard/ — `~/Scratch/neuromancer-refs/retro/mud-bartle.png`
- **24. 16colo.rs ANSI archive plus three files from the ACiD June 1996 pack** — https://16colo.rs — `~/Scratch/neuromancer-refs/retro/16colors-home.png`
- **25. Hotline Communications, 1997** — https://web.archive.org/web/19971018155731/http://www.hotlinesw.com:80/ — `~/Scratch/neuromancer-refs/retro/hotline-1997.png`
- **26. mIRC, 1996** — https://web.archive.org/web/19961221141630/http://www.mirc.co.uk:80/ — `~/Scratch/neuromancer-refs/retro/mirc-1996.png`
- **27. Windows 93** — https://www.windows93.net — `~/Scratch/neuromancer-refs/retro/windows93.png`
- **28. v86 (copy.sh)** — https://copy.sh/v86/ — `~/Scratch/neuromancer-refs/retro/v86.png`
- **29. PCjs** — https://www.pcjs.org — `~/Scratch/neuromancer-refs/retro/pcjs.png`
- **30. OldWeb.today** — https://oldweb.today — `~/Scratch/neuromancer-refs/retro/oldweb-today.png`
- **31. The Old Net** — https://theoldnet.com — `~/Scratch/neuromancer-refs/retro/theoldnet.png`
- **32. AltaVista, 1996** — https://web.archive.org/web/19961220070106/http://altavista.digital.com:80/ — `~/Scratch/neuromancer-refs/retro/altavista-1996.png`
- **33. Netscape, 1996** — https://web.archive.org/web/19961219074448/http://www7.netscape.com:80/ — `~/Scratch/neuromancer-refs/retro/netscape-1996.png`
- **34. William Gibson's site, 2003** — https://web.archive.org/web/20030322034731/http://www.williamgibsonbooks.com:80/ — `~/Scratch/neuromancer-refs/retro/gibson-2003.png`
- **35. The Agrippa Files, plus the poem running in emulation** — https://agrippa.english.ucsb.edu — `~/Scratch/neuromancer-refs/retro/agrippa-files.png`
- **36. JODI: %Location (wwwwwwwww.jodi.org), 100cc, and %20Wrong** — https://wwwwwwwww.jodi.org — `~/Scratch/neuromancer-refs/retro/jodi-wwwwwwwww.png`
- **37. Olia Lialina: My Boyfriend Came Back From the War (1996)** — http://www.teleportacia.org/war/ — `~/Scratch/neuromancer-refs/retro/lialina-war.png`
- **38. Mouchette** — https://www.mouchette.org — `~/Scratch/neuromancer-refs/retro/mouchette.png`
- **39. superbad.com** — https://superbad.com — `~/Scratch/neuromancer-refs/retro/superbad.png`
- **40. Space Jam, 1996** — https://www.spacejam.com/1996/ — `~/Scratch/neuromancer-refs/retro/spacejam-1996.png`
- **41. Cameron's World** — https://www.cameronsworld.net — `~/Scratch/neuromancer-refs/retro/camerons-world.png`
- **42. GeoCities Gallery (restorativland)** — https://geocities.restorativland.org — `~/Scratch/neuromancer-refs/retro/restorativland.png`
- **43. GeoCities fan page: Cyberpunk Central (Area51/Corridor/6115)** — https://geocities.restorativland.org/Area51/Corridor/6115/ — `~/Scratch/neuromancer-refs/retro/geocities-cyberpunk-central.png`
- **44. Internet Archive Software Library (general) and DOS** — https://archive.org/details/softwarelibrary_msdos_games — `~/Scratch/neuromancer-refs/retro/system6-window.png`

## 5. NFC tags, Wi-Fi names (SSIDs) and captive portals (29)

Screenshots in `~/Scratch/neuromancer-refs/nfc-ssid/`. Real interception and fake cell towers are illegal; the Julian Oliver works are listed for their look only.

- **1. Dead Drops (Aram Bartholl), 2010** — https://deaddrops.com/
- **2. OFFLINE ART: new2 (curated by Aram Bartholl), 2013** — https://arambartholl.com/offline-art-new2/
- **3. Keepalive (Aram Bartholl), 2015** — https://arambartholl.com/keepalive/
- **4. PirateBox (David Darts), 2011** — https://web.archive.org/web/20161231132302/https://piratebox.cc/
- **5. LibraryBox (Jason Griffey), 2012** — https://web.archive.org/web/20161231213726/http://librarybox.us/
- **6. Occupy.here (Dan Phiffer), Oct 2011** — http://occupy.here (local-only address inside the box; see nfc-ssid/LANE.md for archived links)
- **7. Subnodes (Sarah Grant), 2013+** — https://web.archive.org/web/20161226183424/http://subnodes.org/
- **8. haiku wifi (Jonathan Dahan, Toby Schachman), 2012** — https://github.com/jedahan/haiku-wifi
- **9. Poetic SSIDs (::vtol:: / Dmitry Morozov), 2016** — https://hackaday.com/2016/06/06/poetic-ssids/
- **10. SSID_Exquis (Walter Langelaar), 2014** — https://ada.net.nz/artbase/walter-langelaar/
- **11. Captive Portal series, CCA Tel Aviv-Yafo (e.g. Sarah A. Friend, "Customs and Border Protection Agency"), 2017** — https://www.cca.org.il/post/captive-portal-customs-and-border-protection-agency
- **12. Now You're In My Pocket (Sahal Ali, NYU ITP thesis), 2025** — https://itp.nyu.edu/thesis/archive/2025/?p=179
- **13. Newstweek (Julian Oliver, Danja Vasiliev), 2011** — https://julianoliver.com/output/newstweek/
- **14. PRISM: The Beacon Frame (Julian Oliver, Danja Vasiliev), 2013/2014** — https://criticalengineering.org/projects/prism-the-beacon-frame/
- **15. Stealth Cell Tower (Julian Oliver), 2015 (press Nov 2016)** — https://julianoliver.com/output/stealth-cell-tower/
- **16. No Network (Julian Oliver), 2013** — https://julianoliver.com/output/no-network/
- **17. Transparency Grenade (Julian Oliver), 2012** — https://julianoliver.com/output/the-transparency-grenade (returns 500; see Cool Hunting write-up in nfc-ssid/LANE.md)
- **18. Wifi Whisperer (Kyle McDonald, Surya Mattu), Moogfest 2016** — https://coolhunting.com/design/kyle-mcdonald-wifi-whisperer-installation-moogfest-2016
- **19. The Lost Palace (Historic Royal Palaces, Uninvited Guests, Chomko & Rosier, Calvium, Univ. of Bristol), 2016-17** — https://calvium.com/project/the-lost-palace/
- **20. Museum of London NFC tags (Nokia), 2011** — https://www.theregister.co.uk/2011/08/17/nokia_nfc_london/
- **21. Munzee, 2011** — https://www.munzee.com/
- **22. Cicada 3301, 2012-14** — https://en.wikipedia.org/wiki/Cicada_3301
- **23. I Love Bees (Halo 2 ARG, 42 Entertainment), 2004 (bridge item: payphones)** — https://en.wikipedia.org/wiki/I_Love_Bees
- **24. Equitable Internet Initiative (Detroit Community Technology Project), 2017+** — https://detroitcommunitytech.org/eii
- **25. Pwnagotchi (evilsocket), 2019** — https://pwnagotchi.ai/
- **26. Flipper Zero, 2020** — https://flipperzero.one/
- **27. Web NFC (Chrome NDEFReader)** — https://developer.chrome.com/docs/capabilities/nfc
- **28. nodogsplash / openNDS (captive portal)** — https://github.com/nodogsplash/nodogsplash
- **29. ESP8266 beacon spam (Spacehuhn)** — https://github.com/spacehuhn/esp8266_beaconSpam

## 6. Muse lane: YouTube and Instagram (38, audited)

### Audit corrections (Muse errors)
- Vitaskhr reel DICEOjpxTVy: caption says Macintosh 512K "Fat Mac" (1984), not a Mac Plus as Muse wrote.
- monica.sharf1 DTlJxghiaSt: a repost; caption credits photographer Randall Nyhof (@randallnyhof). Use his account as the source.
- 4x0nn DNRzumStaXS: caption is only "#textmode is my happy place" (OpenBSD, tmux, IBM 3151). Muse's "hourly attack counts" detail is not confirmed from the caption; check the image.
- HOPE 9 Lapsley talk tf9dQomDkhY: uploaded 2026-08-25 by "2600 | Oak Lawn" (94 views), a reupload, not the official HOPE channel.
- Quinn's Ideas v_tqDIoKdGQ: uploaded 2025-09-27 (Muse said Oct 10).
- Rocket Sloth TNkQGdvu0gQ: uploaded 2020-10-24. Deep Cuts bJQJqlZXQtk is by RetelFactor, 2019-03-04.
- The Agrippa "Transmission" bootleg drPpUlTypt4 was uploaded by Matthew Kirschenbaum (Agrippa Files editor), 2012-05-07.

### Verified YouTube (uploader, upload date, length)
See yt_audit.tsv for all 26. Most useful for the game:
- 8PmkUPBhL4U  Connections Museum, "2600? How Phreaking Really Worked" (2023-03-26, 17:32). Blue box parts at 1:40, demo at 9:05, Cap'n Crunch whistle 12:57.
- N8hgxmHnPZc  Evan Doorbell, Kennedy Airport Phone Trip Dec 1970 (36:30). Real recorded payphone network sounds, a trip through one airport's payphones.
- zn9GNdaXQDA  DEF CON 20, Brashars, "Raiders of the Lost Payphones" (49:22). Real payphone hardware and reprogramming.
- TNkQGdvu0gQ  Rocket Sloth, I Love Bees (56:41). Payphones chapter 27:41-33:43.
- xCbceFb2Yjk  I Love Bees radio drama full audio (5:37:45).
- xalTFH5ht-k  Retrocet, modem sounds 300 bps to 56K (2:02).
- drPpUlTypt4  Agrippa "Transmission" 1992 bootleg (1:00:07). Poem scrolls ~25:00-52:00.
- 1tQ5XwvjPmA  CHM, Jobs introduces Macintosh 1984. MacPaint at 29:40.
- FquNpWdf9vg / 3OPqVHP00tc  Computer Chronicles HyperCard (1987) / System 7 (1991).
- XKyXCZV_faY / Blv_BIUc0rA / K_q_k_QDraQ  No.5 Crossbar tour, panel office walk, AT&T "Hello Machine" switch film.

### Verified Instagram (author, post date from page)
- reel/Dfuqx4XRww0  @arghivist 2026-11-14, I Love Bees payphones retold
- reel/DHbcKyOuJ7N  @att 2025-03-20, switchboard patch cords ASMR
- p/DfyxXtOFTzK     @old.california.usa 2026-11-15, 1946 LA switchboard photo
- p/DSWG5Obj67s     @sfomuseum 2025-12-16, 1906 SF operators
- p/DGtMvHbgyzl     @cineart47 2025-03-02, payphone in glass booth
- p/DTlJxghiaSt     @monica.sharf1 2026-01-16 (photo by @randallnyhof), B&W coin payphone
- p/DXkpnsXGfq9     @rolandopujol 2026-04-25, America's last phone booths set
- reel/DICEOjpxTVy  @vitaskhr 2025-04-04, Macintosh 512K boot with real sounds
- reel/DS5KqsyEdBk  @japhyriddle 2025-12-30, MacPaint art printed on ImageWriter II
- reel/DHXe4u6gGC8  @adafruit 2025-03-18, MacPaint on a System 6 emulator board
- p/DNRzumStaXS     @4x0nn 2025-08-12, IBM 3151 textmode CRT
- reel/DFpDeJdNNCd  @tim_rodenbroeker 2025-02-03, "Dithering Fantasies" 1-bit motion

All 26 YouTube IDs with uploader and date: `~/Scratch/neuromancer-refs/muse/yt_audit.tsv`.

---
Link check, 2026-11-20: all 296 unique URLs in this file were curled. 293 return 200 (two of those only after a retry with a longer timeout). The three that don't: julianoliver.com Transparency Grenade (500, so a write-up is used), `http://occupy.here` (local-only by design) and one Wikipedia URL that the checker cut off at the bracket (it returns 200 when checked whole). Spend: no paid services; the Muse lane used part of the weekly Muse allowance.

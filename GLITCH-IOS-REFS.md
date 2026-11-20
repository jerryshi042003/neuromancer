# Cracked, buggy, haunted iPhone: references for LINE (2026-11-20)

Private study index. Screenshots, video frames and clones stay in `~/Scratch/glitch-ios-refs/` and must not ship in the app or go on a website (Apple images, YouTube frames and other people's screenshots are reference only). This file holds links, techniques and paths.

**Version note:** Apple's live documentation is already on iOS 27 (it names iOS 27 / macOS 27.3 APIs and has WWDC26 sessions; the App Review Guidelines say "Last Updated: October 16, 2026"). Jerry's iPhone 17 Pro is probably on iOS 27. The limits below are Apple's current text. Private-API tricks (marked) were not re-tested on 26 or 27.

"Stock" = an unjailbroken iPhone running our own dev-signed app. No jailbreak, nothing installed on Jerry's phone, no settings changed.

## How it was checked

| Lane | Items | Method | Full notes |
|---|---|---|---|
| GitHub (Claude) | 25 repos/samples | `gh api` stars/push/license; 8 cloned and read; key files quoted by line | `~/Scratch/glitch-ios-refs/github/LANE.md` |
| Apple limits | 8 surfaces | Apple docs read via the docs JSON; each line marked V (read on page, quoted) or U | `~/Scratch/glitch-ios-refs/apple/LANE.md` |
| Strange real Apple errors | 10 categories, 35 images, 16 frames | Apple Support/dev pages fetched (HTTP 200), images opened and looked at, yt-dlp + ffmpeg frames | `~/Scratch/glitch-ios-refs/apple-errors/LANE.md` |
| Muse (YouTube + Instagram) | 39 links → 35 verified, 3 failed, 1 AI-generated dropped | yt-dlp metadata, frames looked at, Instagram opened in Chrome | `~/Scratch/glitch-ios-refs/muse/LANE.md` |
| Grok (X) | 25 posts → 24 real, ~13 on-brief, 1 hallucinated; +6 found by own X search | every post opened on x.com | `~/Scratch/glitch-ios-refs/grok/LANE.md` |
| Old jailbreak screens (look only) | 71 images, 27 rejects kept apart | YouTube frames (yt-dlp), Wikimedia, KindleModding/MobileRead wikis; every image looked at | `~/Scratch/glitch-ios-refs/jailbreak-ui/LANE.md` |
| Reddit | **0** | Blocked: Chrome and the in-app browser refuse reddit.com ("not allowed due to safety restrictions"); curl 403; headless gets Reddit's block page. Not routed around. Jerry's search link (`reddit.com/search/?q=jailbreak+glitched+features…`) was not opened for the same reason. | `~/Scratch/glitch-ios-refs/reddit/LANE.md` |

---

## 1. Apple's boundaries, surface by surface (what the system allows)

All verified on Apple pages unless marked U. Full citations in `apple/LANE.md`.

**Widgets (WidgetKit)** — https://developer.apple.com/documentation/widgetkit/keeping-a-widget-up-to-date
- Reload budget "40 to 70 refreshes" a day for a frequently viewed widget (about every 15–60 min); entries ≥ ~5 min apart; StandBy redraws don't count.
- Any built-in SwiftUI transition, each ≤ 2 s; nothing animates on Always-On. `Text(date, style: .timer)`, timer `ProgressView` and `pauseTime` run live with no reload — this is the hole every widget-animation trick uses.
- Rendering modes: full color, accented, vibrant; tinted/clear flatten images to white; StandBy night mode turns everything red.
- U: whether SwiftUI shaders (`layerEffect`) render inside a widget — no Apple sentence; test on device. U: image pixel cap (forums say ~718K–836K px).
- Edge: a `Text(.timer)` past its date counts *up* (an overshooting countdown for free); `pauseTime` looks like a hang; `.redacted(reason: .placeholder)` turns text into gray bars.

**Live Activities / Dynamic Island (ActivityKit)**
- Active up to 8 h, then up to 4 more h on the Lock Screen. Data ≤ 4 KB. Height 84–160 pt; taller is truncated (a real cut-off look). Island background always black; key line color is yours.
- Priority-10 pushes are budgeted and throttled; priority-5 aren't. `NSSupportsLiveActivitiesFrequentUpdates` raises it (user can turn off). Push-to-start since iOS 17.2. An alerting update lights the screen, plays a sound and expands the island.
- Edge: a `staleDate` flips `isStale` (render it as a corrupted frame); an alerting update with no change makes the island jump like a glitch (keep rare: Guideline 4.5.3 spam).

**Alternate app icons** — "The system automatically displays an alert notifying people of the change." Icons must ship in the bundle (no drawing a new icon at runtime). U: foreground-only rule and exact alert wording (Bryce Bostwick's post and @sleep9ull's screenshot both show the alert; Bostwick reports background calls do nothing).

**Notifications** — sounds aiff/wav/caf < 30 s (longer plays default). Time-sensitive and communication notifications (sender name + avatar) break through Focus/summaries. Critical alerts need Apple's entitlement.

**Core Haptics** — a continuous event lasts ≤ 30 s; engine stops in background and auto-shuts after ~2 min idle; muted while recording audio by default; looping advanced player exists; AHAP can carry audio events. U: event-count limits, 17 Pro Taptic specifics.

**SwiftUI shaders and text** — `.colorEffect` / `.distortionEffect` / `.layerEffect` (iOS 17); `maxSampleOffset` must cover your farthest sample; UIKit-backed views inside a `layerEffect` render as Apple's own error placeholder (a real "bug" look). Per-glyph `TextRenderer` iOS 18+. `glassEffect` iOS 26+.

**Other** — Action button runs any App Shortcut the user assigns; torch level 0–1 drops by itself when hot; Locked Camera Capture extensions have no network.

**App Review lines that matter** (https://developer.apple.com/app-store/review/guidelines/, Oct 16 2026): 1.1 ("just plain creepy" can be rejected), **1.1.6** (no inaccurate device data or trick/joke functionality — the key red line: never fake real signal/battery/SIM state), 2.1(a) crashes, 2.5.8 fake home screens, 2.5.9 altering native UI, 2.3.8 alternate icons must be similar, 4.5.3 push/Live Activity spam. Under personal dev signing review doesn't apply, but keep them as taste lines.

---

## 2. Making the system's own surfaces do what they "can't"

1. **Animated widget, public API — Bryce Bostwick, WidgetAnimation.** https://github.com/brycebostwick/WidgetAnimation (519★, pushed 2025-05-11, MIT). Video "Apple's Widget Backdoor", 2025-05-11, 1.4M views: https://www.youtube.com/watch?v=NdJ_y1c_j_I. Hackaday write-up 2025-05-17: https://hackaday.com/2025/05/17/animated-widgets-on-apple-devices-via-a-neat-backdoor/
   - Shows: a 30-second loop running inside a home-screen widget (8 fps demo; README says up to 30).
   - Technique (`Widget/Widget.swift`): 16 custom fonts, each holding every 16th frame as glyphs, each drawn by `Text(date, style: .timer)` so the system's live timer advances the glyph; a 17th blinking font reveals the stacked timers in turn. The video also shows huge masked image slices spun by underscored `_clockHandRotationEffect(period:)`.
   - Stock: **yes** (font + timer is public API; `_clockHandRotationEffect` is undocumented).
   - Files: `github/shots/bryce-video-contact.png`, `github/shots/bryce-widget-video_{20,120,600,1200,1900}s.png`, `github/shots/hackaday-widget-backdoor.png`; Instagram echo by @nightly_built00 (Apple Watch, same trick): https://www.instagram.com/p/DfAZcqOCqRy/ — `muse/ig/ig_nightlybuilt00_DfAZcqOCqRy.jpg`
2. **Sliding/swinging widgets — TopWidgets/SwingAnimation** (912★, 2023-11-21, MIT) on **octree/ClockHandRotationKit** (149★, 2026-03-13, MIT). https://github.com/TopWidgets/SwingAnimation — continuous motion composed from `clockHandRotationEffect`. Stock: yes (undocumented API). `github/shots/swinganimation-repo.png`
3. **Animated app icon — Bryce Bostwick, AnimatedAppIcons.** https://github.com/brycebostwick/AnimatedAppIcons (446★, 2024-05-27); post https://bryce.co/animated-app-icons/ (2024-05-27); video https://www.youtube.com/watch?v=KDVibKGtSVI
   - Technique (`IconAnimator.swift` l.180–183): private `LSBundleProxy.bundleProxyForCurrentProcess()` → `setAlternateIconName`, which skips the alert and works from the background.
   - Stock: **partial** (private API, dev-signed only, not re-tested on 26/27). Files: `github/shots/bryce-animated-icons-post.png`, `muse/bostwick_icons_2.png`, `muse/bostwick_icons_75.png`
4. **Words in the icon badge — Bryce Bostwick, Emoji-Badge-Demo.** https://github.com/brycebostwick/Emoji-Badge-Demo ; https://bryce.co/non-numeric-app-badges/ — the red badge shows text instead of a number, cycling "the five stages of grief" after the app closes. Private `-[UIApplication setApplicationBadgeString:]`. Stock: **partial** (private, 2020, unverified on 26/27). Public route is numbers only (`setBadgeCount`). `github/shots/bryce-emoji-badges-post.png`
5. **Video in the Dynamic Island via Live Activities — Shadowfacts, "Live Activities (and Bad Apple)".** https://shadowfacts.net/2022/live-activities/ (2022-10-01) — 60×45, 1-bit frames (~360 bytes) under the 4 KB limit; iOS force-animates each update so it smears; background updates blocked, so they must come by push. Stock: **partial**.
6. **Video in the island via Now Playing artwork — @zhuowei.** https://x.com/zhuowei/status/1573711389285388288 (2022-09-24) — Bad Apple at 2 fps as track artwork. Stock: partial (audio app, very low fps). `grok/02_zhuowei_badapple_dynamic_island.jpg`
7. **Liquid leaking out of the island — @ervorocks (Stressy).** https://x.com/ervorocks/status/2121235617673621992 (2026-11-13) — drops pinch off the island on launch, a haptic per drop. In-app Metal shader drawn under the cutout, not a Live Activity. Stock: yes (ships on the App Store). `grok/05_ervorocks_dynamic_island_drip.jpg`
8. **The cutout as a physical object — Hit the Island** (https://www.youtube.com/watch?v=Kcy-80fXO0w, 2022-10-19; `muse/hit_the_island_13.png`) and **Apollo Pixel Pals** walking along the island (https://www.youtube.com/watch?v=BmrBqluMCy4; `muse/apollo_pixel_pets_1.png`), plus the Live Activity pet version (https://www.youtube.com/watch?v=EyAHvoH6d_o; `muse/di_digital_pet_27.png`). Stock: yes.
9. **The icon alert as a constraint — @sleep9ull.** https://x.com/sleep9ull/status/2101614918730649778 (2026-09-20) — the "You have changed the icon for…" alert appears every time. `grok/08_sleep9ull_alt_icon_alert.jpg`
10. **A real "zombie" Live Activity — Apple Developer Forums thread 819556** (Mar 2026, still reported on 27.2): an empty island with a detached bubble that survives deleting the app. Files: `apple-errors/frames/zombieLA_island_crop_40s.png`, `apple-errors/img/shot_devforum_alarmkit_zombie_LA.png`. Stock: the look, yes, as our own nearly empty, auto-ending Live Activity.

## 3. Glitch inside the app (shaders, broken text, low frame rate)

11. **krispuckett/SwiftUIShaders** (351★, 2026-09-30, MIT) — https://github.com/krispuckett/SwiftUIShaders. 41 `[[stitchable]]` shaders; the useful ones: `bcs_glitch` (l.432: time-quantised hash trigger ~10×/s, horizontal block displacement, per-block vertical jitter, scanlines, RGB offset), `bcs_datamosh` (l.1898), `bcs_chromaticSplit`, `bcs_shatter`, `bcs_disintegrate`, `bcs_melt`, `bcs_echo`, `bcs_pixelateStorm`. Stock: yes. Local copy `github/krispuckett_SwiftUIShaders.metal`.
12. **Czajnikowski/ScanEffect** (10★, 2024-03-25, MIT) — https://github.com/Czajnikowski/ScanEffect. Scanner/slit-scan glitch: each scan line samples content at a CPU-computed displacement, so moving content smears like a bad scan. Stock: yes. `github/shots/scaneffect-repo.png`
13. **twostraws/Inferno** (2,942★, 2026-05-17) — https://github.com/twostraws/Inferno; launch video https://www.youtube.com/watch?v=jriUylwcnmU. Building blocks: `WhiteNoise`, `RainbowNoise`, `Interlace`, `ColorPlanes` (RGB split), `Infrared`, transitions `Pixellate`, `Wind`, `Genie`. Stock: yes. `muse/inferno_hudson_165.png`
14. **Chromatic aberration with live channel offsets — @nilshoenson** https://x.com/nilshoenson/status/1673737836124618752 (2023-06-27). `grok/04_nilshoenson_chromatic_aberration.jpg`
15. **Spiderversify — Jager-yoo/Spiderversify** (22★, 2026-10-22, MIT) https://github.com/Jager-yoo/Spiderversify; post https://x.com/swiftnineone/status/2113591520817480105. RGB-split + jitter modifier for any view. Stock: yes. `grok/01_swiftnineone_spiderversify.jpg`
16. **Shader galleries:** eleev/swiftui-new-metal-shaders (779★, MIT; `Noise`, `Pixellate`, `StickySlide`); matthewwaller/shadergallery (Glitch, CRT Monitor, Pixelate previews) https://github.com/matthewwaller/shadergallery; jazzychad/MeshWarpEffect (mesh warp any view, MIT); jamesrochabrun/ShaderKit (tilt-driven foil); Apple sample https://developer.apple.com/documentation/swiftui/creating-visual-effects-with-swiftui; WWDC24 https://developer.apple.com/videos/play/wwdc2024/10151/; WWDC26 "Compose advanced graphics effects with SwiftUI" https://developer.apple.com/videos/play/wwdc2026/322/
17. **Only some words tremble — twostraws/Prismic `EarthquakeView`** (341★, 2026-04-03, MIT) https://github.com/twostraws/Prismic — iOS 18 `TextRenderer` that offsets each glyph randomly (plus optional blur) only for runs tagged with a custom `TextAttribute`. Stock: yes.
18. **Text tearing and decoding — Kavsoft.** Glitch Text Effect (red/green offset copies via `keyframeAnimator`, no Metal) https://www.youtube.com/watch?v=8CedpKnYQBY — `muse/kavsoft_glitch_text_562.0.png`; Hacker Text Effect (scrambles through random characters, then resolves) https://www.youtube.com/watch?v=T5aUgq8GKnA. Stock: yes.
19. **UI drawn at 12 fps — @danbillson "Glitch UI"** https://x.com/danbillson/status/2123055576854962426 (2026-11-18) — deliberately stepped frame rate (Spider-Verse on twos). Web prototype; on iOS use `TimelineView` with a coarse cadence or stepped keyframes. `grok/06_danbillson_glitch_ui.jpg`
20. **Heat haze / something under the glass — Ray Kiln** https://www.raykiln.dev/heat-haze/ — noise-distortion warp with `TimelineView(.animation)`.

## 4. Haunted phones that already exist (games and fiction)

21. **Simulacra launch trailer** (Kaigan Games, 2017) https://www.youtube.com/watch?v=rrLLWqHL-Yc — 0:50 home screen breaks into RGB-split datamoshed icons; 0:53 a "Restore Tool" offering broken word fragments ("ShEE wiLL bE GonNNe SoOOn"); 1:05 "IMAGE CORRUPTED". Files `muse/simulacra_launch_{50,53,65}.png`. Simulacra 2 (https://www.youtube.com/watch?v=x3ga7pYyWAY; `muse/simulacra2_final_{24,40,71}.png`), Simulacra 3 (https://www.youtube.com/watch?v=NqHqMAcG--w).
22. **Replica** (Somi, 2016) https://www.youtube.com/watch?v=bPUedMR4m7E — 1-bit phone OS: "11 Missed calls", an unknown incoming call, a pixel chat with "typing…". The "cool, not cheesy" reference. `muse/replica_trailer_{3,22,65}.png`
23. **Sara Is Missing** (2016) https://www.youtube.com/watch?v=Ta1AEOTIQwE — 3:30 the phone's assistant IRIS: "Would you like me to restore them now?" Closest existing "AI inside the phone". `muse/sara_missing_210.png`
24. **Lifeline** (2015) https://www.youtube.com/watch?v=P81rf74MF7w — real notifications in real time from a stranded voice; the closest mechanical precedent. Also Duskwood, Mr. Robot:1.51exfiltrati0n (https://www.youtube.com/watch?v=5PLyJ1c2LQg, a messenger that glitches into a takeover), Bury Me My Love, Telling Lies.
25. **Creaking Hinge** (@LuxWebVentures, 2026-11-14) https://x.com/LuxWebVentures/status/2121720161061183800 — horror where the iPhone Duo hinge angle opens a haunted door. `grok/09_luxweb_creaking_hinge.jpg`
26. **Real hardware ghosts on Instagram:** @icorrect_ "two Dynamic Islands" display fault on a passcode screen https://www.instagram.com/reel/DGyz9ldK37G/ (`muse/ig/ig_icorrect_DGyz9ldK37G.jpg`); @modul404 hash-block glitch shader with code visible https://www.instagram.com/reel/DeZe1E3i1Th/.

## 5. Real Apple errors that feel uncanny, and how to echo them legally

Rule for all of these: our own screens in LINE's own style that *echo* the system, never a copy of a system dialog that asks the user to do something, and never fake the phone's real status (App Review 1.1.6). Details and red lines in `apple-errors/LANE.md`.

27. **"SOS only" / "Searching…" / "No Service"** — Apple Support 120000: SOS "means your device can still make emergency calls"; "No Service" means it "isn't connected to a cellular network". Files `apple-errors/img/tidbits_SOS_status_bar.jpg`, `apple-errors/img/ios-26-iphone-16-pro-control-center-sos-only-crop.png`, iOS 27 "Cellular Issue" card `apple-errors/img/ios-27-iphone-17-pro-settings-cellular-issue.png`. **Echo:** a connection strip inside LINE's own chrome showing *the voice's* line state. Never in the real status-bar position; never imply the user can't call emergency services.
28. **Recovery mode / DFU / "Restore Nearby iPhone"** — Apple 118106, 121133; the lone "support.apple.com/iphone/restore" on black; "An iPhone near you is in recovery mode." Files `apple-errors/frames/9to5_recovery_screen_270s.png`, `apple-errors/frames/9to5_DFU_black_664s.png`, `apple-errors/img/ios-18-iphone-15-pro-restore-nearby-phone-pop-up-alert.png`. **Echo:** narrative cards with LINE's glyphs ("a line near you is open").
29. **Multilingual kernel panic (old Mac)** — Wikimedia, public domain/APSL: the restart plea stacked in 4–6 languages over a ghost power symbol. `apple-errors/img/MacOSX_kernel_panic.png`; iPhone `panic-full-….ips` logs via iFixit `apple-errors/img/shot_ifixit_iphone_kernel_panics.png`. **Echo:** the voice addressing the user in every language at once. Safest to echo (no current iOS look-alike).
30. **"Hello" in 49 languages, caught mid-draw** — `apple-errors/frames/hello_partial_helo_115s.png` ("helo"). **Echo:** our own handwriting animation that stalls mid-word.
31. **Redacted placeholder widgets** — https://developer.apple.com/documentation/swiftui/redactionreasons/placeholder ; `apple-errors/img/kodeco_04-placeholder-load.png`. **Echo:** fully native: the widget shows gray bars that only partly resolve into the voice's words.
32. **"Unknown" part / "Not Trusted" / "Not Verified"** — Apple 102658, 118254; `apple-errors/img/ios-18-iphone-15-pro-settings-general-about-part-service-history-unknown.png`, `apple-errors/img/ios-17-iphone-15-pro-enterprise-app-untrusted-enterprise-developer-warning.png`. **Echo:** LINE's own "inventory" screen listing a component the phone can't vouch for. No Trust button, nothing to tap.
33. **Display ghosts** — green line (`apple-errors/frames/infohut_green_line_62s.png`), iPhone 14 Pro horizontal lines (MacRumors Dec 2022, `apple-errors/img/macrumors_iphone14pro_lines.jpg`), OLED burn-in in Apple's own wording. **Echo:** a shader that leaves a faint after-image of the voice's last words (burn-in), only inside LINE.
34. **Carrier-settings update with only "OK"**, the stalled Apple-logo progress bar (`apple-errors/img/ios-18-iphone-15-pro-progress-bar.png`), slide-to-power-off drawn as a gray bar. **Hard no:** "iPhone Unavailable" (a lock screen; describe only, never imitate).

## 6. Old jailbreak screens (look only)

71 images (YouTube frames, Wikimedia, KindleModding/MobileRead wikis, checkra.in), each opened and checked; 27 wrong-moment frames kept apart in `jailbreak-ui/rejects/`. Nothing was downloaded or run except screen footage. Full notes per tool (checkra1n, pongoOS/palera1n, unc0ver, Electra/Chimera, evasi0n, redsn0w/limera1n/greenpois0n, old verbose boot, Cydia, respring, Pangu, Kindle) in `~/Scratch/glitch-ios-refs/jailbreak-ui/LANE.md`. Most frames are 2010–2015 phone footage at 480p, good for layout and mood rather than exact type.

35. **evasi0n7 boot splash (2013)** — a black "E" mark where the Apple logo should be, over "Continuing with boot…" / "Reading kernel…". iDB, 2013-12-22, https://www.youtube.com/watch?v=jgtHl1So5Vk at 5:30. `jailbreak-ui/evasi0n7-splash-iphone_330s.png`, `jailbreak-ui/evasi0n7-splash-iphone_322s.png`. **Echo:** LINE's own launch mark is replaced for one launch by the voice's mark, with a one-line status under it.
36. **checkra1n verbose boot (2019–2020)** — white monospace kernel lines on black with the pixel rook/apple mascot drawn on top; overwritten lines leave vertical streaks like rain. Flick, 2019-11-16, https://www.youtube.com/watch?v=nNejh6P70kc at 0:06; Rafael Castello, 2020-04-20, https://www.youtube.com/watch?v=jR0TUR1pfos at 3:07 (and its curses TUI at 0:01). `jailbreak-ui/checkra1n-verbose-iphone8_6.5s.png`, `jailbreak-ui/checkra1n-verbose-n61_187s.png`, `jailbreak-ui/checkra1n-cli-tui_1s.png`, site mascot `jailbreak-ui/web_checkra1n-site.png`.
37. **unc0ver "Exploiting (2/38)" (2019)** — a blue progress button counting stages over a live black log of kernel lines. iTwe4kz, 2019-02-23, https://www.youtube.com/watch?v=02kdQoUXeVk at 5:32. `jailbreak-ui/unc0ver-exploiting_332s.png`. **Echo:** a stage counter for the voice's connection ("2/38") with its own log underneath.
38. **Cydia install console → "Restart SpringBoard" (2018)** — black console titled "Complete", bold status lines, lighter dpkg warnings, one wide button. iApplePro, 2018-09-20, https://www.youtube.com/watch?v=8zYcD3CSnJA at 0:43–0:45; the black respring spinner at 0:50. `jailbreak-ui/cydia-running-console_43s.png`, `jailbreak-ui/cydia-complete-restart-springboard_45s.png`, `jailbreak-ui/respring-black-spinner_50s.png`. Correction to the brief: Cydia's bars were stock iOS blue-gray (iOS 5–6) or white (iOS 7+); only the icon was brown.
39. **Kindle "Nosebleed" jailbreak log printed over the live home screen** — "**** nosb JAILBREAK **** / bugs are like milk." and the install log typed straight over the Kindle home screen and an "Application Error" dialog, nothing cleared. KindleModding wiki image https://raw.githubusercontent.com/KindleModding/kindlemodding.github.io/main/content/jailbreaking/Nosebleed/jailbreak.png — `jailbreak-ui/kindle-wiki_Nosebleed_jailbreak.png`. The single best "something is writing over the UI from underneath" image.
40. **Kindle "SpringBreak" on e-ink** — a photo of a Paperwhite: big pixel "Restarting GUI Please Wait…" over a small log, with faint ghosts of earlier text (e-ink ghosting). https://raw.githubusercontent.com/KindleModding/kindlemodding.github.io/main/content/jailbreaking/SpringBreak/jailbreak2.png — `jailbreak-ui/kindle-wiki_SpringBreak_jailbreak2.png`
41. **limera1n green drop (2010)** — one green drop on a black iPhone 4 screen. gumballtech, 2010-10-09, https://www.youtube.com/watch?v=Yc3xxEMUsEA at 2:49. `jailbreak-ui/limera1n-drop-iphone_169s.png`. **pongoOS** log printed over the dimmed old wallpaper (2023-01-01, https://www.youtube.com/watch?v=-ohi9-4E6bE at 0:03; `jailbreak-ui/pongoos-iphone_3.3s.png`).

Gaps: no clean pongoOS shell prompt on a phone, no sharp redsn0w pineapple logo, no linkss screensaver capture, Sileo/Zebra skipped, theiphonewiki.com timed out.

---

## Top 12 techniques for LINE

★ = fits "a voice inside the software trying to reach you" (the voice uses a real phone surface or speaks through a system-looking state). ○ = texture/look that supports it.

1. ★ **The icon changes, and the phone itself says so.** Public `setAlternateIconName` from a moment in the app; iOS's own "You have changed the icon for LINE" alert is the system speaking for the voice. Each icon is a decayed version of the last (bundle only; 2.3.8 "similar" is fine for this). Stock: yes. Refs: items 3, 9; Apple lane §3.
2. ★ **A widget that moves when widgets can't.** Bostwick's font + `Text(.timer)` trick to loop a waveform, static or a slowly forming word in a home-screen widget, at a deliberately low frame rate. Stock: yes (public API). Ref: item 1.
3. ★ **The voice speaks in redacted bars.** A widget in `.redacted(reason: .placeholder)` whose gray bars resolve one word per timeline entry (~5 min apart), with an overshooting `Text(.timer)` beside it. Stock: yes. Refs: item 31; Apple lane §1.
4. ★ **"Line open" Live Activity.** A Live Activity the user starts; nearly empty island with a red key line; 1-bit frames under 4 KB pushed at priority 5 (smearing on purpose); `isStale` renders a corrupted frame; a rare alerting update makes the island jump. Ends on its own. Stock: yes. Refs: items 5, 10; Apple lane §2.
5. ★ **Something leaks out of the island.** In-app shader drawn under the cutout (static or text dripping out), with a haptic per drop. Stock: yes. Refs: items 7, 8.
6. ★ **Only the voice's words tremble.** iOS 18 `TextRenderer` with a custom `TextAttribute`, so normal UI text stays still and only the voice's runs shake, blur or decode (Kavsoft scramble). Stock: yes. Refs: items 17, 18.
7. ○ **A glitch layer over the whole app, triggered, not constant, drawn on twos.** `layerEffect` block displacement + RGB split + scanlines on a time-quantised hash (like `bcs_glitch`), firing when the voice "pushes through"; `ScanEffect` smear on scroll; motion stepped at ~12 fps (`TimelineView` coarse cadence) so the app feels like it runs on something other than the phone. Stock: yes. Refs: items 11–13, 19.
8. ★ **The connection strip.** LINE's own chrome carries a line-state readout borrowing Apple's words for the network ("Searching…", "SOS only" for the voice's line), never in the real status bar and never about the user's real service (1.1.6). Stock: yes. Ref: item 27.
9. ★ **The voice in every language at once.** A multilingual panic-style card (old Mac panic layout, not an iOS screen) when the voice breaks through hardest. Stock: yes. Ref: item 29.
10. ★ **Real notifications, real time, a real sender.** Communication notifications with the voice's avatar and time-sensitive level, custom sound < 30 s cut from line noise (Lifeline cadence, Replica's missed-calls look). Stock: yes. Refs: items 22, 24; Apple lane §4.
11. ★ **Haptics made from real recordings.** AHAP converted from a real ring cadence or modem handshake (sound2ahap / AHAPpy / haptify), designed in Haptiq; continuous events ≤ 30 s, looped with the advanced player. Stock: yes. Refs: GitHub lane §D; Apple lane §5.
12. ★ **The voice writes over the app without clearing it.** Borrowed from the Kindle Nosebleed log and checkra1n/pongoOS: white monospace lines typed straight over LINE's live screens (and over its own error card), old lines left as ghosts like e-ink; on one launch the voice's mark replaces LINE's launch mark with a single status line (evasi0n). Our own UI only, never over another app or the system. Stock: yes. Refs: items 35–41.

Private-API extras for dev-signed builds only (not App Store; untested on iOS 26/27): silent animated icon (item 3) and words in the badge (item 4, both ★). Try them on device early; if they still work, the badge one is the strongest single "voice from inside" move.

## Credit used
- No paid API credit.
- Muse: one side-chat research run (4 sub-lanes, ~77 queries) from the weekly allowance; remaining balance not readable. Thread: https://muse.ai/thread/7831b292-141d-4d4e-8070-914ff4cf1040
- Grok: 4 prompts on Jerry's account (Fast model; the account appears to be free tier). Thread: https://grok.com/c/24209622-ba05-4058-a1f9-98d7f5a1fdb8

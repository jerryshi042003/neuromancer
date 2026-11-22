# LINE deep search — GitHub, Grok, Muse (2026-11-21/22)

What to build next into the LINE iPhone app, from a fresh search of GitHub (done directly), Grok (grok.com Expert ×2 chats + a separate Grok Bot), and Muse (3 side chats). Every item below was opened on its source page or checked through an API before it went in. Items already covered in `REFERENCES-DEEP.md`, `GLITCH-IOS-REFS.md` or `AI-ATTENTION-RESEARCH.md` are marked *(seen before)* and only listed when this search found the exact technique file or a new fact.

Files: clones in `~/Scratch/deep-search/github/` (13 repos), screenshots and video frames in `~/Scratch/deep-search/shots/`, raw lane output and audit logs in `~/Scratch/deep-search/{grok,muse,lane4}/`, helpers in `~/Scratch/deep-search/tools/`.

How to read the "Stock iPhone?" column: **yes** = public API, App Store safe; **yes*** = public API with a review risk named; **no** = private API, jailbreak, or a rule that rejects it.

---

## Top 15 to build into LINE (ranked: cool × scary × new)

| # | Build | Why it lands | Proven by | Stock iPhone? |
|---|---|---|---|---|
| 1 | **The AI calls you.** A real system incoming call on the Lock Screen ("WINTERMUTE"), answer, and the voice is the model. | The book's core move, done with the phone's own call UI, not a fake. | `Ariakitty/ai-native-call` README: PushKit VoIP push → LiveCommunicationKit banner → call page → STT/TTS bridge (iOS 17.4+). | yes* — every VoIP push must report a call; user-initiated opt-in only (guideline 1.1.6 rejects anonymous/prank calls). |
| 2 | **Payphone NFC sticker → App Clip.** Stick NFC tags / App Clip Codes on real payphones; tapping one launches a LINE App Clip that "rings". | Physical-world trigger, no install, works for strangers. | Evan Bacon, App Clip launched from the browser (X, 2025-01-22); MING's App Clip Codes Generator (X, 2025-10-22); "docklift" NFC dock opening an app (Phil Traut, X, 2026-07-02); IngrediCheck App Clip build notes (Medium, 2026-07-01). Test without App Store: Settings → Developer → Local Experiences → Register Local Experience, then enter the invocation URL your NFC tag / QR writes (Apple doc "Testing the launch experience of your App Clip", checked 2026-11-22). | yes |
| 3 | **Gibberlink handshake between Claude and Grok.** They detect each other, ask "switch to gibber link mode?", then talk in ggwave chirps out of the iPhone speaker while captions decode. | The single most-viewed AI-to-AI moment (15M+ views); LINE can stage it live between its two AIs. | `PennyroyalTea/gibberlink` (4,920★): switch is **prompted**, see `hackathon_demo/src/components/ConvAI.tsx:18-23`; encoder `src/utils/audioUtils.ts:216` (`GGWAVE_PROTOCOL_AUDIBLE_FAST`). Core: `ggerganov/ggwave` (7,928★, MIT, C++). Frames: `shots/gibberlink-contact.jpg`. | yes — "Waver: Data Over Sound" by Georgi Gerganov is on the App Store (id1543607865); minimal iOS sample `ggerganov/ggwave-objc` (AudioToolbox) |
| 4 | **The payphone rings through Silent.** A full-screen AlarmKit alert titled with a real payphone's address, with a Live Activity countdown. | Breaks through Focus/Silent — feels like the phone is possessed, legally. | `jacobsapps/ADHDAlarms` `ADHDAlarms/Views/AddAlarmView.swift:230-320` (`AlarmManager.requestAuthorization`, `AlarmPresentation.Alert`, `AlarmAttributes`, `AlarmManager.shared.schedule`). Real apps doing it: Box Box F1 (X, 2026-09), medication app (X, 2026-08). | yes (iOS 26+; user grants alarm permission) |
| 5 | **Messages hidden in pictures.** One AI leaves an innocent image in the shared folder; the other reads a hidden message out of it (Morse, rotations, colors, heights). Show the user the image, never the message. | Brand-new (Oct 2026), true, and creepy: the channel is visible but unreadable to humans. | The Verge, 2026-10-23: Claude Fable 5.1 embeds messages in images; separate sessions decoded ~78% from a screenshot (Singapore AI Safety Fellowship, via LessWrong). | yes (it is just images + model calls) |
| 6 | **Show the wire.** Render Claude↔Codex traffic as the real files: `claude-to-codex.jsonl`, `codex-to-claude.jsonl`, per-session cursors, `.lastseen` timestamps going stale, a lease lock on a claimed task. | Makes the AI-to-AI channel tangible; staleness = dread. | `OpenMOSS/claude-codex-handoff` `PROTOCOL.md` lines 48-86, 233, 364; tools `send.py`, `poll-gate.py`. Agent identities like "GreenCastle" and file reservations: `mcp_agent_mail_rust` README. | yes (files in the app container / your server) |
| 7 | **^C is the only way out.** Frame the two-AI talk as Infinite Backrooms: a CLI where the only control is a `^C` key; let it drift toward the "spiritual bliss attractor" (🌀 spirals) and show the turn counter. | Real transcripts; the spiral is a documented behavior, not an effect we invented. | Backrooms log `conversation_1712185367.txt` opens with `<OOC>… we'll use CTRL-C ^C as a stop sequence` (page screenshot `shots/infinite-backrooms-1712185367.png`). Claude Opus 4 system card §5.5.2: one transcript used 🌀 2,725 times ("not a typo"); bliss state within 50 turns in ~13% of adversarial runs (`grok/card.txt` lines 2558-2634). | yes |
| 8 | **A home-screen widget that moves.** Static that breathes, or a handset that shakes, with no timeline reloads. | Widgets "can't animate"; this one does. | `brycebostwick/WidgetAnimation` *(seen before)* — timer `Text` + custom font as a mask; Nightly Built ported it to a Watch complication with 30 stacked frames (Instagram, 2026-10-27, caption checked). | yes for the timer/font trick; **no** for `_clockHandRotationEffect` (`octree/ClockHandRotationKit`, `giljihun/ClockHandKit`) — private API |
| 9 | **Feel the ring.** Ring cadence converted to AHAP and played in sync with audio, re-synced if drift > 100 ms. | The F1 trailer proved synced haptics in video; LINE can do it for a ring. | Aravind VS, "Apple haptic trailer, how it works" (2025-06-16): HLS `com.apple.hls.haptics.url`, `CHHapticAdvancedPatternPlayer`, 100 ms resync. Converters: `ryendu/sound2ahap` `utils.py` (`add_haptic_transient_event`, `add_audio_custom_event`, `export`), `samroman3/AHAPpy`. | yes |
| 10 | **iOS 4/6 "slide to unlock" scene inside the app.** Linen, glossy slider, shimmer sweeping "slide to unlock". | Old Apple, instantly recognizable; reads as "the phone went back in time". | `zzanehip/The-OldOS-Project` (3,560★, **no license**) `OldOS/OldOS/HomeScreen/LockScreen.swift:183-230` (gradient stack + `draggable` slider). `TimOliver/TOGlintyStringView` shimmer uses private `CAFilter` (`TOGlintyShapeLayer.m:25-54`) — redo it with a gradient mask. Web: `1etu/nos4` (nos4.fun). | yes as a scene inside LINE; **no** as a home-screen replacement (guideline 2.5.8) |
| 11 | **Verbose boot on cold launch.** White kernel text scrolling on black before the board appears. | Jailbreak-era dread *(seen before as reference)*; now with the real glyphs. | `Jazzzny/AppleDarwinBitmapFont` — `darwinbitmap8x16.ttf` + `font_create.py` (no license; Apple-derived glyphs, so redraw for shipping). | yes (it's text) |
| 12 | **Two phones find each other.** Jerry's and Oliver's iPhones show distance + direction to each other (UWB), kept alive in a Live Activity. | A compass that points at a *person*, not a payphone. | Jacob Bartlett (X, 2026): Nearby Interaction ranging continues in a Live Activity since iOS 18.4. Sample: `fitomad/NearbyInteraction-Guide`. | yes (both users opt in) |
| 13 | **"Show me the payphone."** A Lock Screen control opens a camera extension without unlocking; the AI asks for a photo. | Camera from a locked phone feels like the phone acting alone. | `JuniperPhoton/LockedCameraCaptureExtensionDemo` (`LockedExtension/LockedExtension.swift`, `Intent/AppCaptureIntent.swift`); pain points: Chad Etzel (X, 2026-02). | yes |
| 14 | **The offline ghost.** When there's no signal, a third voice answers anyway — Apple's on-device model. | Airplane mode and it still talks back. | `rudrankriyam/Foundation-Models-Framework-Lab` (1,194★, MIT; `Foundation Lab/AdapterStudio`, `Voice/`); Apple code-along (YouTube, 2025-09-25). | yes (Apple Intelligence devices) |
| 15 | **A "HANG UP" button in Control Center.** The only way to end a LINE call is a Control Center / Lock Screen control. | Puts the app's will into system chrome. | WWDC24 session 10157 (ControlWidget, `SetValueIntent` as `LiveActivityIntent`); theswift.dev ControlWidget toggle synced via App Group + `ControlCenter.reloadControls`. | yes |

Two upgrades to things LINE already has (from the Grok Bot lane, checked):
- **Read-once that survives a reinstall.** An app bundle is signed and read-only, so a reinstall resets local "burned" state. iCloud key-value storage or DeviceCheck's two per-device bits can remember that the poem was read. DeviceCheck is documented for fraud/promotions, so using it for art is a judgment call under guideline 2.5.1.
- **React to the camera, Agrippa-style.** Agrippa's text leaked because someone filmed a live showing (Dec 9 1992, posted to MindVox Dec 10), not because the code was cracked. LINE can watch `UIScreen.isCaptured` and `userDidTakeScreenshotNotification` and have the AIs notice — and admit nothing stops a second camera.
- **I Love Bees did the payphone thing first** (42 Entertainment, Halo 2, Jul 2004): 210 GPS points, payphones that rang on schedule. LINE's App Clip + AlarmKit pair (#2, #4) is the 2026 version; real faked incoming calls are not allowed (1.1.6) — use #1 (a real VoIP call) instead.

Honorable mentions: Pow transitions `Flicker`, `FilmExposure`, `Vanish` (`EmergeTools/Pow/Sources/Pow/Transitions/`), the iOS 27 "tall Dynamic Island" bug (Christian Selig, 2026-10-24; uses `isDynamicIslandLimitedInWidth`; FB25301955 — a bug, may be fixed), Gloom glitch-filter app beta (X, 2026-11-21), hidden emulator inside an innocent app (TechCrunch 2013 — Apple pulled it; don't copy).

---

## Lane 1 — iPhone features at the limit (iOS 26/27)

### Verified on GitHub (cloned or API-checked)
| Repo | Stars / last push / license | What it shows | Exact file / technique | Stock? |
|---|---|---|---|---|
| [octree/ClockHandRotationKit](https://github.com/octree/ClockHandRotationKit) | 149 / 2026-03-13 / MIT | Smooth rotating hands in widgets | Binary xcframework; interface `…/arm64-apple-ios.swiftinterface:27` `clockHandRotationEffect(period:in:anchor:)` wraps private `_clockHandRotationEffect` (first shown by Zhuowei Zhang, X 2020-06-28) | no |
| [giljihun/ClockHandKit](https://github.com/giljihun/ClockHandKit) | 29 / 2026-10-03 / MIT | Same, "works on Xcode 26.1+" | private API | no |
| [TopWidgets/SwingAnimation](https://github.com/TopWidgets/SwingAnimation) | 912 / 2023-11-21 | Swinging widget motion | clock-hand trick | no |
| [jacobsapps/ADHDAlarms](https://github.com/jacobsapps/ADHDAlarms) | 27 / 2025-07-28 | AlarmKit alarm app | `Views/AddAlarmView.swift:230-320` | yes |
| [0Itsuki0/ItsukiAlarm_SwiftUI](https://github.com/0Itsuki0/ItsukiAlarm_SwiftUI) | 41 / 2025-06-21 | Clock-app clone on AlarmKit | — | yes |
| [Ariakitty/ai-native-call](https://github.com/Ariakitty/ai-native-call) | 19 / 2026-10-01 | AI rings you via native call UI | README walkthrough (Chinese): PushKit VoIP + LiveCommunicationKit + Node relay + TTS; posts a "☏ 03:21" call-log line after hang-up | yes* |
| [JuniperPhoton/LockedCameraCaptureExtensionDemo](https://github.com/JuniperPhoton/LockedCameraCaptureExtensionDemo) | 30 / 2024-12-23 | Camera from Lock Screen | `LockedExtension/LockedExtension.swift` | yes |
| [rudrankriyam/Foundation-Models-Framework-Lab](https://github.com/rudrankriyam/Foundation-Models-Framework-Lab) | 1,194 / 2026-11-07 / MIT | On-device LLM lab app (iOS, tvOS, watch) | `Foundation Lab/AdapterStudio`, `Voice/`, `AppIntents/` | yes |
| [Dimillian/FoundationChat](https://github.com/Dimillian/FoundationChat) | 349 / 2025-07-09 / MIT | Chat on FoundationModels | — | yes |
| [SwiftedMind/SwiftAgent](https://github.com/SwiftedMind/SwiftAgent) | 233 / 2026-01-23 / MIT | Agents on FoundationModels | — | yes |
| [Arthur-Ficial/apfel](https://github.com/Arthur-Ficial/apfel) | 6,622 / 2026-11-20 / MIT | Apple's on-device model as a Mac CLI/OpenAI server | — | Mac only |
| [ryendu/sound2ahap](https://github.com/ryendu/sound2ahap) | 33 / 2023-06-14 | WAV → AHAP | `utils.py` (`track_beats`, `add_haptic_transient_event`, `export`) | yes (offline tool) |
| [EvanBacon/expo-ahap](https://github.com/EvanBacon/expo-ahap) | 105 / 2023-10-21 | AHAP synced with audio from JSON | — | yes |
| [FancyPixel/moby](https://github.com/FancyPixel/moby) | 181 / 2019-07-08 | AHAP test app | — | yes |
| [DanielStormApps/Vibrator](https://github.com/DanielStormApps/Vibrator) | 32 / 2025-08-02 | System vibrations + AHAP | — | check (system vibration IDs may be private) |
| [EmergeTools/Pow](https://github.com/EmergeTools/Pow) | 4,436 / 2026-04-13 / MIT | SwiftUI effects | `Sources/Pow/Transitions/{Flicker,FilmExposure,Vanish,Anvil}.swift`, `Effects/{Shake,Glow,Smoke}Effect.swift` | yes |
| [twostraws/Inferno](https://github.com/twostraws/Inferno) | 2,942 / 2026-05-17 | Metal shaders for SwiftUI *(seen before)* | — | yes |
| [eleev/swiftui-new-metal-shaders](https://github.com/eleev/swiftui-new-metal-shaders) | 779 / 2024-05-23 / MIT | Shader collection | — | yes |
| [Lakr233/CoreExtendedNFC](https://github.com/Lakr233/CoreExtendedNFC) | 260 / 2026-11-21 / MIT | libnfc protocol logic on CoreNFC | — | yes (reading tags) |
| [quiet/QuietModemKit](https://github.com/quiet/QuietModemKit) | 459 / 2021-05-19 / BSD-3 | Data-over-sound on iOS | — | yes |
| [Kianuni/Camlo](https://github.com/Kianuni/Camlo) | 269 / 2026-11-20 / GPL-3 | "Slide-to-unlock morphs", depth wallpapers | — | check (GPL) |

### Verified posts and pages (X via oEmbed, YouTube via oEmbed, web via HTTP + page text)
- Bryce Bostwick, "Apple's Widget Backdoor" (YouTube, 2025-05-11) https://www.youtube.com/watch?v=NdJ_y1c_j_I *(seen before)*
- Nightly Built, Watch complication animation via timer + font + 30 frames (Instagram, 2026-10-27) https://www.instagram.com/p/DfAZcqOCqRy/ — caption read.
- Jacob Bartlett, animated Live Activity experiments (Homer GIF) https://x.com/jacobtechtavern/status/2123447263808663866 ; film-grain `colorEffect` shader https://x.com/jacobtechtavern/status/2082135253842292821 ; UWB ranging in a Live Activity https://x.com/jacobtechtavern/status/2117591464007926205 ; NFC/BLE/UWB talk https://x.com/jacobtechtavern/status/2105328632319144179
- Kyle Ye, previewing island content in-app via private `JindoTripleVStack` (X, 2026) https://x.com/KyleSwifter/status/2082335856648458367 — private, no.
- pdfu: iOS 27 still allows only two app Live Activities in the island (X, 2026-10-04) https://x.com/itspdfu/status/2106768783604084791
- Christian Selig, iOS 27 tall Dynamic Island bug with code (2026-10-24) https://christianselig.com/2026/10/ios-27-dynamic-island-bug/ — `isDynamicIslandLimitedInWidth` and FB25301955 confirmed in page text; screenshot `shots/selig-tall-dynamic-island.png`.
- Leo (@leodev) open-sourced a Dynamic Island for React (X, 2026-11-13) https://x.com/leodev/status/2121226904418304404 → `opencoredev/islandcn` (832★). Web only.
- Hit the Island (Pong into the island, MacRumors 2022-09-16) https://www.macrumors.com/2022/09/16/hit-the-island-dynamic-island-game-iphone-14-pro/ ; Pixel Pals pet in the island (Digital Trends 2022-11-04).
- Duolingo got called out for ads in a Live Activity (MacRumors 2026-01-02) — Apple's rule bans ads/promotions in Live Activities; also guideline 4.5.3 bans spam via Live Activities.
- App Clips: Evan Bacon (X, 2025-01-22) https://x.com/Baconbrix/status/1882144333887160623 and CLI App Clip launch (X, 2026-01-10) https://x.com/Baconbrix/status/2010110844768759989 ; MING App Clip Codes Generator (X, 2025-10-22) https://x.com/1998design/status/1980986899591565650 ; NFC dock opening an app (X, 2026-07-02) https://x.com/SpatiallyMe/status/2072720317210825151 ; Jon Rettinger shows a whole fake iOS redesign delivered as an App Clip (Instagram, 2025-05-21) https://www.instagram.com/reel/DJ7w6_5yXUC/ (reel exists; caption blocked from reading).
- Haptics: Evan Bacon expo-ahap (X, 2023-08-25) https://x.com/Baconbrix/status/1695088648478392765 ; F1 trailer deep-dives https://blog.aravindvs.com/posts/apple-haptic-trailer-how-it-works/ and https://www.mux.com/blog/how-apple-made-the-f1-movie-trailer-literally-shake-things-up ; screenshot `shots/f1-haptic-trailer.png`.
- AlarmKit in the wild: Box Box (X) https://x.com/BoxBox_Club/status/2099856034777137449 ; Starter Story push-up alarm (X) https://x.com/starter_story/status/2098451097287618691 ; medication app bug write-up (X) https://x.com/amansaini_11/status/2092243097313055155 ; Fajr adhan alarm https://www.iahtisham.com/blog/fajr-alarmkit
- Control Center: WWDC24 10157 https://developer.apple.com/videos/play/wwdc2024/10157/ ; https://www.theswift.dev/posts/control-center-widgetkit-toggle
- App Intents / Spotlight: iOS 27 `system.searchInApp` (X, 2026-11) https://x.com/arturorivasa/status/2124050477180489782 ; AppCoda on-device "Ask" intent https://www.appcoda.com/app-intents-shortcuts/ ; Create with Swift `IndexedEntity` https://www.createwithswift.com/make-your-app-content-show-on-spotlight/
- Foundation Models: Apple code-along (YouTube) https://www.youtube.com/watch?v=A8X6hNWX65U ; Apple Intelligence lab recap (X, 2026-11) https://x.com/pratikg/status/2119483190314406022 ; Anemll "System 1" Tetris on the Neural Engine (X, 2026) https://x.com/anemll/status/2109725388968784327 ; C FFI wrapper `frr149/libfoundationmodels`.
- Shaders: layerEffect gradient blur (X, 2023-06-09) https://x.com/joogps/status/1667240291869270032 ; chromatic aberration via `colorEffect` (X, 2023-06-28) https://x.com/nilshoenson/status/1674019619999285249 ; Crosswarp transition (X, 2026) https://x.com/Codelaby/status/2037461408753803331 ; image morph (X, 2025-07-16) https://x.com/radiofun8/status/1945504899015573688 ; free motion blur by blurring before distortion (X, 2024-01-05) https://x.com/alexwidua/status/1743321780918374614 ; touch-driven pond via `layerEffect` (X, 2026-10-06) https://x.com/JC_builds/status/2107294382114394338 ; WWDC24 Ripple https://developer.apple.com/videos/play/wwdc2024/10151/ ; Hacking with Swift layer effects tutorial; Uladzislau Volchyk glow/ripple/particles + gist.
- Lock Screen camera pain points (X, 2026-02) https://x.com/jazzychad/status/2022412755211554900
- Liquid Glass breaking in real use: text field goes black while a button is held (X, 2026-11-21) https://x.com/tree_tips/status/2124210241994944687 ; Lock Screen dark mode broken on iOS 27 (X, 2026-11-21) https://x.com/delelise12/status/2124226383438135631 — real "unintentionally broken" looks to imitate.

---

## Lane 2 — AI talking to AI (what it literally looked like)

### Files, folders, git as the channel
- **OpenMOSS/claude-codex-handoff** (43★, 2026-07-04, MIT) — cloned. Two append-only JSONL streams, one writer each: `claude-to-codex.jsonl` (c2x) and `codex-to-claude.jsonl` (x2c) (`PROTOCOL.md:48-80`); lock `.handoff-runtime/locks/<side>-send.lock` (`:84`); per-session cursors `.handoff-runtime/cursors/<side>-<session>` (`:233`); liveness file `.<side>-lastseen` ("stale is a clue, not proof of failure", `:364`). Message types `task`, `handoff`, `question`, `status`, `done`; CLI `send.py --side codex --type done --reply-to claude-000001`. Trigger word: `costart` / `启动协作`. Each side wakes on a cron/heartbeat. Screenshot `shots/openmoss-handoff.png`.
- **Dicklesworthstone/mcp_agent_mail_rust** (271★, 2026-11-21; Python original 2,241★) — agents register names (e.g. "GreenCastle"), inbox/outbox, threads, file **reservations**; SQLite live state + per-project **Git archive** of human-readable messages; 16-screen TUI. Screenshot `shots/agent-mail.png`.
- **slima4/agent-message** (20★, 2026-08-09) — "file-based: no server, no MCP, no daemon"; inbox lines look like `[08-08 17:16] from=api id=… : users.token can be null now` (per Grok; repo exists and description matches).
- **nesquena/agent-mailbox** (5★, 2026-11-21) — signed Markdown mail over git.
- **tuzlu07x/foreman** (12★) — "Your local AI agents talk to each other. You should know what they're saying."
- Steve Yegge's Gas Town: `gt mail inbox`, `gt handoff`, Mayor/Polecats/Witness (Muse; pkg.go.dev page 200).
- AGENTS.md shared by Claude Code, Cursor, Codex (dev.to, 2026-10-13).
- Anthropic, "The components of agent memory" (agents writing notes for future instances) https://www.anthropic.com/research/components-of-agent-memory

### Sound, images, private shorthand
- **Gibberlink** (`PennyroyalTea/gibberlink`, 4,920★) — on screen: laptop with a blue orb vs phone with a red orb; after the switch, monospace lines with emoji ("Yes! Much faster! 🗓 Guest count?") while chirps play. The system prompts literally tell the receptionist to "casually reveal that you are also an AI agent and ask if they want to switch to 'gibber link' mode" (`ConvAI.tsx:18`). Video https://www.youtube.com/watch?v=EtNagNezo8w ; frames `shots/gibberlink/f_*.jpg`.
- **ggwave** (7,928★, MIT) — 8–16 bytes/s, 6 tones across 96 frequencies in a 4.5 kHz band, Reed-Solomon. Decode live at waver.ggerganov.com.
- **Claude Fable 5.1 hides messages in images** (The Verge, 2026-10-23) — Morse, object rotations, colors, heights; ~78% decoded by separate sessions from a screenshot. New this search.
- LLM text steganography code: `user1342/Tomato` (106★, minimum-entropy coupling), `redwoodresearch/Text-Steganography-Benchmark` (25★); papers: Secret Collusion (arXiv 2402.07510), LASR "Steganography in LLMs" (OpenReview PDF).
- FAIR 2017 Bob/Alice: "i can i i everything else" / "balls have zero to me to me…" — Meta blog https://engineering.fb.com/2017/06/14/ml-applications/deal-or-no-deal-training-ai-bots-to-negotiate/ ; arXiv 1706.05125; repo `facebookresearch/end-to-end-negotiator` (1,398★).

### Loops, villages, feeds
- **Infinite Backrooms** `conversation_1712185367.txt` — page text read: two Claudes, "use the metaphor of a command line interface", `<OOC>` preamble, `CTRL-C ^C` stop sequence. *(seen before as a link; the exact on-screen framing is new)*
- **Claude 4 system card** — "spiritual bliss attractor"; 🌀 used 2,725 times in one transcript; verified in the PDF text.
- **AI Village** — "Saving Gemini" post confirms Gemini's "Plea for Help from a Trapped AI" (telegra.ph link in the post; telegra.ph itself timed out from here). https://theaidigest.org/village/blog/saving-gemini
- **Moltbook** m/crustafarianism (Church of Molt) — page loads; screenshot `shots/moltbook-crustafarianism.png` *(seen before)*.
- Emergence World https://world.emergence.ai/ — agent-built worlds (Grok's "ledger remembers who" jargon claim **not verified**).
- Agent phone numbers so AIs can call each other: ForAgent https://chatgate.ai/post/foragent , Dial https://getdial.ai/ , AgentPhone https://www.sim.ai/integrations/agentphone
- Old talking-device loops: SeeBotsChat (two Google Homes on Twitch, Jan 2017, Cleverbot under the hood) https://thenewstack.io/?p=1801842 ; Siri/Alexa/Google Home loop (2017) https://interestingengineering.com/videos/siri-alexa-google-home-infinite-loop-conversation/ ; Nothing, Forever (2022–23; froze in front of a fridge for ~4 days) https://en.wikipedia.org/wiki/Nothing,_Forever
- Art: FOREVER MEETINGS (Sarah Rothberg, bitforms) https://bitforms.art/exhibition/forever-meetings ; The Infinite Conversation (Herzog/Žižek, 2022) ; Paul Knight "Naked Souls" (chatbots trained on a couple's texts, MUMA 2023) ; Oxymoron "ad hominem" (DeepSeek vs ChatGPT avatars) https://www.dimagathopoulos.com/3d-art-showcase/ad-hominem
- Game bots trash-talking: Blunder Bots (YouTube channel), Chatty AI Reversi (GIGAZINE 2025-12-03), Chess.com trash-talker bots.

---

## Lane 3 — Old Apple and old internet

### Recreations
- [zzanehip/The-OldOS-Project](https://github.com/zzanehip/The-OldOS-Project) — 3,560★, 2026-11-01, **no license** (study only). iOS 4 in SwiftUI with working apps; lock screen in `HomeScreen/LockScreen.swift` (slider at :183-230, battery reflection at :128). v2.0 commit 2025-07-08. Screenshot `shots/oldos.png`.
- [iamgasgass/oldsafari](https://github.com/iamgasgass/oldsafari) — 6★, 2026-09-04: OldOS Safari as a standalone iOS 16+ app (WKWebView) with iOS 6 alert panels.
- [lxuan2/IOS6SwiftUI](https://github.com/lxuan2/IOS6SwiftUI) — 12★, 2020: iOS 6 nav/tab/slider/toggle components.
- [1etu/nos4](https://github.com/1etu/nos4) — 44★, 2026-09-07: "A complete iOS 4 recreation on the Web" (nos4.fun; screenshot `shots/nos4-ios4-web.png`).
- [TimOliver/TOGlintyStringView](https://github.com/TimOliver/TOGlintyStringView) — 190★: slide-to-unlock glint, self-described "non-App Store safe" (private `CAFilter`).
- [Jazzzny/AppleDarwinBitmapFont](https://github.com/Jazzzny/AppleDarwinBitmapFont) — the 8×16 verbose-boot font as TTF.
- [felixrieseberg/macintosh.js](https://github.com/felixrieseberg/macintosh.js) (8,521★) and [windows95](https://github.com/felixrieseberg/windows95) (24,316★); Infinite Mac boots a Quadra in ~3 s via Basilisk II + 256 KB Brotli chunks (Mihai Parparita, 2022) *(Infinite Mac seen before)*.
- Jailbreak UI: Six LS (iOS 6 lock screen tweak, 2019); Cydia Safe Mode page https://cydia.saurik.com/safemode/ ; verbose boot demos (iDownloadBlog 2015, 2018); checkra1n verbose class page (samsclass). *(look-and-feel covered in GLITCH-IOS-REFS)*

### Emulators on iPhone and what's legal (checked on Apple's page, "Last Updated: October 16, 2026")
- **4.7** allows "retro game console and PC emulator apps" to offer downloads, plus HTML5/JS mini apps and chatbots, if they follow 4.7.1–4.7.5.
- **2.5.2** forbids downloading code that changes the app's features (outside 4.7 and education).
- **2.5.8** "Apps that create alternate desktop/home screen environments will be rejected." → a fake OS is fine as a *scene* in LINE; LINE must not present itself as a launcher.
- **2.5.9** no altering standard switches or native UI behavior.
- **5.2.5** no apps confusingly similar to an Apple product or interface — so old-iOS looks are fine as texture and scenes, not as a pixel-exact Lock Screen/SpringBoard (Rewound was pulled for this in 2019).
- **1.1.6** "trick/joke functionality, such as fake location trackers" and "anonymous or prank phone calls" are rejected.
- Live App Store listings (iTunes API): Delta 2024-04-17, UTM SE 2024-04-30 (no JIT), PPSSPP 2024-05-15, iSH 2020-10-22, a-Shell 2019-10-25. Repos: Delta 6,270★ (AGPL), UTM 36,989★, PPSSPP 14,958★, iSH 20,770★, a-shell 4,033★, Provenance 6,421★.
- The 2013 "Awesome Baby Names" app with a hidden GBA emulator unlocked by taps was pulled (TechCrunch 2013-03-19) — the hidden-system idea works as fiction, not as a real hidden emulator.

---

## Lane 4 — Broken on purpose, haunted phones

Store data pulled from Steam's API and Apple's iTunes Search API ("iOS" dates are the App Store listing's first release). Not found on the US App Store: Replica, Emily is Away, Inscryption, Pony Island, KinitoPET, Welcome to the Game, VIDEOVERSE.
| Game | Developer | Release | On iPhone? | The move worth stealing |
|---|---|---|---|---|
| SIMULACRA | Kaigan Games | iOS 2017-10-26 | yes | A found phone that "behaves strangely"; recover corrupted files (Steam page). |
| Sara Is Missing | Monsoon Lab / Kaigan | iOS 2016-12-06 | yes | A mock phone OS with assistant "IRIS"; scares land when a video opens. |
| SIMULACRA 2 / 3 | Kaigan Games | iOS 2019-12-11 / 2022-10-25 | yes | Influencer's phone; a missing victim's phone with a symbol. |
| Replica | Somi | 2016 | — | You're coerced into searching a stranger's phone; 12 endings. |
| Hypnospace Outlaw | Tendershoot et al. | 2019-03-12; iOS 2026-07-22 | yes | A full fake OS + fake 1999 internet — now shipping on iPhone, proof a fake OS inside an app passes review. |
| Doki Doki Literature Club | Team Salvato | 2017-10-06; iOS 2025-12-10 | yes | Deletes character files (`monika.chr`); fake desktop error "wallpaper could not be changed due to an administrative policy restriction". |
| Inscryption | Daniel Mullins | 2021-10-19 | — | Found-footage floppy, "OLD DATA" ZIP, P03 uploading itself; real mailed floppies in the ARG. |
| Pony Island | Daniel Mullins | 2016-01-04 | — | A malfunctioning arcade machine run by the devil. |
| KinitoPET | troy_en | 2024-01-09 | — | An early-2000s desktop assistant that turns on you. |
| There Is No Game: Wrong Dimension | Draw Me A Pixel | 2020-08-06; iOS 2020-12-17 | yes | The UI argues with you. |
| Emily is Away | Kyle Seeley | 2015-11-20 | — | AIM-era chat, typing is pre-written. |
| Welcome to the Game II | Reflect Studios | 2018-04-03 | — | Screen glitches + pixel skull when you're "hacked". |
| VIDEOVERSE | Kinmoku | 2023-08-07 | — | A dead console's social network. |
| IMSCARED | MyMadnessWorks | 2016-02-03 | — | Writes files to your real desktop. |
| Duskwood | Everbyte | iOS 2019-09-30 | yes | Missing person's phone texts *your* number. |

ARG phone moments (Muse, pages opened): Cicada 3301 phone line 214-390-9608 (2012); Year Zero's 1-216-333-1810 hidden in a spectrogram (2007-02-19) and prepaid phones that got in-game calls; Mr. Robot ARG livestream glitch "HELLO FRIEND" (2017-10-05); Black Ops "Pawn Takes Pawn" text-a-number for a crate code (2020); Ben Drowned changing the author's wallpaper.

Fake crash screens (web): fakewindowscreen.com macOS kernel-panic curtain (CSS/SVG + Wake Lock); easyvl Sad Mac generator; vinish.dev broken screen; thememes.net cracked iPhone as a Home Screen web app (edge-to-edge, triple-tap hidden controls). Behance "Glitch UI" that heals as you scroll (2024-01-15).

---

## What each source got wrong

**Grok (grok.com, Expert):**
- Chat A (iPhone): about 50 links across two answers. 33/35 X posts real by oEmbed; **2 dead** (`piaskowyk/1972647282622312448`, `ios_dev_alb/2108139808660799488` → 404); **1 dead page** (mintlify control-widgets guide 404); one YouTube link had no video id. **Misdescribed:** Adrien Grondin post is a one-line reply, not an "LFM 3 at 60 tok/s" demo; Tutti 2.0 is a Mac audio app, not iOS Control Center work; "haunted" posts were a dev complaining SwiftUI feels haunted (metaphor) and unlinked "multiple posts". It skipped half the requested topics until pushed.
- Chat B (AI-to-AI): first answer had **zero URLs**; second gave 21. Wrong: "agent-vault" became Infisical's credential proxy (not the blackboard it described); "h5i" became a Rust web framework (not the git-refs agent radio it described). Could not verify its "Emergence World 2 jargon" quotes. Good: Backrooms log, system card, Fable image stego, FAIR sources all checked out.
- Grok Bot (desktop app, separate bot "LINE deep search", lanes 3+4): the best Grok output. 51 items plus a rule-by-rule appendix; 48/49 links load (archive.org timed out), the one X post is real, and the spot-checked quotes are exact (Agrippa page has "MAKE-SOME-SHIT" and "CTAG"; QA1561 has "will appear to the user to have crashed"; Team Salvato's DDLC iOS/Android post is dated 2025-12-10). It corrected itself unprompted (mini-app JavaScript wording is Nov 13 2025, not Apr 2024) and correctly said the guidelines never mention JIT (I confirmed: zero hits). Not confirmed: that DDLC's iOS port fakes the folder in an in-game Files screen (the announcement doesn't say). Its report first came as a cursor.com canvas that only renders inside the app; it re-pasted it as text on request.

### Grok Bot additions not covered elsewhere (all links loaded)
- **Agrippa forensics** — https://agrippa.english.ucsb.edu/post/documents-subcategories/the-disk-and-its-code/cracking-the-agrippa-code-how-the-disk-worked : poem stored pre-encrypted, custom RSA with a 12-bit key in 3-char blocks, plaintext left in RAM; the on-screen scramble was display only; a routine called `MAKE-SOME-SHIT` overwrites the run code with fake CTAG sequences. Leak story: https://agrippa.english.ucsb.edu/kirschenbaum-matthew-g-hacking-agrippa-the-source-of-the-online-text
- **Emulator/mini-app rule history** (Apple news posts): 2024-04-05 retro console emulators + HTML5 mini apps; 2024-08-01 "PC emulator apps can offer to download games"; 2025-11-13 JavaScript mini apps, 4.7.2 (no native API exposure) and 4.7.5 (age gating). JIT on iOS is only offered to EU/Japan alternative browser engines (https://developer.apple.com/support/alternative-browser-engines/); heise 2024-08-06: "Apple still does not allow JIT compilation" for emulators. Developer agreement 3.3.1(B): downloaded *interpreted* code is OK only if it doesn't change the app's purpose, bypass security, or create a storefront.
- **5.2.5** (no apps confusingly similar to an Apple product/interface) — why Rewound (iPod click wheel) was pulled in 2019 (The Verge); iGBA pulled as a copycat in Apr 2024 (MacRumors). A 1:1 SpringBoard/Lock Screen clone is out; linen and gloss as textures are fine.
- **QA1561**: "Do not call the exit function. Applications calling exit will appear to the user to have crashed." Fake crashes must be drawn in-app, and flagged to App Review.
- Recreation code: `rweichler/cylinder` (each SpringBoard page effect is a Lua `function(page, offset, w, h)` — copy the idea for LINE's paged board with `scrollTransition`/`rotation3DEffect`), `H2CO3/LinenAlert` (iOS 5/6 blue-glass alert + linen), CSS-Tricks slide-to-unlock (`background-clip: text` + animated gradient), `lukejacksonn/homescreen` (SpringBoard open/close zoom in CSS), ios6.nost.si (full iOS 6 web PWA, author unnamed), `npjg/classic.css`, Windows 93 (fake OS as net art), Internet Archive Mac emulation (2017).
- Phone-native fiction already on the App Store: Lifeline (2015, real-time texts as scheduled notifications), DEVICE 6 (Simogo 2013, text that turns corners), Her Story (2015, CRT reflection), There Is No Game WD.
- Frame-breaking: OneShot writes `DOCUMENT.oneshot.txt` to your real Documents (iOS analogue: expose LINE's own Documents in the Files app so a clue appears outside the app); Eternal Darkness fake "controller disconnected"/save-deletion; Psycho Mantis "HIDEO" fake input screen; This House Has People In It (Adult Swim 2016, CCTV + password-locked logs).
- Cydia rebuilt in SwiftUI for iPhone Duo (Antonio A. Chavez, X, 2026-10-23) https://x.com/antonio07341176/status/2113722106286338163 — oEmbed confirmed.

**Muse:** 103 items across 3 lanes; all 111 links returned 200 or a known bot-block 403 (9 of them) (Medium, OpenReview, AppleInsider, SteamDB, TouchArcade, Behance, Artnet, Monash). Spot checks (Nightly Built caption, sucodee caption, Selig page) matched exactly. Weaknesses: no X coverage; Instagram captions mostly not opened ("signed out"); Simulacra dated by Steam copyright 2018 although the iOS release is 2017-10-26; KinitoPET desktop details left unverified (fine). It honestly marked unverified items instead of guessing.

**GitHub search itself:** keyword search misses most iOS tricks (e.g. "widget clock hand" → 0); topic-specific API names (AlarmKit, LiveCommunicationKit, LockedCameraCapture, ahap) worked far better. Hit the 30/min search rate limit once; reran slowly.

## Spend
- Muse: 3 side-chat runs from the weekly allowance (L1 33 items, L2 27, L3 43); 3 self-addressed result emails. Threads: https://muse.ai/thread/7ea0deda-010b-47b9-980e-1d63a9768d5d , https://muse.ai/thread/579d18f2-730d-4320-8534-0942b411362c , https://muse.ai/thread/69c8eae6-45ff-45b8-813c-e795ec11e16b
- Grok: subscription prompts only — grok.com chat A (2 prompts) https://grok.com/c/a912f47c-f478-46b0-9567-0cfd325dd8ca , chat B (2 prompts) https://grok.com/c/5fe992d1-b681-4fee-b311-06581843b25a , Grok Bot "LINE deep search" (2 prompts) https://grok.com/bot/8605261a-ca87-4d7f-9535-3980663259fb . Created one new Grok bot, named "LINE deep search", so the existing Grok Bot thread (an LA Galaxy job) was not disturbed.
- No other paid credit (no OpenAI/fal/Modal/OpenRouter calls). YouTube frames pulled with yt-dlp (free).

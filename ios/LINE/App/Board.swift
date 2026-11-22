import SwiftUI

/// One full-screen board: every feature, each with its styles. Tap a tile to run it.
struct Board: View {
    struct Item: Identifiable { let id: String; let title: String; let styles: [String] }
    let items: [Item] = [
        .init(id: "notify", title: "NOTIFICATIONS", styles: ["real lock screen", "iOS 4 banner", "iOS 6 alert", "kernel failure"]),
        .init(id: "haptic", title: "HAPTICS", styles: ["morse", "heartbeat", "phone bell", "static"]),
        .init(id: "takeover", title: "TAKEOVER", styles: ["screen melt", "crt off", "cracks"]),
        .init(id: "watch", title: "THEY ARE WATCHING", styles: ["claude + grok, live", "gibberlink chirps"]),
        .init(id: "files", title: "FILES BETWEEN AIs", styles: ["claude + codex, live"]),
        .init(id: "live", title: "DYNAMIC ISLAND", styles: ["call", "uploading you", "redacted"]),
        .init(id: "icon", title: "APP ICON", styles: ["clean", "cracked", "static"]),
        .init(id: "lock", title: "READ ONCE", styles: ["real device lock"]),
        .init(id: "near", title: "NEAREST PAYPHONE", styles: ["location + compass"]),
        .init(id: "alarm", title: "RINGS THROUGH SILENT", styles: ["real system alarm"]),
        .init(id: "ghost", title: "NO SIGNAL", styles: ["on-device model, airplane mode"]),
        .init(id: "time", title: "BACK IN TIME", styles: ["2010 lock screen"]),
        .init(id: "boot", title: "BOOT", styles: ["jailbreak log"]),
        .init(id: "pickup", title: "PICK UP", styles: ["the first call"]),
    ]
    @State private var open: Item.ID? = nil
    @State private var booted = false
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if !booted { BootLog { withAnimation(.easeOut(duration: 0.3)) { booted = true } }.zIndex(5) }
            StaticNoise(level: 0.05).ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("LINE").font(.system(size: 13, weight: .bold, design: .monospaced)).tracking(6).foregroundStyle(.gray).padding(.bottom, 18)
                    ForEach(items) { it in
                        Button { Haptics.shared.ringOnce(); open = it.id } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(it.title).font(.system(size: 24, weight: .black, design: .monospaced)).foregroundStyle(.white)
                                Text(it.styles.joined(separator: " · ")).font(.system(size: 12, design: .monospaced)).foregroundStyle(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading).padding(.vertical, 16)
                            .overlay(alignment: .bottom) { Rectangle().fill(.white.opacity(0.1)).frame(height: 1) }
                        }
                    }
                }
                .padding(.horizontal, 22).padding(.top, 70).padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .fullScreenCover(item: Binding(get: { open.map { IdBox(id: $0) } }, set: { open = $0?.id })) { box in
            ZStack(alignment: .topTrailing) {
                demo(box.id)
                Button { open = nil } label: {
                    Text("×").font(.system(size: 26, weight: .light, design: .monospaced)).foregroundStyle(.white.opacity(0.6)).frame(width: 52, height: 52)
                }.padding(.top, 50)
            }
            .statusBarHidden(true)
        }
        .modifier(Watcher())
        .onAppear { Haptics.shared.prepare() }
    }
    @ViewBuilder func demo(_ id: String) -> some View {
        switch id {
        case "notify": NotifyDemo()
        case "haptic": HapticDemo()
        case "takeover": TakeoverDemo()
        case "watch": AILineDemo(mode: "watch")
        case "files": AILineDemo(mode: "files")
        case "live": LiveDemo()
        case "icon": IconDemo()
        case "lock": LockDemo()
        case "near": NearDemo()
        case "alarm": AlarmDemo()
        case "ghost": GhostDemo()
        case "time": BackInTime()
        case "boot": BootLog { }
        default: ContentView()
        }
    }
}
struct IdBox: Identifiable { let id: String }

/// Shared look for each demo: big title, style chips, a stage.
struct DemoShell<Content: View>: View {
    let title: String; let styles: [String]; @Binding var pick: Int; let content: Content
    init(title: String, styles: [String], pick: Binding<Int>, @ViewBuilder content: () -> Content) { self.title = title; self.styles = styles; self._pick = pick; self.content = content() }
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 14) {
                Text(title).font(.system(size: 30, weight: .black, design: .monospaced)).foregroundStyle(.white).padding(.top, 64)
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(Array(styles.enumerated()), id: \.offset) { i, s in
                            Button { pick = i; Haptics.shared.ringOnce() } label: {
                                Text(s).font(.system(size: 12, design: .monospaced)).padding(.horizontal, 12).padding(.vertical, 8)
                                    .background(pick == i ? Color.white : .clear).foregroundStyle(pick == i ? .black : .white)
                                    .overlay(Rectangle().stroke(.white.opacity(0.5), lineWidth: 1))
                            }
                        }
                    }
                }.scrollIndicators(.hidden)
                content.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 20).padding(.bottom, 24)
        }
    }
}

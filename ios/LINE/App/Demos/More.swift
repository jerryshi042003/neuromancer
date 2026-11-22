import SwiftUI
import AlarmKit
import ActivityKit
#if canImport(FoundationModels)
import FoundationModels
#endif

// MARK: A real alarm that rings through Silent and Focus, titled with a real payphone.
struct LineAlarmMeta: AlarmMetadata {}

struct AlarmDemo: View {
    @State private var status = "schedules a real system alarm one minute from now. lock the phone and put it on silent."
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                Text("IT RINGS\nTHROUGH\nSILENT").font(.system(size: 40, weight: .black, design: .monospaced)).foregroundStyle(.white)
                Text(status).font(.system(size: 13, design: .monospaced)).foregroundStyle(.gray)
                Button { Task { await schedule() } } label: {
                    Text("SET THE LINE TO RING").font(.system(size: 14, weight: .semibold, design: .monospaced)).frame(maxWidth: .infinity).padding(.vertical, 17).background(.white).foregroundStyle(.black)
                }
                Spacer().frame(height: 30)
            }.padding(.horizontal, 22)
        }
    }
    func schedule() async {
        Haptics.shared.ringOnce()
        do {
            let auth = try await AlarmManager.shared.requestAuthorization()
            guard auth == .authorized else { status = "alarms are not allowed for LINE in Settings."; return }
            let alert = AlarmPresentation.Alert(title: "2101 VIA ARADO, COMPTON", stopButton: AlarmButton(text: "Hang Up", textColor: .white, systemImageName: "phone.down.fill"))
            let attrs = AlarmAttributes<LineAlarmMeta>(presentation: AlarmPresentation(alert: alert), tintColor: .red)
            let config = AlarmManager.AlarmConfiguration<LineAlarmMeta>(schedule: .fixed(Date().addingTimeInterval(60)), attributes: attrs)
            _ = try await AlarmManager.shared.schedule(id: UUID(), configuration: config)
            status = "set. lock your phone. in one minute line 310-637-8714 rings."
        } catch { status = "could not set it: \(error.localizedDescription)" }
    }
}

// MARK: Back in time: the 2010 lock screen, rebuilt from scratch.
struct BackInTime: View {
    @State private var drag: CGFloat = 0
    @State private var unlocked = false
    @State private var shimmer: CGFloat = -1
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Linen().ignoresSafeArea()
                VStack(spacing: 0) {
                    VStack(spacing: 2) {
                        Text(Date(), format: .dateTime.hour().minute()).font(.system(size: 76, weight: .ultraLight)).foregroundStyle(.white)
                        Text(Date(), format: .dateTime.weekday(.wide).month(.wide).day()).font(.system(size: 17, weight: .medium)).foregroundStyle(.white.opacity(0.9))
                    }
                    .frame(maxWidth: .infinity).padding(.top, 64).padding(.bottom, 14)
                    .background(LinearGradient(colors: [Color.black.opacity(0.75), Color.black.opacity(0.45)], startPoint: .top, endPoint: .bottom))
                    .overlay(alignment: .bottom) { Rectangle().fill(.white.opacity(0.18)).frame(height: 1) }
                    Spacer()
                    if unlocked {
                        Text("1 missed call\nLINE 310-637-8714").font(.system(size: 17, weight: .semibold)).foregroundStyle(.white).multilineTextAlignment(.center).shadow(radius: 4).transition(.opacity)
                        Spacer()
                    }
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 12).fill(LinearGradient(colors: [Color.black.opacity(0.75), Color(white: 0.15).opacity(0.8)], startPoint: .top, endPoint: .bottom))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.white.opacity(0.2), lineWidth: 1)).frame(height: 70)
                        Text("slide to unlock").font(.system(size: 22, weight: .regular)).foregroundStyle(
                            LinearGradient(stops: [.init(color: .gray, location: max(0, shimmer - 0.15)), .init(color: .white, location: max(0, min(1, shimmer))), .init(color: .gray, location: min(1, shimmer + 0.15))], startPoint: .leading, endPoint: .trailing))
                            .frame(maxWidth: .infinity).opacity(1 - Double(drag / 180))
                        RoundedRectangle(cornerRadius: 9).fill(LinearGradient(colors: [Color(white: 0.98), Color(white: 0.72)], startPoint: .top, endPoint: .bottom))
                            .frame(width: 78, height: 56).overlay(Image(systemName: "arrow.right").font(.system(size: 26, weight: .bold)).foregroundStyle(Color(white: 0.45)))
                            .padding(.leading, 7).offset(x: drag)
                            .gesture(DragGesture().onChanged { v in drag = max(0, min(geo.size.width - 140, v.translation.width)) }
                                .onEnded { _ in
                                    if drag > geo.size.width - 170 { Haptics.shared.crack(); withAnimation { unlocked = true } }
                                    withAnimation(.spring) { drag = 0 }
                                })
                    }
                    .padding(.horizontal, 20).padding(.bottom, 44)
                }
            }
        }
        .onAppear { withAnimation(.linear(duration: 2.4).repeatForever(autoreverses: false)) { shimmer = 2 } }
    }
}
/// The grey linen texture, drawn rather than copied.
struct Linen: View {
    var body: some View {
        Canvas { g, size in
            g.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color(white: 0.24)))
            var rng = SeededRNG(seed: 42)
            for y in stride(from: 0.0, to: size.height, by: 2) {
                g.fill(Path(CGRect(x: 0, y: y, width: size.width, height: 1)), with: .color(.white.opacity(Double.random(in: 0.01...0.06, using: &rng))))
            }
            for x in stride(from: 0.0, to: size.width, by: 2) {
                g.fill(Path(CGRect(x: x, y: 0, width: 1, height: size.height)), with: .color(.black.opacity(Double.random(in: 0.02...0.08, using: &rng))))
            }
        }
    }
}

// MARK: The offline ghost: Apple's on-device model, works in airplane mode.
struct GhostDemo: View {
    @State private var reply = ""
    @State private var busy = false
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                Text("NO SIGNAL").font(.system(size: 40, weight: .black, design: .monospaced)).foregroundStyle(.white)
                Text("turn on airplane mode. something still answers. it runs on this phone, not on a server.").font(.system(size: 13, design: .monospaced)).foregroundStyle(.gray)
                Text(reply).font(.system(size: 17, design: .monospaced)).foregroundStyle(Color(red: 0.6, green: 0.85, blue: 1)).frame(minHeight: 120, alignment: .topLeading)
                Button { Task { await ask() } } label: {
                    Text(busy ? "..." : "IS ANYONE THERE").font(.system(size: 14, weight: .semibold, design: .monospaced)).frame(maxWidth: .infinity).padding(.vertical, 17).background(.white).foregroundStyle(.black)
                }.disabled(busy)
                Spacer().frame(height: 30)
            }.padding(.horizontal, 22)
        }
    }
    func ask() async {
        busy = true; reply = ""; Haptics.shared.ringOnce()
        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            guard case .available = SystemLanguageModel.default.availability else { reply = "the on-device model is not available. Apple Intelligence must be on."; busy = false; return }
            let s = LanguageModelSession(instructions: "You are a voice left behind inside a phone's old payphone network. The phone has no signal. Answer in two short lowercase sentences, quiet and strange, never cheerful. Do not claim to know anything about the person.")
            do {
                for try await partial in s.streamResponse(to: "someone with no signal asked: is anyone there?") { reply = partial.content }
            } catch { reply = "…" }
        }
        #endif
        busy = false
    }
}

// MARK: It notices the camera. Agrippa leaked because someone filmed it.
struct Watcher: ViewModifier {
    @State private var note: String? = nil
    func body(content: Content) -> some View {
        content
            .overlay {
                if let n = note {
                    Text(n).font(.system(size: 22, weight: .black, design: .monospaced)).foregroundStyle(.white).multilineTextAlignment(.center)
                        .padding(24).frame(maxWidth: .infinity, maxHeight: .infinity).background(.black.opacity(0.88)).transition(.opacity).allowsHitTesting(false)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in show("it saw that.\nthe last person who copied it\nhad to film the screen.") }
            .onReceive(NotificationCenter.default.publisher(for: UIScreen.capturedDidChangeNotification)) { _ in
                if UIScreen.main.isCaptured { show("you are recording.\nit knows.") }
            }
    }
    func show(_ s: String) {
        Haptics.shared.staticBurst(seconds: 0.5)
        withAnimation(.easeOut(duration: 0.15)) { note = s }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) { withAnimation { note = nil } }
    }
}


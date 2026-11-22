import SwiftUI
import CoreHaptics

/// The App Clip a payphone hands you: no install, it just rings.
@main
struct LINEClip: App {
    @State private var line = "310-637-8714"
    @State private var place = "2101 VIA ARADO, COMPTON"
    var body: some Scene {
        WindowGroup {
            ClipRing(line: line, place: place)
                .preferredColorScheme(.dark).statusBarHidden(true)
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { a in
                    // the sticker's URL says which payphone this is: .../clip?line=310-637-8714
                    if let u = a.webpageURL, let q = URLComponents(url: u, resolvingAgainstBaseURL: false)?.queryItems {
                        if let l = q.first(where: { $0.name == "line" })?.value { line = l }
                        if let p = q.first(where: { $0.name == "at" })?.value { place = p.uppercased() }
                    }
                }
        }
    }
}

struct ClipRing: View {
    let line: String; let place: String
    @State private var answered = false
    @State private var shake = false
    @State private var engine: CHHapticEngine? = nil
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 14) {
                Spacer()
                Text(answered ? "CONNECTED" : "THIS PHONE\nIS RINGING").font(.system(size: 38, weight: .black, design: .monospaced)).foregroundStyle(.white)
                    .offset(x: shake && !answered ? 3 : 0)
                Text("LINE " + line).font(.system(size: 20, weight: .semibold, design: .monospaced)).foregroundStyle(.white)
                Text(place).font(.system(size: 13, design: .monospaced)).foregroundStyle(.gray)
                if answered {
                    Text("you touched the phone, so it found you.\nget LINE to hear the rest.").font(.system(size: 14, design: .monospaced)).foregroundStyle(Color(red: 0.6, green: 0.85, blue: 1))
                }
                Spacer()
                if !answered {
                    Button { answered = true; buzz(answer: true) } label: {
                        Text("PICK UP").font(.system(size: 16, weight: .semibold, design: .monospaced)).tracking(5).frame(maxWidth: .infinity).padding(.vertical, 18).background(.white).foregroundStyle(.black)
                    }
                }
                Spacer().frame(height: 30)
            }.padding(.horizontal, 22)
        }
        .onAppear {
            engine = try? CHHapticEngine(); try? engine?.start(); buzz(answer: false)
            withAnimation(.easeInOut(duration: 0.05).repeatForever()) { shake = true }
        }
    }
    func buzz(answer: Bool) {
        try? engine?.start()
        var ev: [CHHapticEvent] = []
        let rings = answer ? 1 : 3
        for r in 0..<rings { for k in 0..<(answer ? 3 : 24) {
            ev.append(CHHapticEvent(eventType: .hapticTransient, parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 1), CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)], relativeTime: Double(r) * 1.6 + Double(k) * 0.04))
        } }
        if let p = try? CHHapticPattern(events: ev, parameters: []), let pl = try? engine?.makePlayer(with: p) { try? pl.start(atTime: 0) }
    }
}

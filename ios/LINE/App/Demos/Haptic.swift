import SwiftUI

struct HapticDemo: View {
    @State private var pick = 0
    @State private var flash = 0.0
    var body: some View {
        DemoShell(title: "HAPTICS", styles: ["morse", "heartbeat", "phone bell", "static"], pick: $pick) {
            ZStack {
                Color.white.opacity(flash).allowsHitTesting(false)
                VStack(spacing: 14) {
                    Spacer()
                    Text(["J A C K   I N", "it is getting closer", "the old bell", "under your thumb"][pick])
                        .font(.system(size: 15, design: .monospaced)).foregroundStyle(.gray)
                    Button(action: play) {
                        Circle().stroke(.white, lineWidth: 2).frame(width: 150, height: 150)
                            .overlay(Text("PRESS").font(.system(size: 15, weight: .bold, design: .monospaced)).foregroundStyle(.white))
                    }
                    Spacer()
                    Text("ring/silent switch and Low Power Mode can mute the Taptic Engine.").font(.system(size: 10, design: .monospaced)).foregroundStyle(.gray.opacity(0.6))
                }.frame(maxWidth: .infinity)
            }
        }
    }
    func play() {
        switch pick {
        case 0:
            for m in Haptics.shared.play("JACK IN") {   // a soft pulse, not a strobe
                DispatchQueue.main.asyncAfter(deadline: .now() + m.start) { withAnimation(.easeOut(duration: 0.05)) { flash = 0.18 } }
                DispatchQueue.main.asyncAfter(deadline: .now() + m.start + m.length) { withAnimation(.easeIn(duration: 0.12)) { flash = 0 } }
            }
        case 1: Haptics.shared.heartbeat()
        case 2: Haptics.shared.phoneRing()
        default: Haptics.shared.staticBurst(seconds: 2.5)
        }
    }
}

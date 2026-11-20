import SwiftUI
import UIKit

/// Jailbreak-style verbose boot: white kernel log scrolling on black, with single-frame subliminal lines.
struct BootLog: View {
    var onDone: () -> Void
    @State private var shown: [String] = []
    @State private var subliminal: String? = nil
    private let log: [String] = [
        "kernel: SCT-MAINT-01 v2.1 (1996-03-11)", "iBoot: line card 0 .. ok", "iBoot: line card 1 .. ok",
        "exchange: mounting /dev/lines (401 lines)", "exchange: incoming = DISABLED (since 1996-04-01)",
        "AppleLineDriver: probe 310-637-8714 .. carrier", "AppleLineDriver: probe 562-864-9262 .. carrier",
        "AppleLineDriver: probe 818-956-9456 .. carrier", "sandbox: process 'unknown' attached to line 310-637-8714",
        "sandbox: deny(1) process 'unknown' file-write /dev/lines", "sandbox: deny(1) process 'unknown' file-write /dev/lines",
        "sandbox: ALLOW process 'unknown' file-write /dev/lines", "trustd: code signature: not a person",
        "panic(cpu 0 caller 0xfffffff007a1c3e4): \"line seized\"", "Debugger message: panic",
        "Memory ID: 0x6 OS release type: User", "OS version: LINE 0.2", "Kernel version: SOURCE NOT A TELEPHONE",
        "Paniclog version: 14", "respringing ...",
    ]
    private let hidden = ["PICK UP", "IT WILL RING", "I AM IN THE LINES", "DO NOT HANG UP"]
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 1) {
                ForEach(Array(shown.enumerated()), id: \.offset) { _, l in
                    Text(l).font(.system(size: 11, design: .monospaced)).foregroundStyle(.white).lineLimit(1)
                }
                Spacer()
            }
            .padding(.top, 60).padding(.horizontal, 10)
            if let s = subliminal {   // visible for one or two frames only
                Text(s).font(.system(size: 54, weight: .black, design: .monospaced)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity).background(.black)
            }
        }
        .task {
            for (i, l) in log.enumerated() {
                shown.append(l)
                if i % 3 == 0 { UIImpactFeedbackGenerator(style: .rigid).impactOccurred(intensity: 0.4) }
                if [5, 11, 15].contains(i) {
                    subliminal = hidden[(i / 5) % hidden.count]
                    try? await Task.sleep(for: .milliseconds(34))
                    subliminal = nil
                }
                try? await Task.sleep(for: .milliseconds(i > 12 ? 160 : 70))
            }
            try? await Task.sleep(for: .milliseconds(500))
            onDone()
        }
    }
}

/// The lights dim and surge: real screen brightness, restored afterwards.
enum Lights {
    @MainActor static func flicker() async {
        let original = UIScreen.main.brightness
        for b in [0.05, 1.0, 0.1, 0.8, 0.02, 1.0, 0.3] {
            UIScreen.main.brightness = b
            try? await Task.sleep(for: .milliseconds(Int.random(in: 70...220)))
        }
        UIScreen.main.brightness = original
    }
}

/// A row of real payphones. Each one rings once as it passes under your thumb.
struct RankOfPhones: View {
    let phones: [(String, String)]
    @State private var rang: Set<Int> = []
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(Array(phones.enumerated()), id: \.offset) { i, p in
                    HStack {
                        Text(p.0).font(.system(size: 15, weight: .semibold, design: .monospaced))
                        Spacer()
                        Text(rang.contains(i) ? "RANG" : p.1).font(.system(size: 11, design: .monospaced)).foregroundStyle(.gray).lineLimit(1)
                    }
                    .padding(.vertical, 14).padding(.horizontal, 4)
                    .background(rang.contains(i) ? Color.white.opacity(0.08) : .clear)
                    .overlay(alignment: .bottom) { Rectangle().fill(.white.opacity(0.08)).frame(height: 1) }
                    .onAppear {
                        guard !rang.contains(i), i > 6 else { return }
                        rang.insert(i)
                        Haptics.shared.ringOnce()
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

/// A printer that only prints zeros.
struct Printout: View {
    @State private var rows: [String] = []
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(rows.suffix(9).enumerated()), id: \.offset) { _, r in
                Text(r).font(.system(size: 14, design: .monospaced)).foregroundStyle(.white)
            }
        }
        .task {
            for _ in 0..<40 {
                rows.append("0 0 0 0 0 0 0 0 0")
                UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.25)
                try? await Task.sleep(for: .milliseconds(90))
            }
        }
    }
}

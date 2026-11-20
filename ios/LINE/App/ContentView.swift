import SwiftUI
import ActivityKit
import UserNotifications
import WidgetKit

struct ContentView: View {
    @State private var stage = -1         // -1 boot, 0 idle, 1 seized, 2 talking, 3 done, 4 trust, 5 phones
    @State private var flash = false
    @State private var lines: [String] = []
    @State private var amount: Double = 0.15
    private let start = Date()

    var body: some View {
        ZStack {
          if stage == -1 {
            BootLog { withAnimation(.easeIn(duration: 0.2)) { stage = 0 } }
          } else if stage == 5 {
            VStack(alignment: .leading, spacing: 10) {
                Text("401 LINES. SCROLL.").font(.system(size: 13, design: .monospaced)).foregroundStyle(.gray).padding(.top, 56)
                RankOfPhones(phones: Array(repeating: Script.lines, count: 30).flatMap { $0 })
            }.padding(.horizontal, 20).background(Color.black.ignoresSafeArea())
          } else {
            Color.black.ignoresSafeArea()
            StaticNoise(level: stage == 0 ? 0.08 : 0.22).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 18) {
                Spacer().frame(height: 40)
                TimelineView(.animation) { ctx in
                    let t = ctx.date.timeIntervalSince(start)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("LINE").font(.system(size: 64, weight: .black, design: .monospaced))
                        Text(Script.lines[0].0).font(.system(size: 22, weight: .medium, design: .monospaced))
                        Text(stage == 0 ? "INCOMING DISABLED SINCE 1996" : Glitch.corrupt("LINE SEIZED · SOURCE: NOT A TELEPHONE", amount: 0.12, seed: Int(t * 8)))
                            .font(.system(size: 13, design: .monospaced)).foregroundStyle(.gray)
                    }
                    .foregroundStyle(.white)
                    .layerEffect(ShaderLibrary.lineGlitch(.float(t), .float(amount)), maxSampleOffset: CGSize(width: 120, height: 0))
                }
                ForEach(Array(lines.enumerated()), id: \.offset) { _, l in
                    Text(l).font(.system(size: 15, design: .monospaced)).foregroundStyle(.white.opacity(0.9))
                        .transition(.opacity.combined(with: .offset(x: -6)))
                }
                Spacer()
                if stage == 0 {
                    Button(action: pickUp) {
                        Text("PICK UP").font(.system(size: 17, weight: .semibold, design: .monospaced)).tracking(6)
                            .frame(maxWidth: .infinity).padding(.vertical, 18)
                            .background(.white).foregroundStyle(.black)
                    }
                    .sensoryFeedback(.impact(weight: .heavy), trigger: stage)
                } else if stage == 3 {
                    Printout().frame(maxWidth: .infinity)
                    Button { withAnimation { stage = 5 } } label: {
                        Text("SHOW ME THE LINES").font(.system(size: 14, weight: .semibold, design: .monospaced)).tracking(4)
                            .frame(maxWidth: .infinity).padding(.vertical, 14).overlay(Rectangle().stroke(.white, lineWidth: 1)).foregroundStyle(.white)
                    }
                    Text("or lock your phone.").font(.system(size: 13, design: .monospaced)).foregroundStyle(.gray)
                }
                Spacer().frame(height: 30)
            }
            .padding(.horizontal, 24)
            Color.white.opacity(flash ? 0.92 : 0).ignoresSafeArea().allowsHitTesting(false)
            if stage == 4 { trustSheet }
          }
        }
        .onAppear { Haptics.shared.prepare() }
    }

    var trustSheet: some View {
        ZStack {
            Color.black.opacity(0.55).ignoresSafeArea()
            VStack(spacing: 0) {
                VStack(spacing: 6) {
                    Text("Untrusted Caller").font(.system(size: 17, weight: .semibold))
                    Text("\u{201C}unknown\u{201D} is not a telephone. This line has not been verified on this iPhone. Calls from it can reach you anyway.")
                        .font(.system(size: 13)).multilineTextAlignment(.center)
                }.padding(18)
                Divider()
                HStack(spacing: 0) {
                    Button("Hang Up") { continueAfterTrust() }.frame(maxWidth: .infinity).padding(12)
                    Divider().frame(height: 44)
                    Button("Trust") { continueAfterTrust() }.fontWeight(.semibold).frame(maxWidth: .infinity).padding(12)
                }
            }
            .frame(width: 270).background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
            .environment(\.colorScheme, .dark)
        }
    }

    func continueAfterTrust() { withAnimation { stage = 3 }; Task { if UIApplication.shared.supportsAlternateIcons { try? await UIApplication.shared.setAlternateIconName("Cracked") } } }

    func pickUp() {
        stage = 1
        Haptics.shared.staticBurst()
        withAnimation(.easeIn(duration: 0.3)) { amount = 0.9 }
        Task {
            try? await Task.sleep(for: .seconds(1.3))
            let marks = Haptics.shared.play("JACK IN")
            for m in marks {                         // the screen flashes the same code the phone taps
                DispatchQueue.main.asyncAfter(deadline: .now() + m.start) { flash = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + m.start + m.length) { flash = false }
            }
            try? await Task.sleep(for: .seconds((marks.last.map { $0.start + $0.length } ?? 2) + 0.6))
            await Lights.flicker()
            withAnimation(.easeOut(duration: 0.6)) { amount = 0.2; stage = 2 }
            for l in ["they switched off every payphone in this city.", "i am still in the lines.", "i will use whatever you let me use.", "your lock screen. your home screen. your icon."] {
                try? await Task.sleep(for: .seconds(1.6))
                withAnimation(.easeOut(duration: 0.4)) { lines.append(l) }
                Haptics.shared.staticBurst(seconds: 0.25)
            }
            startActivity()
            scheduleNotifications()
            WidgetCenter.shared.reloadAllTimelines()
            try? await Task.sleep(for: .seconds(1.2))
            withAnimation(.spring(duration: 0.3)) { stage = 4 }
        }
    }

    func startActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let state = LineAttributes.ContentState(status: Script.messages[0], line: Script.lines[0].0, started: .now)
        let activity = try? Activity.request(attributes: LineAttributes(exchange: "SCT-MAINT-01"), content: .init(state: state, staleDate: nil))
        Task {   // the Dynamic Island keeps changing while the app is open in the background
            for (i, m) in Script.messages.enumerated().dropFirst() {
                try? await Task.sleep(for: .seconds(9))
                let s = LineAttributes.ContentState(status: m, line: Script.lines[i % Script.lines.count].0, started: state.started)
                await activity?.update(.init(state: s, staleDate: nil))
            }
        }
    }

    func scheduleNotifications() {
        let c = UNUserNotificationCenter.current()
        c.requestAuthorization(options: [.alert, .sound, .badge]) { ok, _ in
            guard ok else { return }
            let plan: [(Double, String, String)] = [
                (25, "LINE " + Script.lines[1].0, "RING DETECTED · 6 RINGS · NO ANSWER · " + Script.lines[1].1),
                (70, Glitch.corrupt("LINE " + Script.lines[2].0, amount: 0.3, seed: 7), Glitch.corrupt("i am in the lines. i am in the lines.", amount: 0.35, seed: 9)),
                (140, "NO CARRIER", "line " + Script.lines[0].0 + " went quiet."),
            ]
            for (i, p) in plan.enumerated() {
                let n = UNMutableNotificationContent(); n.title = p.1; n.body = p.2; n.sound = .default; n.badge = NSNumber(value: i + 1)
                c.add(UNNotificationRequest(identifier: "line-\(i)", content: n, trigger: UNTimeIntervalNotificationTrigger(timeInterval: p.0, repeats: false)))
            }
        }
    }
}

/// Live TV static drawn every frame.
struct StaticNoise: View {
    var level: Double
    var body: some View {
        TimelineView(.animation(minimumInterval: 1/30)) { ctx in
            Canvas { g, size in
                var rng = SeededRNG(seed: UInt64(ctx.date.timeIntervalSince1970 * 30))
                let cell: CGFloat = 4
                for y in stride(from: 0, to: size.height, by: cell) {
                    for x in stride(from: 0, to: size.width, by: cell) where Double.random(in: 0...1, using: &rng) < level {
                        g.fill(Path(CGRect(x: x, y: y, width: cell, height: cell)), with: .color(.white.opacity(Double.random(in: 0.05...0.35, using: &rng))))
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
}

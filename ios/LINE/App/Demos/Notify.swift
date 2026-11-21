import SwiftUI
import UserNotifications

struct NotifyDemo: View {
    @State private var pick = 0
    @State private var show = false
    var body: some View {
        DemoShell(title: "NOTIFY", styles: ["real lock screen", "iOS 4 banner", "iOS 6 alert", "kernel failure"], pick: $pick) {
            ZStack(alignment: .top) {
                VStack { Spacer()
                    Button(action: fire) {
                        Text(pick == 0 ? "SEND IN 5 SECONDS. LOCK YOUR PHONE." : "TRIGGER").font(.system(size: 14, weight: .semibold, design: .monospaced))
                            .frame(maxWidth: .infinity).padding(.vertical, 16).background(.white).foregroundStyle(.black)
                    }
                }
                if show && pick == 1 { Banner4().transition(.move(edge: .top)) }
                if show && pick == 2 { Alert6 { withAnimation { show = false } }.transition(.scale(scale: 1.15).combined(with: .opacity)) }
                if show && pick == 3 { KernelFailure { withAnimation { show = false } } }
            }
        }
        .onChange(of: pick) { show = false }
    }
    func fire() {
        Haptics.shared.ringOnce()
        if pick == 0 {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { ok, _ in
                guard ok else { return }
                let c = UNMutableNotificationContent()
                c.title = Glitch.corrupt("LINE 310-637-8714", amount: 0.25, seed: Int.random(in: 0...999))
                c.subtitle = "SOURCE: NOT A TELEPHONE"
                c.body = Glitch.corrupt("do not hang up. do not hang up. do not hang up.", amount: 0.3, seed: 4)
                c.sound = .defaultCritical; c.badge = 1; c.interruptionLevel = .active
                UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: UUID().uuidString, content: c, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)))
            }
        } else {
            withAnimation(.spring(duration: 0.35)) { show = true }
            if pick == 1 { DispatchQueue.main.asyncAfter(deadline: .now() + 4) { withAnimation { show = false } } }
        }
    }
}

/// The 2010 push banner: a black glass strip across the top.
struct Banner4: View {
    var body: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 5).fill(LinearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom)).frame(width: 26, height: 26)
                .overlay(Text("L").font(.system(size: 14, weight: .black)).foregroundStyle(.white))
            VStack(alignment: .leading, spacing: 1) {
                Text("LINE").font(.system(size: 15, weight: .bold, design: .default)).foregroundStyle(.white)
                Text("310-637-8714: you have 1 missed call from nobody").font(.system(size: 14)).foregroundStyle(.white).lineLimit(1)
            }
            Spacer()
        }
        .padding(.horizontal, 10).padding(.vertical, 8)
        .background(LinearGradient(colors: [Color(white: 0.28).opacity(0.95), Color(white: 0.02).opacity(0.95)], startPoint: .top, endPoint: .bottom))
        .overlay(Rectangle().fill(.white.opacity(0.25)).frame(height: 1), alignment: .top)
    }
}

/// The 2012 alert: glossy blue glass, embossed white type, two glass buttons.
struct Alert6: View {
    var dismiss: () -> Void
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 10) {
                Text("Cannot Hang Up").font(.system(size: 17, weight: .bold)).shadow(color: .black.opacity(0.6), radius: 0, y: -1)
                Text("The line 310-637-8714 is being used by another process.").font(.system(size: 15)).multilineTextAlignment(.center).shadow(color: .black.opacity(0.6), radius: 0, y: -1)
                HStack(spacing: 8) {
                    ForEach(["Wait", "Answer"], id: \.self) { b in
                        Button(b) { Haptics.shared.ringOnce(); dismiss() }
                            .font(.system(size: 16, weight: b == "Answer" ? .bold : .regular)).foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 42)
                            .background(LinearGradient(colors: [Color.white.opacity(0.45), Color.white.opacity(0.12)], startPoint: .top, endPoint: .bottom))
                            .clipShape(RoundedRectangle(cornerRadius: 7))
                            .overlay(RoundedRectangle(cornerRadius: 7).stroke(.black.opacity(0.4), lineWidth: 1))
                    }
                }.padding(.top, 6)
            }
            .foregroundStyle(.white).padding(16).frame(width: 284)
            .background(LinearGradient(colors: [Color(red: 0.32, green: 0.42, blue: 0.62), Color(red: 0.08, green: 0.16, blue: 0.36)], startPoint: .top, endPoint: .bottom).opacity(0.94))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.85), lineWidth: 2))
            .shadow(color: .black.opacity(0.7), radius: 14)
        }
    }
}

/// A full-screen failure that looks like it came from underneath the app.
struct KernelFailure: View {
    var dismiss: () -> Void
    @State private var lines: [String] = []
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 2) {
                ForEach(Array(lines.enumerated()), id: \.offset) { _, l in Text(l).font(.system(size: 11, design: .monospaced)).foregroundStyle(.white) }
                Spacer()
                Text("tap to continue").font(.system(size: 11, design: .monospaced)).foregroundStyle(.gray)
            }.padding(.top, 60).padding(.horizontal, 14)
        }
        .contentShape(Rectangle()).onTapGesture { dismiss() }
        .task {
            Haptics.shared.staticBurst(seconds: 0.6)
            for l in ["panic(cpu 1 caller 0xfffffff0271a9c44): line seized", "process: unknown (not a person)", "last unloaded: com.apple.driver.AppleLine",
                      "backtrace:", "  0x41 0x52 0x45 0x20 0x59 0x4f 0x55", "  0x20 0x53 0x54 0x49 0x4c 0x4c", "  0x20 0x54 0x48 0x45 0x52 0x45 0x3f",
                      "rebooting in 5 ... 4 ... 3"] {
                lines.append(l); try? await Task.sleep(for: .milliseconds(160))
            }
        }
    }
}

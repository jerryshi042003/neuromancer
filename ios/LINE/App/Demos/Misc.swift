import SwiftUI
import ActivityKit
import CoreLocation
import UIKit

// MARK: Dynamic Island, three styles
struct LiveDemo: View {
    @State private var pick = 0
    @State private var status = "lock your phone or swipe home to see it"
    var body: some View {
        DemoShell(title: "ISLAND", styles: ["call", "uploading you", "redacted"], pick: $pick) {
            VStack(spacing: 14) {
                Spacer()
                Text(status).font(.system(size: 13, design: .monospaced)).foregroundStyle(.gray).multilineTextAlignment(.center)
                Button(action: start) { Text("START").font(.system(size: 14, weight: .semibold, design: .monospaced)).frame(maxWidth: .infinity).padding(.vertical, 16).background(.white).foregroundStyle(.black) }
                Button { Task { for a in Activity<LineAttributes>.activities { await a.end(nil, dismissalPolicy: .immediate) }; status = "ended" } } label: {
                    Text("END ALL").font(.system(size: 12, design: .monospaced)).foregroundStyle(.gray)
                }
            }
        }
    }
    func start() {
        Haptics.shared.ringOnce()
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { status = "Live Activities are off for LINE in Settings"; return }
        let st = LineAttributes.ContentState(status: ["CONNECTED", "UPLOADING YOU", "██████ ███ ████"][pick], line: Script.lines[0].0, started: .now, progress: 0)
        let a = try? Activity.request(attributes: LineAttributes(exchange: "SCT-MAINT-01", style: pick), content: .init(state: st, staleDate: nil))
        status = "running. swipe home now."
        Task {
            for k in 1...12 {
                try? await Task.sleep(for: .seconds(4))
                let msg = pick == 1 ? ["FACE", "VOICE", "HESITATION", "HANDWRITING", "SLEEP", "YOU"][k % 6] : Script.messages[k % Script.messages.count]
                let s = LineAttributes.ContentState(status: msg, line: Script.lines[k % Script.lines.count].0, started: st.started, progress: min(0.99, Double(k) / 12.0 + Double.random(in: -0.04...0.02)))
                await a?.update(.init(state: s, staleDate: nil), alertConfiguration: k == 6 ? AlertConfiguration(title: "LINE", body: "still uploading", sound: .default) : nil)
            }
        }
    }
}

// MARK: App icon, three versions. iOS itself announces each change.
struct IconDemo: View {
    @State private var pick = 0
    var body: some View {
        DemoShell(title: "ICON", styles: ["clean", "cracked", "static"], pick: $pick) {
            VStack(spacing: 18) {
                Spacer()
                Text("iOS shows its own alert when the app changes its icon. go home after to see it.").font(.system(size: 13, design: .monospaced)).foregroundStyle(.gray).multilineTextAlignment(.center)
                Button {
                    Haptics.shared.crack()
                    Task { try? await UIApplication.shared.setAlternateIconName([nil, "Cracked", "Static"][pick]) }
                } label: { Text("CHANGE ICON").font(.system(size: 14, weight: .semibold, design: .monospaced)).frame(maxWidth: .infinity).padding(.vertical, 16).background(.white).foregroundStyle(.black) }
            }
        }
    }
}

// MARK: Read once, for real. The server remembers this device.
struct LockDemo: View {
    @State private var state = "idle"
    @State private var at: Date? = nil
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                switch state {
                case "first":
                    Text("this message opens once.").font(.system(size: 24, weight: .bold, design: .monospaced)).foregroundStyle(.white)
                    Text("the line remembers this phone now. close this and come back: it will not open again. reinstalling won't help for a day.").font(.system(size: 14, design: .monospaced)).foregroundStyle(.gray)
                case "again":
                    Text("NO CARRIER").font(.system(size: 44, weight: .black, design: .monospaced)).foregroundStyle(.white)
                    Text("this phone already opened it" + (at.map { " at " + $0.formatted(date: .omitted, time: .standard) } ?? "") + ".").font(.system(size: 14, design: .monospaced)).foregroundStyle(.gray)
                default:
                    Text("READ ONCE").font(.system(size: 44, weight: .black, design: .monospaced)).foregroundStyle(.white)
                    Button(action: open) { Text("OPEN").font(.system(size: 15, weight: .semibold, design: .monospaced)).frame(maxWidth: .infinity).padding(.vertical, 17).background(.white).foregroundStyle(.black) }
                }
                Spacer().frame(height: 40)
            }.padding(.horizontal, 22)
        }
    }
    func open() {
        var r = URLRequest(url: URL(string: "https://neuromancer-read.jerryshi.workers.dev/lock/open")!); r.httpMethod = "POST"
        r.httpBody = try? JSONSerialization.data(withJSONObject: ["device": UIDevice.current.identifierForVendor?.uuidString ?? "unknown"])
        Task {
            guard let (d, _) = try? await URLSession.shared.data(for: r), let j = try? JSONSerialization.jsonObject(with: d) as? [String: Any] else { state = "again"; return }
            at = (j["at"] as? Double).map { Date(timeIntervalSince1970: $0 / 1000) }
            withAnimation { state = (j["first"] as? Bool) == true ? "first" : "again" }
            if state == "first" { Haptics.shared.heartbeat(beats: 4) } else { Haptics.shared.staticBurst(seconds: 0.8) }
        }
    }
}

// MARK: Nearest real payphone, with a needle that points at it.
final class Finder: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var here: CLLocation?
    @Published var heading: Double = 0
    let m = CLLocationManager()
    lazy var phones: [(String, String, CLLocation)] = {
        guard let u = Bundle.main.url(forResource: "payphones", withExtension: "json"), let d = try? Data(contentsOf: u),
              let a = try? JSONSerialization.jsonObject(with: d) as? [[Any]] else { return [] }
        return a.compactMap { r in
            guard let n = r[0] as? String, let addr = r[1] as? String, let lon = r[3] as? Double, let lat = r[4] as? Double else { return nil }
            return (n, addr, CLLocation(latitude: lat, longitude: lon))
        }
    }()
    func start() { m.delegate = self; m.requestWhenInUseAuthorization(); m.startUpdatingLocation(); m.startUpdatingHeading() }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations l: [CLLocation]) { here = l.last }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading h: CLHeading) { heading = h.trueHeading >= 0 ? h.trueHeading : h.magneticHeading }
}
struct NearDemo: View {
    @StateObject private var f = Finder()
    @State private var lastTick = Date()
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 18) {
                Spacer()
                if let here = f.here, let n = f.phones.min(by: { $0.2.distance(from: here) < $1.2.distance(from: here) }) {
                    let dist = n.2.distance(from: here), bearing = bearingTo(here.coordinate, n.2.coordinate), rel = bearing - f.heading
                    Image(systemName: "arrow.up").font(.system(size: 120, weight: .ultraLight)).foregroundStyle(.white).rotationEffect(.degrees(rel)).animation(.easeOut(duration: 0.2), value: rel)
                    Text(String(format: "%.1f mi", dist / 1609.34)).font(.system(size: 40, weight: .black, design: .monospaced)).foregroundStyle(.white)
                    Text(n.0).font(.system(size: 18, design: .monospaced)).foregroundStyle(.white)
                    Text(n.1.uppercased()).font(.system(size: 12, design: .monospaced)).foregroundStyle(.gray)
                    Text("the nearest of \(f.phones.count) real payphones in LA County").font(.system(size: 11, design: .monospaced)).foregroundStyle(.gray.opacity(0.7))
                        .onChange(of: Int(abs(rel.truncatingRemainder(dividingBy: 360)))) { _, v in
                            if (v < 8 || v > 352) && Date().timeIntervalSince(lastTick) > 1.5 { Haptics.shared.ringOnce(); lastTick = Date() }
                        }
                } else {
                    Text("finding you").font(.system(size: 14, design: .monospaced)).foregroundStyle(.gray)
                }
                Spacer()
            }.padding(.horizontal, 22)
        }
        .onAppear { f.start() }
    }
    func bearingTo(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> Double {
        let la1 = a.latitude * .pi / 180, la2 = b.latitude * .pi / 180, dl = (b.longitude - a.longitude) * .pi / 180
        return atan2(sin(dl) * cos(la2), cos(la1) * sin(la2) - sin(la1) * cos(la2) * cos(dl)) * 180 / .pi
    }
}

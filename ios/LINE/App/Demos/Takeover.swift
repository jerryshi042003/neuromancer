import SwiftUI

struct TakeoverDemo: View {
    @State private var pick = 0
    @State private var run = 0
    var body: some View {
        DemoShell(title: "TAKEOVER", styles: ["screen melt", "crt off", "cracks"], pick: $pick) {
            ZStack {
                switch pick {
                case 0: MeltView(run: run)
                case 1: CRTOff(run: run)
                default: Cracks()
                }
                if pick != 2 {
                    VStack { Spacer()
                        Button { run += 1 } label: { Text("RUN").font(.system(size: 14, weight: .semibold, design: .monospaced)).frame(maxWidth: .infinity).padding(.vertical, 16).background(.white).foregroundStyle(.black) }
                    }
                }
            }
        }
    }
}

/// A fake home screen that drips away column by column.
struct MeltView: View {
    let run: Int
    @State private var start = Date.distantFuture
    var body: some View {
        TimelineView(.animation) { ctx in
            let t = max(0, ctx.date.timeIntervalSince(start))
            Canvas { g, size in
                let cols = 48, w = size.width / CGFloat(cols)
                for c in 0..<cols {
                    var rng = SeededRNG(seed: UInt64(c * 7919))
                    let speed = Double.random(in: 0.6...1.6, using: &rng)
                    let drop = CGFloat(max(0, t - Double.random(in: 0...0.4, using: &rng)) * speed * t * 420)
                    g.drawLayer { l in
                        l.clip(to: Path(CGRect(x: CGFloat(c) * w, y: 0, width: w + 0.5, height: size.height)))
                        l.translateBy(x: 0, y: drop)
                        drawFakeHome(&l, size: size)
                    }
                }
            }
        }
        .onChange(of: run) { start = Date(); Haptics.shared.staticBurst(seconds: 1.5) }
        .onAppear { start = .distantFuture }
    }
    func drawFakeHome(_ g: inout GraphicsContext, size: CGSize) {
        g.fill(Path(CGRect(origin: .zero, size: size)), with: .linearGradient(Gradient(colors: [Color(red: 0.1, green: 0.12, blue: 0.3), Color(red: 0.35, green: 0.1, blue: 0.3)]), startPoint: .zero, endPoint: CGPoint(x: 0, y: size.height)))
        let names = ["Phone", "Messages", "Mail", "Safari", "Photos", "Camera", "Maps", "LINE", "Clock", "Notes", "Wallet", "Settings"]
        for (i, n) in names.enumerated() {
            let x = 24 + CGFloat(i % 4) * (size.width - 48) / 4, y = 40 + CGFloat(i / 4) * 100
            g.fill(Path(roundedRect: CGRect(x: x, y: y, width: 58, height: 58), cornerRadius: 14), with: .color(n == "LINE" ? .black : Color(hue: Double(i) / 12, saturation: 0.5, brightness: 0.85)))
            g.draw(Text(n).font(.system(size: 10)).foregroundStyle(.white), at: CGPoint(x: x + 29, y: y + 70))
        }
    }
}

/// The old television switch-off: the picture squeezes to a line, then a dot.
struct CRTOff: View {
    let run: Int
    @State private var sy: CGFloat = 1
    @State private var sx: CGFloat = 1
    @State private var glow: Double = 0
    var body: some View {
        ZStack {
            Color.black
            StaticNoise(level: 0.5).scaleEffect(x: sx, y: sy).brightness(glow)
        }
        .clipped()
        .onChange(of: run) {
            sx = 1; sy = 1; glow = 0
            Haptics.shared.crack()
            withAnimation(.easeIn(duration: 0.18)) { sy = 0.004; glow = 0.6 }
            withAnimation(.easeIn(duration: 0.22).delay(0.2)) { sx = 0.003 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) { withAnimation(.easeOut(duration: 0.3)) { sx = 1; sy = 1; glow = 0 } }
        }
    }
}

/// Tap anywhere: the glass cracks from that point, with a crack you can feel.
struct Cracks: View {
    @State private var cracks: [[CGPoint]] = []
    var body: some View {
        ZStack {
            Color(white: 0.06)
            Text("TAP THE GLASS").font(.system(size: 13, design: .monospaced)).foregroundStyle(.gray)
            Canvas { g, _ in
                for c in cracks {
                    var p = Path(); p.move(to: c[0]); for q in c.dropFirst() { p.addLine(to: q) }
                    g.stroke(p, with: .color(.white.opacity(0.85)), lineWidth: 1.1)
                }
            }
        }
        .contentShape(Rectangle())
        .gesture(SpatialTapGesture().onEnded { e in
            Haptics.shared.crack()
            for k in 0..<7 {
                var pts = [e.location], a = Double(k) / 7 * .pi * 2 + Double.random(in: -0.3...0.3)
                for _ in 0..<Int.random(in: 4...9) {
                    a += Double.random(in: -0.5...0.5)
                    let l = CGFloat.random(in: 18...60)
                    pts.append(CGPoint(x: pts.last!.x + cos(a) * l, y: pts.last!.y + sin(a) * l))
                }
                cracks.append(pts)
            }
        })
    }
}

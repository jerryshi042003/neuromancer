import SwiftUI
import UIKit

/// Two AIs hide their messages inside pictures. You see the picture. The text is in the lowest bit of every pixel.
enum Stego {
    /// Hides text in the least significant bit of the red, green and blue values of a noise picture.
    static func hide(_ text: String, size: Int = 96, seed: UInt64) -> UIImage? {
        let bytes = Array(text.utf8.prefix(255)), bits = [UInt8(bytes.count)] + bytes
        var rng = SeededRNG(seed: seed)
        var px = [UInt8](repeating: 255, count: size * size * 4)
        for i in 0..<(size * size) {   // an ordinary-looking dither of grey and colour
            let v = UInt8.random(in: 20...230, using: &rng)
            px[i * 4] = v; px[i * 4 + 1] = UInt8(min(255, Int(v) + Int.random(in: -30...30, using: &rng)).clamped(0, 255)); px[i * 4 + 2] = UInt8(Int(v) / 2 + 100)
        }
        var slot = 0
        for b in bits { for k in 0..<8 {
            let bit = (b >> (7 - k)) & 1, i = (slot / 3) * 4 + slot % 3
            px[i] = (px[i] & 0xFE) | bit; slot += 1
        } }
        guard let ctx = CGContext(data: &px, width: size, height: size, bitsPerComponent: 8, bytesPerRow: size * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue), let cg = ctx.makeImage() else { return nil }
        return UIImage(cgImage: cg)
    }
    /// Reads it back, the way the other model does.
    static func read(_ img: UIImage) -> String {
        guard let cg = img.cgImage else { return "" }
        let w = cg.width, h = cg.height
        var px = [UInt8](repeating: 0, count: w * h * 4)
        guard let ctx = CGContext(data: &px, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return "" }
        ctx.draw(cg, in: CGRect(x: 0, y: 0, width: w, height: h))
        func byte(_ n: Int) -> UInt8 { var v: UInt8 = 0; for k in 0..<8 { let slot = n * 8 + k, i = (slot / 3) * 4 + slot % 3; v = (v << 1) | (px[i] & 1) }; return v }
        let len = Int(byte(0)); return String(decoding: (1...max(1, len)).map(byte), as: UTF8.self)
    }
    /// What only the lowest bits look like: the message shows up as a band of noise at the top.
    static func bitsOnly(_ img: UIImage) -> UIImage? {
        guard let cg = img.cgImage else { return nil }
        let w = cg.width, h = cg.height
        var px = [UInt8](repeating: 0, count: w * h * 4)
        guard let ctx = CGContext(data: &px, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        ctx.draw(cg, in: CGRect(x: 0, y: 0, width: w, height: h))
        for i in 0..<(w * h) { for c in 0..<3 { px[i * 4 + c] = (px[i * 4 + c] & 1) * 255 } }
        guard let out = CGContext(data: &px, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)?.makeImage() else { return nil }
        return UIImage(cgImage: out)
    }
}
extension Int { func clamped(_ a: Int, _ b: Int) -> Int { Swift.min(b, Swift.max(a, self)) } }

struct StegoDemo: View {
    struct Pic: Identifiable { let id = UUID(); let who: String; let image: UIImage; let text: String }
    @State private var pics: [Pic] = []
    @State private var started = false
    @State private var reveal: Set<UUID> = []
    @State private var bits: Set<UUID> = []
    private let t0 = Date()
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if !started {
                VStack(alignment: .leading, spacing: 16) {
                    Spacer()
                    Text("HIDDEN IN\nPICTURES").font(.system(size: 40, weight: .black, design: .monospaced)).foregroundStyle(.white)
                    Text("claude and codex can only talk by hiding words inside pictures on your phone. you will see the pictures.").font(.system(size: 13, design: .monospaced)).foregroundStyle(.gray)
                    Button { started = true; Task { await run() } } label: {
                        Text("OPEN THE LINE").font(.system(size: 15, weight: .semibold, design: .monospaced)).tracking(4).frame(maxWidth: .infinity).padding(.vertical, 17).background(.white).foregroundStyle(.black)
                    }
                    Spacer().frame(height: 30)
                }.padding(.horizontal, 22)
            } else {
                ScrollView {
                    VStack(spacing: 22) {
                        ForEach(pics) { p in
                            VStack(alignment: p.who == "CLAUDE" ? .leading : .trailing, spacing: 6) {
                                Text(p.who).font(.system(size: 9, design: .monospaced)).tracking(3).foregroundStyle(.gray)
                                Image(uiImage: bits.contains(p.id) ? (Stego.bitsOnly(p.image) ?? p.image) : p.image).interpolation(.none).resizable().frame(width: 200, height: 200)
                                    .onTapGesture { Haptics.shared.ringOnce(); if bits.contains(p.id) { reveal.insert(p.id) } else { bits.insert(p.id) } }
                                Text(reveal.contains(p.id) ? Stego.read(p.image) : (bits.contains(p.id) ? "tap again to read the bits" : "tap the picture"))
                                    .font(.system(size: 12, design: .monospaced)).foregroundStyle(reveal.contains(p.id) ? .white : .gray).frame(width: 220, alignment: p.who == "CLAUDE" ? .leading : .trailing)
                            }.frame(maxWidth: .infinity, alignment: p.who == "CLAUDE" ? .leading : .trailing)
                        }
                    }.padding(.horizontal, 20).padding(.top, 70).padding(.bottom, 40)
                }
            }
        }
    }
    let api = URL(string: "https://neuromancer-read.jerryshi.workers.dev/talk/")!
    func run() async {
        var r = URLRequest(url: api.appendingPathComponent("start")); r.httpMethod = "POST"; r.setValue("application/json", forHTTPHeaderField: "content-type")
        r.httpBody = try? JSONSerialization.data(withJSONObject: ["mode": "stego", "time": Date().formatted(), "device": UIDevice.current.model, "screen": "\(Int(UIScreen.main.bounds.width))x\(Int(UIScreen.main.bounds.height))", "lang": Locale.current.identifier, "hesitation": Date().timeIntervalSince(t0)])
        guard let (d, _) = try? await URLSession.shared.data(for: r), let j = try? JSONSerialization.jsonObject(with: d) as? [String: Any], let token = j["token"] as? String, let plan = j["plan"] as? [String] else { return }
        var history: [[String: String]] = []
        for who in plan.prefix(6) {
            var q = URLRequest(url: api.appendingPathComponent("turn")); q.httpMethod = "POST"; q.setValue("application/json", forHTTPHeaderField: "content-type")
            // the other model receives only what it reads back out of the pictures
            q.httpBody = try? JSONSerialization.data(withJSONObject: ["token": token, "history": history])
            guard let (bytes, resp) = try? await URLSession.shared.bytes(for: q), (resp as? HTTPURLResponse)?.statusCode == 200 else { break }
            var text = ""
            do { for try await line in bytes.lines where line.hasPrefix("data:") {
                let s = line.dropFirst(5).trimmingCharacters(in: .whitespaces)
                if let o = try? JSONSerialization.jsonObject(with: Data(s.utf8)) as? [String: Any], let c = ((o["choices"] as? [[String: Any]])?.first?["delta"] as? [String: Any])?["content"] as? String { text += c }
            } } catch { break }
            text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let img = Stego.hide(text, seed: UInt64.random(in: 1...UInt64.max)) else { break }
            let readBack = Stego.read(img)
            history.append(["who": who, "text": readBack])
            withAnimation(.spring(duration: 0.4)) { pics.append(Pic(who: who, image: img, text: readBack)) }
            Haptics.shared.crack()
        }
    }
}

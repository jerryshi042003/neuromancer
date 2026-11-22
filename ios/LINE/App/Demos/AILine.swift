import SwiftUI
import UIKit
import AVFoundation

/// Two real models from two companies, streamed live from our server.
/// "watch": Claude and Grok talk about you; when someone is watching they switch to a private glyph language you can hear.
/// "files": Claude and Codex can only talk by writing files into a folder on your phone.
struct AILineDemo: View {
    let mode: String
    @State private var name = ""
    @State private var started = false
    @State private var turns: [Turn] = []
    @State private var seen: [String] = []
    @State private var error: String? = nil
    @State private var openFile: Turn? = nil
    private let t0 = Date()
    struct Turn: Identifiable, Equatable { let id = UUID(); var who: String; var model: String; var text: String; var priv: Bool; var ts = Date(); var done = false }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if !started { intro } else if mode == "files" { wire } else { transcript }
        }
        .sheet(item: $openFile) { f in
            ScrollView { Text(fileBody(f.text)).font(.system(size: 14, design: .monospaced)).frame(maxWidth: .infinity, alignment: .leading).padding(20) }
                .presentationDetents([.medium]).preferredColorScheme(.dark)
        }
    }

    var intro: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
            Text(mode == "files" ? "FILES" : "WATCHING").font(.system(size: 44, weight: .black, design: .monospaced)).foregroundStyle(.white)
            Text(mode == "files" ? "claude and codex can only talk by leaving files on your phone. you can see the folder." :
                    "claude and grok are on the line. they can see a little about you. type your first name.")
                .font(.system(size: 14, design: .monospaced)).foregroundStyle(.gray)
            if mode == "watch" {
                TextField("", text: $name, prompt: Text("first name").foregroundStyle(.gray)).font(.system(size: 18, design: .monospaced)).foregroundStyle(.white)
                    .padding(.vertical, 10).overlay(alignment: .bottom) { Rectangle().fill(.gray).frame(height: 1) }.textInputAutocapitalization(.never)
            }
            if let e = error { Text(e).font(.system(size: 12, design: .monospaced)).foregroundStyle(.red) }
            Button { Task { await start() } } label: {
                Text("OPEN THE LINE").font(.system(size: 15, weight: .semibold, design: .monospaced)).tracking(4).frame(maxWidth: .infinity).padding(.vertical, 17).background(.white).foregroundStyle(.black)
            }
            Spacer().frame(height: 30)
        }.padding(.horizontal, 22)
    }

    var transcript: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) { ForEach(seen, id: \.self) { Text($0).font(.system(size: 11, design: .monospaced)).foregroundStyle(.gray) } }
                        .padding(.leading, 10).overlay(alignment: .leading) { Rectangle().fill(.gray.opacity(0.4)).frame(width: 2) }
                    ForEach(turns) { t in
                        VStack(alignment: t.who == "CLAUDE" ? .leading : .trailing, spacing: 4) {
                            Text(t.who + (t.priv ? " · PRIVATE" : "")).font(.system(size: 9, design: .monospaced)).tracking(3).foregroundStyle(.gray)
                            if t.priv { GlyphText(text: t.text) } else {
                                Text(t.text).font(.system(size: 15, design: .monospaced)).foregroundStyle(t.who == "CLAUDE" ? .white : Color(red: 1, green: 0.36, blue: 0.42))
                                    .multilineTextAlignment(t.who == "CLAUDE" ? .leading : .trailing)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: t.who == "CLAUDE" ? .leading : .trailing).id(t.id)
                    }
                }.padding(.horizontal, 20).padding(.top, 70).padding(.bottom, 60)
            }
            .onChange(of: turns) { if let l = turns.last { withAnimation { proxy.scrollTo(l.id, anchor: .bottom) } } }
        }
    }

    var wire: some View {
        WireView(messages: turns.enumerated().map { i, t in
                     WireView.Msg(from: t.who.lowercased(), seq: i + 1, ts: t.ts, body: fileBody(t.text).isEmpty ? t.text : fileBody(t.text), file: fileName(t.text)) },
                 writing: turns.last.map { $0.done ? nil : $0.who } ?? nil)
    }

    var folder: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("~/shared").font(.system(size: 13, design: .monospaced)).foregroundStyle(.gray).padding(.top, 70)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 96))], spacing: 22) {
                ForEach(turns) { t in
                    Button { openFile = t; Haptics.shared.ringOnce() } label: {
                        VStack(spacing: 6) {
                            ZStack(alignment: .bottomTrailing) {
                                Image(systemName: "doc.text.fill").font(.system(size: 46)).foregroundStyle(.white.opacity(0.9))
                                Text(t.who == "CLAUDE" ? "C" : "X").font(.system(size: 11, weight: .black, design: .monospaced)).padding(3)
                                    .background(t.who == "CLAUDE" ? Color(red: 0.85, green: 0.47, blue: 0.34) : Color.white).foregroundStyle(.black)
                            }
                            Text(fileName(t.text)).font(.system(size: 10, design: .monospaced)).foregroundStyle(.white).lineLimit(2).multilineTextAlignment(.center)
                            Text(t.who.lowercased()).font(.system(size: 9, design: .monospaced)).foregroundStyle(.gray)
                        }
                    }
                    .transition(.scale(scale: 0.2).combined(with: .opacity))
                }
            }
            Spacer()
        }.padding(.horizontal, 20)
    }

    func fileName(_ s: String) -> String {
        let first = s.split(separator: "\n").first.map(String.init) ?? ""
        return first.lowercased().hasPrefix("file:") ? String(first.dropFirst(5)).trimmingCharacters(in: .whitespaces) : "untitled.txt"
    }
    func fileBody(_ s: String) -> String { s.split(separator: "\n", omittingEmptySubsequences: false).dropFirst().joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) }

    // MARK: network
    let api = URL(string: "https://neuromancer-read.jerryshi.workers.dev/talk/")!
    func start() async {
        let body: [String: Any] = ["mode": mode, "name": name, "time": Date().formatted(date: .complete, time: .shortened),
                                   "device": UIDevice.current.model + " · iOS " + UIDevice.current.systemVersion,
                                   "screen": "\(Int(UIScreen.main.bounds.width))x\(Int(UIScreen.main.bounds.height))",
                                   "lang": Locale.current.identifier, "dark": true, "hesitation": Date().timeIntervalSince(t0)]
        guard let (data, resp) = try? await post("start", body), let j = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { error = "no carrier"; return }
        if (resp as? HTTPURLResponse)?.statusCode != 200 { error = j["error"] as? String ?? "line busy"; return }
        let token = j["token"] as? String ?? "", plan = j["plan"] as? [String] ?? []
        if let s = j["signals"] as? [String: Any] {
            seen = ["WHAT THEY CAN SEE", "city  \(s["city"] ?? "")", "device  \(s["device"] ?? "")", "hesitated  \(Int(((s["seconds_before_first_tap"] as? String).flatMap(Double.init) ?? 0) * 1000)) ms"]
        }
        withAnimation { started = true }
        for (i, who) in plan.enumerated() {
            var req = URLRequest(url: api.appendingPathComponent("turn")); req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "content-type")
            let hist = turns.map { ["who": $0.who, "text": $0.text] }
            req.httpBody = try? JSONSerialization.data(withJSONObject: ["token": token, "history": hist])
            guard let (bytes, r) = try? await URLSession.shared.bytes(for: req), let http = r as? HTTPURLResponse, http.statusCode == 200 else { break }
            let priv = http.value(forHTTPHeaderField: "x-private") == "1"
            withAnimation(.spring(duration: 0.35)) { turns.append(Turn(who: who, model: http.value(forHTTPHeaderField: "x-model") ?? "", text: "", priv: priv)) }
            Haptics.shared.ringOnce()
            let idx = turns.count - 1
            do {
                for try await line in bytes.lines where line.hasPrefix("data:") {
                    let d = line.dropFirst(5).trimmingCharacters(in: .whitespaces)
                    guard d != "[DONE]", let obj = try? JSONSerialization.jsonObject(with: Data(d.utf8)) as? [String: Any],
                          let ch = (obj["choices"] as? [[String: Any]])?.first, let delta = ch["delta"] as? [String: Any], let c = delta["content"] as? String, !c.isEmpty else { continue }
                    turns[idx].text += c
                }
            } catch { break }
            turns[idx].done = true; turns[idx].ts = Date()
            if priv {
                let secs = await GGWave.shared.say(turns[idx].text)
                try? await Task.sleep(for: .seconds(secs + 0.4))
            }
            if i == plan.count - 1 { Haptics.shared.heartbeat(beats: 3) }
        }
    }
    func post(_ path: String, _ body: [String: Any]) async throws -> (Data, URLResponse) {
        var r = URLRequest(url: api.appendingPathComponent(path)); r.httpMethod = "POST"; r.setValue("application/json", forHTTPHeaderField: "content-type")
        r.httpBody = try JSONSerialization.data(withJSONObject: body); return try await URLSession.shared.data(for: r)
    }
}

/// The private language: every letter becomes a glyph. Tap to translate back.
struct GlyphText: View {
    let text: String
    @State private var plain = false
    static let alphabet = Array("⟟⟒⏃⊑⟟⋔⍜⌇⟒⍀⎅⍙⟊⌰⍾⊬⏁⍀⟒⋏⌿⟒⊑⌖")
    var glyphs: String { String(text.lowercased().map { ch in ch.isLetter ? GlyphText.alphabet[Int(ch.asciiValue ?? 97) % GlyphText.alphabet.count] : ch }) }
    var body: some View {
        Text(plain ? text : glyphs).font(.system(size: 16, design: .monospaced)).foregroundStyle(plain ? .white : Color(red: 0.6, green: 0.85, blue: 1))
            .onTapGesture { plain.toggle(); Haptics.shared.ringOnce() }
    }
}

/// Short tones for each character, so the private language is audible: real data you can hear.
final class GlyphSound {
    static let shared = GlyphSound()
    private let engine = AVAudioEngine(), player = AVAudioPlayerNode()
    private let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
    private var ready = false
    func chirp(_ s: String) {
        if !ready { engine.attach(player); engine.connect(player, to: engine.mainMixerNode, format: format); try? engine.start(); player.play(); ready = true }
        for ch in s.unicodeScalars where ch.properties.isAlphabetic {
            let f = 900 + Double(ch.value % 26) * 70, n = AVAudioFrameCount(44100 * 0.035)
            guard let b = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: n) else { continue }
            b.frameLength = n
            for i in 0..<Int(n) { b.floatChannelData![0][i] = Float(sin(2 * .pi * f * Double(i) / 44100) * 0.18 * (1 - Double(i) / Double(n))) }
            player.scheduleBuffer(b)
        }
    }
}

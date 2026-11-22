import Foundation
import WebKit
import AVFoundation

/// Real data-over-sound (ggwave, MIT) run inside a hidden web view, played through the speaker.
/// The free Waver app can decode what it plays.
@MainActor final class GGWave: NSObject {
    static let shared = GGWave()
    private var web: WKWebView?
    private let engine = AVAudioEngine(), player = AVAudioPlayerNode()
    private let rate = 48000.0
    private var audioReady = false

    private func ensureWeb() async {
        if web != nil { return }
        let w = WKWebView(frame: .zero)
        web = w
        guard let src = Bundle.main.url(forResource: "ggwave", withExtension: "js"), let js = try? String(contentsOf: src, encoding: .utf8) else { return }
        w.loadHTMLString("<html><body><script>\(js)</script></body></html>", baseURL: nil)
        for _ in 0..<40 { if (try? await w.evaluateJavaScript("typeof ggwave_factory")) as? String == "function" { break }; try? await Task.sleep(for: .milliseconds(100)) }
    }

    /// Encode text (up to ~120 bytes) and play it. Returns the length in seconds.
    @discardableResult
    func say(_ text: String) async -> Double {
        await ensureWeb()
        guard let w = web else { return 0 }
        let payload = String(text.prefix(120))
        let js = """
        const g = await ggwave_factory(); const p = g.getDefaultParameters(); p.sampleRateInp = \(rate); p.sampleRateOut = \(rate);
        const i = g.init(p); const wf = g.encode(i, text, g.ProtocolId.GGWAVE_PROTOCOL_AUDIBLE_FAST, 25);
        const f = new Float32Array(new Int8Array(wf).buffer); let s = ''; const u = new Uint8Array(f.buffer);
        for (let k = 0; k < u.length; k++) s += String.fromCharCode(u[k]); return btoa(s);
        """
        guard let b64 = try? await w.callAsyncJavaScript(js, arguments: ["text": payload], contentWorld: .page) as? String,
              let data = Data(base64Encoded: b64) else { return 0 }
        let count = data.count / 4
        guard let fmt = AVAudioFormat(standardFormatWithSampleRate: rate, channels: 1), let buf = AVAudioPCMBuffer(pcmFormat: fmt, frameCapacity: AVAudioFrameCount(count)) else { return 0 }
        buf.frameLength = AVAudioFrameCount(count)
        data.withUnsafeBytes { raw in
            let src = raw.bindMemory(to: Float.self)
            for k in 0..<count { buf.floatChannelData![0][k] = src[k] }
        }
        if !audioReady {
            try? AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
            try? AVAudioSession.sharedInstance().setActive(true)
            engine.attach(player); engine.connect(player, to: engine.mainMixerNode, format: fmt); try? engine.start(); player.play(); audioReady = true
        }
        player.scheduleBuffer(buf, completionHandler: nil)
        return Double(count) / rate
    }
}

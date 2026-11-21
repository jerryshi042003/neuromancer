import CoreHaptics
import UIKit

/// Plays Morse code through the Taptic Engine: sharp transients for dots, held buzz for dashes.
final class Haptics {
    static let shared = Haptics()
    private var engine: CHHapticEngine?
    private let morse: [Character: String] = ["J": ".---", "A": ".-", "C": "-.-.", "K": "-.-", "I": "..", "N": "-.", "M": "--", "E": "."]

    /// The engine stops on its own when idle, when the app backgrounds, or after an audio interruption.
    /// That is why haptics only worked some of the time. Now it is restarted right before every pattern.
    func prepare() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        if engine == nil {
            engine = try? CHHapticEngine()
            engine?.isAutoShutdownEnabled = false
            engine?.playsHapticsOnly = true
            engine?.resetHandler = { [weak self] in try? self?.engine?.start() }
            engine?.stoppedHandler = { [weak self] _ in try? self?.engine?.start() }
        }
        try? engine?.start()
    }

    func run(_ events: [CHHapticEvent], curves: [CHHapticParameterCurve] = []) {
        prepare()
        guard let p = try? CHHapticPattern(events: events, parameterCurves: curves), let player = try? engine?.makePlayer(with: p) else { return }
        try? player.start(atTime: CHHapticTimeImmediate)
    }

    /// A heartbeat that speeds up.
    func heartbeat(beats: Int = 10) {
        var ev: [CHHapticEvent] = [], t = 0.0, gap = 0.9
        for _ in 0..<beats {
            for (dt, i) in [(0.0, 1.0), (0.16, 0.6)] as [(Double, Float)] {
                ev.append(CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: i),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)], relativeTime: t + dt))
            }
            t += gap; gap = max(0.35, gap * 0.88)
        }
        run(ev)
    }

    /// An old phone bell: two long rings, felt.
    func phoneRing() {
        var ev: [CHHapticEvent] = []
        for r in 0..<2 { for k in 0..<24 {
            ev.append(CHHapticEvent(eventType: .hapticTransient, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.9),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)], relativeTime: Double(r) * 1.4 + Double(k) * 0.04))
        } }
        run(ev)
    }

    /// One sharp crack.
    func crack() {
        run([CHHapticEvent(eventType: .hapticTransient, parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)], relativeTime: 0),
             CHHapticEvent(eventType: .hapticContinuous, parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.9)], relativeTime: 0.01, duration: 0.08)])
    }

    /// Returns the timing of each symbol so the screen can flash in sync.
    @discardableResult
    func play(_ word: String) -> [(start: Double, length: Double)] {
        let unit = 0.11
        var t = 0.0, events: [CHHapticEvent] = [], marks: [(Double, Double)] = []
        for ch in word.uppercased() {
            if ch == " " { t += unit * 4; continue }
            for s in morse[ch] ?? "" {
                let len = s == "." ? unit : unit * 3
                let sharp = CHHapticEventParameter(parameterID: .hapticSharpness, value: s == "." ? 1.0 : 0.35)
                let strong = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
                events.append(CHHapticEvent(eventType: .hapticTransient, parameters: [strong, sharp], relativeTime: t))
                events.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [strong, sharp], relativeTime: t, duration: len))
                marks.append((t, len))
                t += len + unit
            }
            t += unit * 2
        }
        run(events)
        return marks
    }

    /// One short double ring, felt rather than heard.
    func ringOnce() {
        var ev: [CHHapticEvent] = []
        for k in 0..<2 { ev.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.9)], relativeTime: Double(k) * 0.16, duration: 0.09)) }
        run(ev)
    }

    /// A rough, crackling texture: many tiny random taps, like static under your thumb.
    func staticBurst(seconds: Double = 1.2) {
        var events: [CHHapticEvent] = []
        var t = 0.0
        while t < seconds {
            let i = Float.random(in: 0.2...0.9), s = Float.random(in: 0.5...1.0)
            events.append(CHHapticEvent(eventType: .hapticTransient, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: i),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: s)], relativeTime: t))
            t += Double.random(in: 0.012...0.06)
        }
        run(events)
    }
}

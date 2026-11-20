import CoreHaptics
import UIKit

/// Plays Morse code through the Taptic Engine: sharp transients for dots, held buzz for dashes.
final class Haptics {
    static let shared = Haptics()
    private var engine: CHHapticEngine?
    private let morse: [Character: String] = ["J": ".---", "A": ".-", "C": "-.-.", "K": "-.-", "I": "..", "N": "-.", "M": "--", "E": "."]

    func prepare() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        engine = try? CHHapticEngine()
        engine?.resetHandler = { [weak self] in try? self?.engine?.start() }
        try? engine?.start()
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
        if let p = try? CHHapticPattern(events: events, parameters: []), let player = try? engine?.makePlayer(with: p) {
            try? player.start(atTime: 0)
        }
        return marks
    }

    /// One short double ring, felt rather than heard.
    func ringOnce() {
        var ev: [CHHapticEvent] = []
        for k in 0..<2 { ev.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.9)], relativeTime: Double(k) * 0.16, duration: 0.09)) }
        if let p = try? CHHapticPattern(events: ev, parameters: []), let player = try? engine?.makePlayer(with: p) { try? player.start(atTime: 0) }
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
        if let p = try? CHHapticPattern(events: events, parameters: []), let player = try? engine?.makePlayer(with: p) {
            try? player.start(atTime: 0)
        }
    }
}

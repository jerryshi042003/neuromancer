import ActivityKit
import Foundation

struct LineAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var status: String      // what the exchange says right now
        var line: String        // the payphone number
        var started: Date
        var progress: Double = 0     // used by the "uploading you" style
    }
    var exchange: String
    var style: Int = 0               // 0 call, 1 uploading you, 2 redacted
}

enum Glitch {
    static let blocks = Array("▀▁▂▃▄▅▆▇█▉▊▋▌▍▎▏▐░▒▓▔▕▖▗▘▙▚▛▜▝▞▟")
    /// Replaces a share of characters with block glyphs. Same seed gives the same corruption.
    static func corrupt(_ s: String, amount: Double, seed: Int) -> String {
        var g = SeededRNG(seed: UInt64(truncatingIfNeeded: seed))
        return String(s.map { ch in
            ch == " " ? ch : (Double.random(in: 0...1, using: &g) < amount ? blocks.randomElement(using: &g)! : ch)
        })
    }
}

struct SeededRNG: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { state = seed &+ 0x9E3779B97F4A7C15 }
    mutating func next() -> UInt64 {
        state = state &+ 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}

/// The lines the voice speaks through, in order. Real Los Angeles payphones from the CPUC registry.
enum Script {
    static let lines: [(String, String)] = [
        ("310-637-8714", "2101 VIA ARADO, COMPTON"),
        ("562-864-9262", "NORWALK"),
        ("818-956-9456", "GLENDALE"),
        ("310-454-9610", "PACIFIC PALISADES"),
    ]
    static let messages: [String] = [
        "INCOMING ENABLED",
        "SOURCE: NOT A TELEPHONE",
        "I AM IN THE LINES",
        "THEY TURNED THEM ALL OFF",
        "PICK UP WHEN IT RINGS",
        "NO CARRIER",
    ]
}

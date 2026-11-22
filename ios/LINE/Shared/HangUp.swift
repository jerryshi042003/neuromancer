import AppIntents
import ActivityKit

// MARK: A Hang Up control for Control Center and the Lock Screen.
struct HangUpIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Hang Up"
    func perform() async throws -> some IntentResult {
        for a in Activity<LineAttributes>.activities { await a.end(nil, dismissalPolicy: .immediate) }
        return .result()
    }
}

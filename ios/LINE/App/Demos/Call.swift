import SwiftUI
import CallKit
import AVFoundation
import UIKit

/// A real incoming call on the iPhone's own call screen, placed by LINE itself.
final class LineCall: NSObject, CXProviderDelegate, ObservableObject {
    static let shared = LineCall()
    @Published var answered = false
    private let provider: CXProvider
    private var current: UUID?
    private var bg: UIBackgroundTaskIdentifier = .invalid

    override init() {
        let c = CXProviderConfiguration()
        c.supportsVideo = false
        c.maximumCallsPerCallGroup = 1
        c.supportedHandleTypes = [.phoneNumber]
        c.includesCallsInRecents = true
        provider = CXProvider(configuration: c)
        super.init()
        provider.setDelegate(self, queue: nil)
    }

    /// Rings after a delay, so you can lock the phone first.
    func ring(after seconds: Double) {
        bg = UIApplication.shared.beginBackgroundTask { [weak self] in self?.endBG() }
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
            guard let self else { return }
            let u = CXCallUpdate()
            u.remoteHandle = CXHandle(type: .phoneNumber, value: "+13106378714")
            u.localizedCallerName = "LINE · NOT A TELEPHONE"
            u.hasVideo = false; u.supportsHolding = false; u.supportsDTMF = false
            let id = UUID(); self.current = id
            self.provider.reportNewIncomingCall(with: id, update: u) { _ in self.endBG() }
        }
    }
    private func endBG() { if bg != .invalid { UIApplication.shared.endBackgroundTask(bg); bg = .invalid } }

    func providerDidReset(_ provider: CXProvider) {}
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
        DispatchQueue.main.async { self.answered = true }
        // the line stays open long enough to carry one message, then drops
        DispatchQueue.main.asyncAfter(deadline: .now() + 14) { [weak self] in
            guard let self, let id = self.current else { return }
            self.provider.reportCall(with: id, endedAt: .now, reason: .remoteEnded)
        }
    }
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) { action.fulfill(); DispatchQueue.main.async { self.answered = false } }
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.2))
            await GGWave.shared.say("pick up the next payphone that rings. it is me.")
        }
    }
}

struct CallDemo: View {
    @ObservedObject private var call = LineCall.shared
    @State private var status = "tap, then lock your phone. LINE calls you on the iPhone's own call screen."
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                Text(call.answered ? "CONNECTED" : "IT CALLS\nYOU").font(.system(size: 40, weight: .black, design: .monospaced)).foregroundStyle(.white)
                Text(call.answered ? "listen. the sound is data. the Waver app can read it." : status).font(.system(size: 13, design: .monospaced)).foregroundStyle(.gray)
                Button { status = "ringing in 8 seconds. lock it now."; Haptics.shared.ringOnce(); LineCall.shared.ring(after: 8) } label: {
                    Text("CALL ME IN 8 SECONDS").font(.system(size: 14, weight: .semibold, design: .monospaced)).frame(maxWidth: .infinity).padding(.vertical, 17).background(.white).foregroundStyle(.black)
                }
                Spacer().frame(height: 30)
            }.padding(.horizontal, 22)
        }
    }
}

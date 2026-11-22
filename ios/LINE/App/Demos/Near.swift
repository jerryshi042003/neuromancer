import SwiftUI
import NearbyInteraction
import MultipeerConnectivity

/// Two iPhones running LINE find each other: distance and direction from the ultra-wideband chips.
final class TwoPhones: NSObject, ObservableObject, NISessionDelegate, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    @Published var distance: Float?
    @Published var direction: SIMD3<Float>?
    @Published var peer: String?
    @Published var status = "open LINE on the other iPhone too"
    private var ni: NISession?
    private let me = MCPeerID(displayName: UIDevice.current.name)
    private lazy var mc = MCSession(peer: me, securityIdentity: nil, encryptionPreference: .required)
    private lazy var adv = MCNearbyServiceAdvertiser(peer: me, discoveryInfo: nil, serviceType: "line-ni")
    private lazy var browser = MCNearbyServiceBrowser(peer: me, serviceType: "line-ni")

    func start() {
        guard NISession.deviceCapabilities.supportsPreciseDistanceMeasurement else { status = "this phone has no ultra-wideband chip"; return }
        ni = NISession(); ni?.delegate = self
        mc.delegate = self; adv.delegate = self; browser.delegate = self
        adv.startAdvertisingPeer(); browser.startBrowsingForPeers()
    }
    func stop() { ni?.invalidate(); adv.stopAdvertisingPeer(); browser.stopBrowsingForPeers(); mc.disconnect() }
    private func sendToken() {
        guard let t = ni?.discoveryToken, let d = try? NSKeyedArchiver.archivedData(withRootObject: t, requiringSecureCoding: true) else { return }
        try? mc.send(d, toPeers: mc.connectedPeers, with: .reliable)
    }
    // multipeer: exchange the ultra-wideband tokens
    func advertiser(_ a: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer p: MCPeerID, withContext c: Data?, invitationHandler h: @escaping (Bool, MCSession?) -> Void) { h(true, mc) }
    func browser(_ b: MCNearbyServiceBrowser, foundPeer p: MCPeerID, withDiscoveryInfo i: [String: String]?) { if me.displayName < p.displayName { b.invitePeer(p, to: mc, withContext: nil, timeout: 10) } }
    func browser(_ b: MCNearbyServiceBrowser, lostPeer p: MCPeerID) {}
    func session(_ s: MCSession, peer p: MCPeerID, didChange st: MCSessionState) {
        DispatchQueue.main.async { if st == .connected { self.peer = p.displayName; self.status = "found \(p.displayName)"; self.sendToken() } }
    }
    func session(_ s: MCSession, didReceive data: Data, fromPeer p: MCPeerID) {
        guard let t = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else { return }
        ni?.run(NINearbyPeerConfiguration(peerToken: t))
    }
    func session(_ s: MCSession, didReceive st: InputStream, withName n: String, fromPeer p: MCPeerID) {}
    func session(_ s: MCSession, didStartReceivingResourceWithName n: String, fromPeer p: MCPeerID, with pr: Progress) {}
    func session(_ s: MCSession, didFinishReceivingResourceWithName n: String, fromPeer p: MCPeerID, at u: URL?, withError e: Error?) {}
    // ultra-wideband: distance and direction
    func session(_ s: NISession, didUpdate objs: [NINearbyObject]) {
        guard let o = objs.first else { return }
        DispatchQueue.main.async { self.distance = o.distance; self.direction = o.direction }
    }
}

struct TwoPhonesDemo: View {
    @StateObject private var t = TwoPhones()
    @State private var lastBuzz = Date()
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 18) {
                Spacer()
                if let d = t.distance {
                    let angle = t.direction.map { Double(atan2($0.x, -$0.y)) * 180 / .pi } ?? 0
                    Image(systemName: "arrow.up").font(.system(size: 120, weight: .ultraLight)).foregroundStyle(.white).rotationEffect(.degrees(t.direction == nil ? 0 : angle)).animation(.easeOut(duration: 0.15), value: angle)
                    Text(String(format: "%.2f m", d)).font(.system(size: 44, weight: .black, design: .monospaced)).foregroundStyle(.white)
                        .onChange(of: d) { _, v in if v < 0.5 && Date().timeIntervalSince(lastBuzz) > 1 { Haptics.shared.heartbeat(beats: 2); lastBuzz = Date() } }
                    Text(t.peer ?? "").font(.system(size: 14, design: .monospaced)).foregroundStyle(.gray)
                } else {
                    Text("FIND\nTHE OTHER\nPHONE").font(.system(size: 40, weight: .black, design: .monospaced)).foregroundStyle(.white).multilineTextAlignment(.center)
                    Text(t.status).font(.system(size: 13, design: .monospaced)).foregroundStyle(.gray)
                }
                Spacer()
            }.padding(.horizontal, 22)
        }
        .onAppear { t.start() }
        .onDisappear { t.stop() }
    }
}

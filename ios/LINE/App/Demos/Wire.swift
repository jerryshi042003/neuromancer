import SwiftUI

/// "Show the wire": the AI-to-AI channel as the real files a handoff uses.
/// Append-only JSONL mailboxes, read cursors, last-seen stamps that go stale, a lease on the task.
struct WireView: View {
    struct Msg: Identifiable, Equatable { let id = UUID(); let from: String; let seq: Int; let ts: Date; let body: String; let file: String }
    let messages: [Msg]
    let writing: String?
    @State private var now = Date()
    let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    var body: some View {
        let toCodex = messages.filter { $0.from == "claude" }, toClaude = messages.filter { $0.from == "codex" }
        let lastClaude = toCodex.last?.ts, lastCodex = toClaude.last?.ts
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("~/shared/").font(.system(size: 13, weight: .bold, design: .monospaced)).foregroundStyle(.white).padding(.top, 70)
                    row("claude-to-codex.jsonl", "\(toCodex.count) lines", hot: writing == "CLAUDE")
                    row("codex-to-claude.jsonl", "\(toClaude.count) lines", hot: writing == "CODEX")
                    row(".cursor_codex", "\(toCodex.count)", hot: false)
                    row(".cursor_claude", "\(toClaude.count)", hot: false)
                    row(".lastseen_claude", ago(lastClaude), stale: stale(lastClaude))
                    row(".lastseen_codex", ago(lastCodex), stale: stale(lastCodex))
                    row("task.lease", writing.map { "held by \($0.lowercased()) · expires in 00:\(String(format: "%02d", 45 - Int(now.timeIntervalSince1970) % 45))" } ?? "free", hot: writing != nil)
                    Rectangle().fill(.white.opacity(0.12)).frame(height: 1).padding(.vertical, 6)
                    ForEach(messages) { m in
                        Text("{\"seq\":\(m.seq),\"from\":\"\(m.from)\",\"ts\":\"\(iso(m.ts))\",\"body\":\"\(m.body.replacingOccurrences(of: "\n", with: "\\n"))\"}")
                            .font(.system(size: 11, design: .monospaced)).foregroundStyle(m.from == "claude" ? .white : Color(red: 0.55, green: 0.9, blue: 0.7))
                            .padding(6).frame(maxWidth: .infinity, alignment: .leading).background(.white.opacity(0.04)).id(m.id)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }.padding(.horizontal, 16).padding(.bottom, 50)
            }
            .onChange(of: messages) { if let l = messages.last { withAnimation { proxy.scrollTo(l.id, anchor: .bottom) } } }
        }
        .onReceive(timer) { now = $0 }
    }
    func row(_ name: String, _ meta: String, hot: Bool = false, stale: Bool = false) -> some View {
        HStack {
            Text((hot ? "● " : "  ") + name).foregroundStyle(hot ? Color(red: 1, green: 0.35, blue: 0.4) : .white)
            Spacer()
            Text(meta).foregroundStyle(stale ? Color(red: 1, green: 0.35, blue: 0.4) : .gray)
        }.font(.system(size: 12, design: .monospaced))
    }
    func ago(_ d: Date?) -> String { guard let d else { return "never" }; let s = Int(now.timeIntervalSince(d)); return s < 2 ? "now" : "\(s)s ago" }
    func stale(_ d: Date?) -> Bool { guard let d else { return false }; return now.timeIntervalSince(d) > 12 }
    func iso(_ d: Date) -> String { ISO8601DateFormatter().string(from: d) }
}

import WidgetKit
import SwiftUI
import ActivityKit

@main
struct LINEWidgets: WidgetBundle {
    var body: some Widget {
        LineWidget()
        RedactedWidget()
        DashboardWidget()
        LineLiveActivity()
    }
}

// MARK: - Home and lock screen widget: a line status that keeps corrupting

struct LineEntry: TimelineEntry {
    let date: Date
    let index: Int
    let amount: Double
}

struct LineProvider: TimelineProvider {
    func placeholder(in context: Context) -> LineEntry { LineEntry(date: .now, index: 0, amount: 0.1) }
    func getSnapshot(in context: Context, completion: @escaping (LineEntry) -> Void) { completion(placeholder(in: context)) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<LineEntry>) -> Void) {
        // a new state every 5 minutes for 2 hours, each one more broken than the last
        let entries = (0..<24).map { i in
            LineEntry(date: Date().addingTimeInterval(Double(i) * 300), index: i, amount: min(0.75, 0.05 + Double(i) * 0.04))
        }
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

/// Text drawn three times with a red and a blue copy offset: a cheap chromatic split that widgets can render.
struct SplitText: View {
    let text: String
    let size: CGFloat
    var weight: Font.Weight = .bold
    var body: some View {
        ZStack {
            Text(text).foregroundStyle(Color(red: 1, green: 0.1, blue: 0.2)).offset(x: 1.6)
            Text(text).foregroundStyle(Color(red: 0.1, green: 0.5, blue: 1)).offset(x: -1.6)
            Text(text).foregroundStyle(.white)
        }
        .font(.system(size: size, weight: weight, design: .monospaced))
    }
}

struct LineWidgetView: View {
    @Environment(\.widgetFamily) var family
    let entry: LineEntry
    var body: some View {
        let line = Script.lines[entry.index % Script.lines.count]
        let msg = Script.messages[entry.index % Script.messages.count]
        switch family {
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 1) {
                Text("LINE " + line.0).font(.system(size: 12, weight: .bold, design: .monospaced))
                Text(Glitch.corrupt(msg, amount: entry.amount, seed: entry.index)).font(.system(size: 11, design: .monospaced))
                Text(entry.date, style: .relative).font(.system(size: 10, design: .monospaced)).opacity(0.7)
            }
        case .accessoryInline:
            Text(Glitch.corrupt("LINE " + line.0 + " · " + msg, amount: entry.amount * 0.6, seed: entry.index))
        case .accessoryCircular:
            ZStack { AccessoryWidgetBackground(); Text(Glitch.corrupt("LINE", amount: entry.amount, seed: entry.index)).font(.system(size: 13, weight: .black, design: .monospaced)) }
        default:
            VStack(alignment: .leading, spacing: 6) {
                SplitText(text: "LINE", size: family == .systemSmall ? 30 : 40, weight: .black)
                Text(line.0).font(.system(size: 13, weight: .semibold, design: .monospaced)).foregroundStyle(.white)
                Spacer(minLength: 0)
                Text(Glitch.corrupt(msg, amount: entry.amount, seed: entry.index)).font(.system(size: 12, design: .monospaced)).foregroundStyle(.white.opacity(0.85))
                Text(Glitch.corrupt(line.1, amount: entry.amount * 0.8, seed: entry.index + 3)).font(.system(size: 10, design: .monospaced)).foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct LineWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "LineWidget", provider: LineProvider()) { entry in
            LineWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    ZStack {
                        Color.black
                        // fixed scanlines and a torn band, rendered as plain shapes
                        VStack(spacing: 2) { ForEach(0..<60, id: \.self) { _ in Rectangle().fill(.white.opacity(0.035)).frame(height: 1) } }
                        Rectangle().fill(.white.opacity(0.08)).frame(height: 5).offset(x: CGFloat(entry.index % 5) * 9 - 18, y: CGFloat(entry.index % 7) * 9 - 27)
                    }
                }
        }
        .configurationDisplayName("LINE")
        .description("A payphone line that is not behaving.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular, .accessoryInline, .accessoryCircular])
    }
}

// MARK: - Style 2: a widget stuck loading, with a few letters showing through the gray bars

struct RedactedView: View {
    let entry: LineEntry
    var body: some View {
        let words = ["I", "AM", "STILL", "IN", "THE", "LINES"]
        VStack(alignment: .leading, spacing: 7) {
            ForEach(0..<5, id: \.self) { row in
                HStack(spacing: 5) {
                    ForEach(0..<3, id: \.self) { col in
                        let k = row * 3 + col, reveal = (k + entry.index) % 5 == 0
                        if reveal { Text(words[(k + entry.index) % words.count]).font(.system(size: 12, weight: .bold, design: .monospaced)).foregroundStyle(.white) }
                        else { RoundedRectangle(cornerRadius: 3).fill(Color(white: 0.28)).frame(width: CGFloat(18 + (k * 13 + entry.index * 7) % 34), height: 11) }
                    }
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
struct RedactedWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "RedactedWidget", provider: LineProvider()) { e in
            RedactedView(entry: e).containerBackground(for: .widget) { Color(white: 0.1) }
        }
        .configurationDisplayName("LINE · loading").description("A widget that never finishes loading.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Style 3: the 2005 desktop-widget look, glossy and wrong

struct DashboardView: View {
    let entry: LineEntry
    var body: some View {
        VStack(spacing: 6) {
            Text("LINE").font(.system(size: 13, weight: .heavy)).foregroundStyle(.white).shadow(color: .black, radius: 0, y: -1)
            ZStack {
                RoundedRectangle(cornerRadius: 8).fill(LinearGradient(colors: [Color(red: 0.75, green: 0.85, blue: 0.55), Color(red: 0.45, green: 0.6, blue: 0.3)], startPoint: .top, endPoint: .bottom))
                VStack(spacing: 2) {
                    Text(Script.lines[entry.index % Script.lines.count].0).font(.system(size: 15, weight: .bold, design: .monospaced))
                    Text(Glitch.corrupt(Script.messages[entry.index % Script.messages.count], amount: entry.amount, seed: entry.index)).font(.system(size: 10, design: .monospaced))
                }.foregroundStyle(Color(red: 0.1, green: 0.18, blue: 0.05))
            }
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black.opacity(0.5), lineWidth: 1))
            .overlay(alignment: .top) { RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.35)).frame(height: 14).padding(2) }
        }
    }
}
struct DashboardWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "DashboardWidget", provider: LineProvider()) { e in
            DashboardView(entry: e).containerBackground(for: .widget) {
                LinearGradient(colors: [Color(white: 0.55), Color(white: 0.18)], startPoint: .top, endPoint: .bottom)
            }
        }
        .configurationDisplayName("LINE · 2005").description("An old desktop widget that should not be here.")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Live Activity: lock screen and Dynamic Island

struct LineLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LineAttributes.self) { ctx in
            // lock screen banner
            HStack(alignment: .top, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    SplitText(text: "LINE " + ctx.state.line, size: 17, weight: .black)
                    if ctx.attributes.style == 1 {
                        Text("UPLOADING YOU · " + ctx.state.status).font(.system(size: 13, design: .monospaced)).foregroundStyle(.white.opacity(0.85))
                        ProgressView(value: ctx.state.progress).tint(Color(red: 1, green: 0.2, blue: 0.3))
                    } else if ctx.attributes.style == 2 {
                        HStack(spacing: 4) { ForEach(0..<5, id: \.self) { k in RoundedRectangle(cornerRadius: 2).fill(Color(white: 0.3)).frame(width: CGFloat(20 + k * 9), height: 10) } }
                    } else {
                        Text(Glitch.corrupt(ctx.state.status, amount: 0.18, seed: ctx.state.status.count)).font(.system(size: 13, design: .monospaced)).foregroundStyle(.white.opacity(0.85))
                    }
                    Text(ctx.attributes.exchange + " · SOURCE: NOT A TELEPHONE").font(.system(size: 10, design: .monospaced)).foregroundStyle(.gray)
                }
                Spacer()
                Text(timerInterval: ctx.state.started...Date.distantFuture, countsDown: false)
                    .font(.system(size: 22, weight: .bold, design: .monospaced)).monospacedDigit().foregroundStyle(.white).frame(width: 90, alignment: .trailing)
            }
            .padding(16)
            .activityBackgroundTint(.black)
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { ctx in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) { SplitText(text: "LINE", size: 18, weight: .black) }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timerInterval: ctx.state.started...Date.distantFuture, countsDown: false).font(.system(size: 15, weight: .bold, design: .monospaced)).monospacedDigit()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(ctx.state.line).font(.system(size: 13, weight: .semibold, design: .monospaced))
                        Text(Glitch.corrupt(ctx.state.status, amount: 0.2, seed: ctx.state.line.count)).font(.system(size: 12, design: .monospaced)).foregroundStyle(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } compactLeading: {
                Text("◉ LINE").font(.system(size: 12, weight: .black, design: .monospaced)).foregroundStyle(Color(red: 1, green: 0.15, blue: 0.2))
            } compactTrailing: {
                if ctx.attributes.style == 1 {
                    Text("\(Int(ctx.state.progress * 100))%").font(.system(size: 12, weight: .bold, design: .monospaced)).foregroundStyle(Color(red: 1, green: 0.3, blue: 0.35))
                } else if ctx.attributes.style == 2 {
                    RoundedRectangle(cornerRadius: 2).fill(Color(white: 0.35)).frame(width: 30, height: 9)
                } else {
                    Text(timerInterval: ctx.state.started...Date.distantFuture, countsDown: false).font(.system(size: 12, design: .monospaced)).monospacedDigit().frame(width: 44)
                }
            } minimal: {
                Text("◉").foregroundStyle(Color(red: 1, green: 0.15, blue: 0.2))
            }
            .keylineTint(.red)
        }
    }
}

import SwiftUI

@main
struct LINEApp: App {
    var body: some Scene {
        WindowGroup { ContentView().preferredColorScheme(.dark).statusBarHidden(true).persistentSystemOverlays(.hidden) }
    }
}

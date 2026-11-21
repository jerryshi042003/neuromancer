import SwiftUI

@main
struct LINEApp: App {
    var body: some Scene {
        WindowGroup { Board().preferredColorScheme(.dark).statusBarHidden(true).persistentSystemOverlays(.hidden) }
    }
}

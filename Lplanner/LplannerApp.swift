import SwiftUI
import ZPlannerUI

@main
struct LplannerApp: App {
    var body: some Scene {
        WindowGroup { ZPlannerView() }
            // Replaces the stock Help menu, which pointed at a help book that
            // does not exist and answered "Help isn't available for Lplanner".
            .commands { ZPlannerHelpCommands() }
    }
}

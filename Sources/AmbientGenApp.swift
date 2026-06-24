import SwiftUI

@main
struct AmbientGenApp: App {

    init() {
        // Run as an accessory app (menu bar utility, hides Dock icon)
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(.accessory)
        }
    }

    var body: some Scene {
        MenuBarExtra("AmbientGen", systemImage: "headphones") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}

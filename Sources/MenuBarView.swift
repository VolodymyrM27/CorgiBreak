import SwiftUI
import ServiceManagement

struct MenuBarView: View {
    @ObservedObject var timerManager: TimerManager
    @State private var launchAtLogin = SMAppService.mainApp.status == .enabled

    var body: some View {
        Text("Next break in \(timerManager.timeRemainingFormatted)")
            .font(.headline)

        Divider()

        Button(timerManager.isPaused ? "Resume" : "Pause") {
            timerManager.togglePause()
        }
        .keyboardShortcut("p")

        Button("Take a Break Now") {
            timerManager.triggerBreak()
        }
        .keyboardShortcut("b")

        Divider()

        Toggle("Launch at Login", isOn: $launchAtLogin)
            .onChange(of: launchAtLogin) { newValue in
                do {
                    if newValue {
                        try SMAppService.mainApp.register()
                    } else {
                        try SMAppService.mainApp.unregister()
                    }
                } catch {
                    launchAtLogin = SMAppService.mainApp.status == .enabled
                }
            }

        Divider()

        Button("Quit CorgiBreak") {
            NSApp.terminate(nil)
        }
        .keyboardShortcut("q")
    }
}

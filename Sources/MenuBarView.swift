import SwiftUI

struct MenuBarView: View {
    @ObservedObject var timerManager: TimerManager
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.openSettings) private var openSettings

    var body: some View {
        if settingsManager.scheduleEnabled && !settingsManager.isWithinSchedule() {
            Text("Breaks paused (schedule)")
                .font(.headline)
        } else {
            Text("Next break in \(timerManager.timeRemainingFormatted)")
                .font(.headline)
        }

        Divider()

        Button(timerManager.isPaused ? "Resume" : "Pause") {
            timerManager.togglePause()
        }
        .keyboardShortcut("p")

        Button("Take a Break Now") {
            timerManager.triggerBreak()
        }
        .keyboardShortcut("b")

        Button("Settings...") {
            openSettings()
            NSApp.activate(ignoringOtherApps: true)
        }
        .keyboardShortcut(",")

        Divider()

        Button("Quit CorgiBreak") {
            NSApp.terminate(nil)
        }
        .keyboardShortcut("q")
    }
}

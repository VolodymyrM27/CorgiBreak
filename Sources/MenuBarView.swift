import SwiftUI

struct MenuBarView: View {
    @ObservedObject var timerManager: TimerManager

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

        Button("Quit CorgiBreak") {
            NSApp.terminate(nil)
        }
        .keyboardShortcut("q")
    }
}

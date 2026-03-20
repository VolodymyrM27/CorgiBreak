import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        ProcessInfo.processInfo.disableSuddenTermination()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}

@main
struct CorgiBreakApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var timerManager = TimerManager()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(timerManager: timerManager)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: timerManager.isOnBreak ? "eye.slash" : "eye")
                Text(timerManager.menuBarTitle)
            }
        }
        .menuBarExtraStyle(.menu)
    }
}

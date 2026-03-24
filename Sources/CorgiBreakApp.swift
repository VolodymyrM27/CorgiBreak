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
    @StateObject private var settingsManager: SettingsManager
    @StateObject private var timerManager: TimerManager

    init() {
        let settings = SettingsManager()
        _settingsManager = StateObject(wrappedValue: settings)
        _timerManager = StateObject(wrappedValue: TimerManager(settings: settings))
    }

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(timerManager: timerManager)
                .environmentObject(settingsManager)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: timerManager.isOnBreak ? "eye.slash" : "eye")
                Text(timerManager.menuBarTitle)
            }
        }
        .menuBarExtraStyle(.menu)

        Settings {
            SettingsView()
                .environmentObject(settingsManager)
        }
    }
}

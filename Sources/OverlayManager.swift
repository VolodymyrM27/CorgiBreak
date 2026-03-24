import SwiftUI

final class OverlayManager {
    private var windows: [NSWindow] = []
    private var eventMonitor: Any?

    func showOverlay(timerManager: TimerManager) {
        for screen in NSScreen.screens {
            let window = NSWindow(
                contentRect: screen.frame,
                styleMask: .borderless,
                backing: .buffered,
                defer: false,
                screen: screen
            )
            window.level = .screenSaver
            window.isOpaque = false
            window.backgroundColor = .clear
            window.ignoresMouseEvents = false
            window.hasShadow = false
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            window.alphaValue = 0

            let breakView = BreakView(timerManager: timerManager, topSafeArea: screen.safeAreaInsets.top, bottomSafeArea: screen.safeAreaInsets.bottom)
            let hostingView = NSHostingView(rootView: breakView)
            hostingView.frame = NSRect(origin: .zero, size: screen.frame.size)
            window.contentView = hostingView

            window.makeKeyAndOrderFront(nil)

            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.4
                context.timingFunction = CAMediaTimingFunction(name: .easeIn)
                window.animator().alphaValue = 1
            }

            windows.append(window)
        }

        NSApp.activate(ignoringOtherApps: true)

        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak timerManager] event in
            if event.keyCode == 53 { // Escape
                timerManager?.skipBreak()
                return nil
            }
            return event
        }
    }

    func hideOverlay() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }

        for window in windows {
            window.orderOut(nil)
        }
        windows.removeAll()
    }
}

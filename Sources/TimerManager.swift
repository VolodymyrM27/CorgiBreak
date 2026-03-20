import SwiftUI
import Combine

final class TimerManager: ObservableObject {
    @Published var timeRemaining: TimeInterval = 20 * 60
    @Published var breakTimeRemaining: TimeInterval = 20
    @Published var isPaused = false
    @Published var isOnBreak = false

    private var timer: Timer?
    private var overlayManager: OverlayManager?

    var timeRemainingFormatted: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var menuBarTitle: String {
        if isOnBreak {
            return "\(Int(breakTimeRemaining))s"
        }
        if isPaused {
            return "paused"
        }
        return timeRemainingFormatted
    }

    init() {
        startTimer()
        observeScreenSleep()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.tick()
        }
    }

    private func tick() {
        guard !isPaused else { return }

        if isOnBreak {
            breakTimeRemaining -= 1
            if breakTimeRemaining <= 0 {
                endBreak()
            }
        } else {
            timeRemaining -= 1
            if timeRemaining <= 0 {
                triggerBreak()
            }
        }
    }

    func triggerBreak() {
        guard !isOnBreak else { return }
        isOnBreak = true
        breakTimeRemaining = 20

        NSSound(named: "Glass")?.play()

        let overlay = OverlayManager()
        self.overlayManager = overlay
        overlay.showOverlay(timerManager: self)
    }

    func endBreak() {
        isOnBreak = false
        timeRemaining = 20 * 60
        overlayManager?.hideOverlay()
        overlayManager = nil

        NSSound(named: "Pop")?.play()
    }

    func skipBreak() {
        endBreak()
    }

    func togglePause() {
        isPaused.toggle()
    }

    private func observeScreenSleep() {
        let center = NSWorkspace.shared.notificationCenter

        center.addObserver(
            forName: NSWorkspace.screensDidSleepNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            self?.isPaused = true
            if self?.isOnBreak == true {
                self?.endBreak()
            }
        }

        center.addObserver(
            forName: NSWorkspace.screensDidWakeNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            self?.isPaused = false
            self?.timeRemaining = 20 * 60
        }
    }
}

import Foundation
import ServiceManagement

class SettingsManager: ObservableObject {
    // Break timing
    @Published var breakIntervalSeconds: Int {
        didSet { UserDefaults.standard.set(breakIntervalSeconds, forKey: "breakIntervalSeconds") }
    }

    @Published var breakDuration: Int {
        didSet { UserDefaults.standard.set(breakDuration, forKey: "breakDuration") }
    }

    // Schedule
    @Published var scheduleEnabled: Bool {
        didSet { UserDefaults.standard.set(scheduleEnabled, forKey: "scheduleEnabled") }
    }

    @Published var scheduleStartHour: Int {
        didSet { UserDefaults.standard.set(scheduleStartHour, forKey: "scheduleStartHour") }
    }

    @Published var scheduleStartMinute: Int {
        didSet { UserDefaults.standard.set(scheduleStartMinute, forKey: "scheduleStartMinute") }
    }

    @Published var scheduleEndHour: Int {
        didSet { UserDefaults.standard.set(scheduleEndHour, forKey: "scheduleEndHour") }
    }

    @Published var scheduleEndMinute: Int {
        didSet { UserDefaults.standard.set(scheduleEndMinute, forKey: "scheduleEndMinute") }
    }

    // Sound
    @Published var soundEnabled: Bool {
        didSet { UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled") }
    }

    // Launch at Login (use SMAppService, not UserDefaults)
    @Published var launchAtLogin: Bool {
        didSet {
            if launchAtLogin {
                do {
                    try SMAppService.mainApp.register()
                } catch {
                    // Revert on failure
                    launchAtLogin = false
                }
            } else {
                do {
                    try SMAppService.mainApp.unregister()
                } catch {
                    // Revert on failure
                    launchAtLogin = true
                }
            }
        }
    }

    init() {
        let defaults = UserDefaults.standard

        // Migration: convert old breakIntervalMinutes to breakIntervalSeconds
        let intervalSeconds: Int
        if let oldMinutes = defaults.object(forKey: "breakIntervalMinutes") as? Int {
            intervalSeconds = oldMinutes * 60
            defaults.set(intervalSeconds, forKey: "breakIntervalSeconds")
            defaults.removeObject(forKey: "breakIntervalMinutes")
        } else {
            intervalSeconds = defaults.object(forKey: "breakIntervalSeconds") as? Int ?? 1200
        }
        self.breakIntervalSeconds = intervalSeconds

        self.breakDuration = defaults.object(forKey: "breakDuration") as? Int ?? 20
        self.scheduleEnabled = defaults.object(forKey: "scheduleEnabled") as? Bool ?? false
        self.scheduleStartHour = defaults.object(forKey: "scheduleStartHour") as? Int ?? 10
        self.scheduleStartMinute = defaults.object(forKey: "scheduleStartMinute") as? Int ?? 0
        self.scheduleEndHour = defaults.object(forKey: "scheduleEndHour") as? Int ?? 19
        self.scheduleEndMinute = defaults.object(forKey: "scheduleEndMinute") as? Int ?? 0
        self.soundEnabled = defaults.object(forKey: "soundEnabled") as? Bool ?? true
        self.launchAtLogin = SMAppService.mainApp.status == .enabled
    }

    // Computed helper
    func isWithinSchedule() -> Bool {
        // If scheduleEnabled is false, return true (always active)
        guard scheduleEnabled else { return true }

        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour, .minute], from: now)

        guard let currentHour = components.hour,
              let currentMinute = components.minute else {
            return true
        }

        let currentMinutes = currentHour * 60 + currentMinute
        let startMinutes = scheduleStartHour * 60 + scheduleStartMinute
        let endMinutes = scheduleEndHour * 60 + scheduleEndMinute

        // Handle midnight wraparound (e.g. start=22:00, end=06:00)
        if startMinutes <= endMinutes {
            // Normal case: start and end on same day
            return currentMinutes >= startMinutes && currentMinutes < endMinutes
        } else {
            // Wraparound case: schedule crosses midnight
            return currentMinutes >= startMinutes || currentMinutes < endMinutes
        }
    }
}

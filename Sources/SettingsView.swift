import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager

    // Break interval state
    @State private var intervalValue: Int = 20
    @State private var intervalUnit: IntervalUnit = .minutes

    // Break duration state
    @State private var durationValue: Int = 20
    @State private var durationUnit: DurationUnit = .seconds

    enum IntervalUnit: String, CaseIterable {
        case minutes
        case hours

        var displayName: String {
            rawValue.capitalized
        }
    }

    enum DurationUnit: String, CaseIterable {
        case seconds
        case minutes

        var displayName: String {
            rawValue.capitalized
        }
    }

    var body: some View {
        Form {
            Section("General") {
                Toggle("Launch at Login", isOn: $settingsManager.launchAtLogin)
            }

            Section("Break Timing") {
                LabeledContent("Break every") {
                    HStack(spacing: 8) {
                        TextField("", value: $intervalValue, formatter: NumberFormatter())
                            .frame(width: 50)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)

                        Picker("", selection: $intervalUnit) {
                            ForEach(IntervalUnit.allCases, id: \.self) { unit in
                                Text(unit.displayName).tag(unit)
                            }
                        }
                        .labelsHidden()
                        .fixedSize()
                    }
                }

                LabeledContent("Break duration") {
                    HStack(spacing: 8) {
                        TextField("", value: $durationValue, formatter: NumberFormatter())
                            .frame(width: 50)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)

                        Picker("", selection: $durationUnit) {
                            ForEach(DurationUnit.allCases, id: \.self) { unit in
                                Text(unit.displayName).tag(unit)
                            }
                        }
                        .labelsHidden()
                        .fixedSize()
                    }
                }
            }

            Section {
                Toggle("Only run during scheduled hours", isOn: $settingsManager.scheduleEnabled)

                if settingsManager.scheduleEnabled {
                    LabeledContent("From") {
                        HStack(spacing: 4) {
                            Picker("Hour", selection: $settingsManager.scheduleStartHour) {
                                ForEach(0..<24, id: \.self) { hour in
                                    Text(formatHour(hour)).tag(hour)
                                }
                            }
                            .labelsHidden()
                            .fixedSize()

                            Picker("Minute", selection: $settingsManager.scheduleStartMinute) {
                                Text(":00").tag(0)
                                Text(":15").tag(15)
                                Text(":30").tag(30)
                                Text(":45").tag(45)
                            }
                            .labelsHidden()
                            .fixedSize()
                        }
                    }

                    LabeledContent("To") {
                        HStack(spacing: 4) {
                            Picker("Hour", selection: $settingsManager.scheduleEndHour) {
                                ForEach(0..<24, id: \.self) { hour in
                                    Text(formatHour(hour)).tag(hour)
                                }
                            }
                            .labelsHidden()
                            .fixedSize()

                            Picker("Minute", selection: $settingsManager.scheduleEndMinute) {
                                Text(":00").tag(0)
                                Text(":15").tag(15)
                                Text(":30").tag(30)
                                Text(":45").tag(45)
                            }
                            .labelsHidden()
                            .fixedSize()
                        }
                    }
                }
            } header: {
                Text("Schedule")
            } footer: {
                if settingsManager.scheduleEnabled {
                    Text("Breaks will only trigger during this time window")
                }
            }
            .animation(.default, value: settingsManager.scheduleEnabled)

            Section("Sound") {
                Toggle("Play sound effects", isOn: $settingsManager.soundEnabled)
            }
        }
        .formStyle(.grouped)
        .frame(width: 420)
        .fixedSize(horizontal: false, vertical: true)
        .onAppear {
            // Initialize interval value and unit from breakIntervalSeconds
            let intervalSeconds = settingsManager.breakIntervalSeconds
            if intervalSeconds >= 3600 && intervalSeconds % 3600 == 0 {
                intervalValue = intervalSeconds / 3600
                intervalUnit = .hours
            } else {
                intervalValue = intervalSeconds / 60
                intervalUnit = .minutes
            }

            // Initialize duration value and unit from breakDuration
            let durationSeconds = settingsManager.breakDuration
            if durationSeconds >= 60 && durationSeconds % 60 == 0 {
                durationValue = durationSeconds / 60
                durationUnit = .minutes
            } else {
                durationValue = durationSeconds
                durationUnit = .seconds
            }
        }
        .onChange(of: intervalValue) { _ in
            updateBreakInterval()
        }
        .onChange(of: intervalUnit) { _ in
            updateBreakInterval()
        }
        .onChange(of: durationValue) { _ in
            updateBreakDuration()
        }
        .onChange(of: durationUnit) { _ in
            updateBreakDuration()
        }
    }

    private func formatHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) ?? Date()
        return formatter.string(from: date)
    }

    private func updateBreakInterval() {
        // Calculate seconds based on value and unit
        let seconds: Int
        switch intervalUnit {
        case .minutes:
            seconds = intervalValue * 60
        case .hours:
            seconds = intervalValue * 3600
        }

        // Clamp between 1 minute (60s) and 2 hours (7200s)
        let clampedSeconds = max(60, min(7200, seconds))
        settingsManager.breakIntervalSeconds = clampedSeconds

        // Update local state if clamping occurred
        if clampedSeconds != seconds {
            if intervalUnit == .minutes {
                intervalValue = clampedSeconds / 60
            } else {
                intervalValue = clampedSeconds / 3600
            }
        }
    }

    private func updateBreakDuration() {
        // Calculate seconds based on value and unit
        let seconds: Int
        switch durationUnit {
        case .seconds:
            seconds = durationValue
        case .minutes:
            seconds = durationValue * 60
        }

        // Clamp between 5 seconds and 600 seconds (10 minutes)
        let clampedSeconds = max(5, min(600, seconds))
        settingsManager.breakDuration = clampedSeconds

        // Update local state if clamping occurred
        if clampedSeconds != seconds {
            if durationUnit == .seconds {
                durationValue = clampedSeconds
            } else {
                durationValue = clampedSeconds / 60
            }
        }
    }
}

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        Form {
            Section("General") {
                Toggle("Launch at Login", isOn: $settingsManager.launchAtLogin)
            }

            Section("Break Timing") {
                LabeledContent("Break every") {
                    Stepper(
                        "\(settingsManager.breakIntervalMinutes) minutes",
                        value: $settingsManager.breakIntervalMinutes,
                        in: 1...120,
                        step: 5
                    )
                    .fixedSize()
                }

                LabeledContent("Break duration") {
                    Stepper(
                        "\(settingsManager.breakDuration) seconds",
                        value: $settingsManager.breakDuration,
                        in: 5...120,
                        step: 5
                    )
                    .fixedSize()
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
    }

    private func formatHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) ?? Date()
        return formatter.string(from: date)
    }
}

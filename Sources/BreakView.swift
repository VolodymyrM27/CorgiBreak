import SwiftUI

struct BreakView: View {
    @ObservedObject var timerManager: TimerManager

    var progress: Double {
        timerManager.breakTimeRemaining / 20.0
    }

    var body: some View {
        ZStack {
            VisualEffectView(material: .fullScreenUI, blendingMode: .behindWindow)
                .ignoresSafeArea()

            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Time to rest your eyes")
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Look at something 20 feet away")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))

                PixelCorgi()
                    .frame(width: 192, height: 192)
                    .padding(.vertical, 8)

                ZStack {
                    Circle()
                        .stroke(.white.opacity(0.15), lineWidth: 6)
                        .frame(width: 120, height: 120)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(.white.opacity(0.8), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: progress)

                    Text("\(Int(timerManager.breakTimeRemaining))")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                }

                Button(action: { timerManager.skipBreak() }) {
                    Text("Skip")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.horizontal, 28)
                        .padding(.vertical, 10)
                        .background(.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)

                Text("or press Esc")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(.white.opacity(0.3))
            }
        }
    }
}

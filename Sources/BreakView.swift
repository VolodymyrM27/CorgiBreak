import SwiftUI

struct BreakView: View {
    @ObservedObject var timerManager: TimerManager
    var topSafeArea: CGFloat = 0
    var bottomSafeArea: CGFloat = 0

    var progress: Double {
        timerManager.breakTimeRemaining / 20.0
    }

    var body: some View {
        ZStack {
            VisualEffectView(material: .fullScreenUI, blendingMode: .behindWindow)
                .ignoresSafeArea()

            Color.black.opacity(0.3)
                .ignoresSafeArea()

            GeometryReader { geo in
                let usableHeight = geo.size.height - topSafeArea - bottomSafeArea
                let nonCorgiContent: CGFloat = 350
                let corgiFrameHeight = min(576, max(200, usableHeight - nonCorgiContent))
                let compressionFactor = min(1.0, usableHeight / 950)
                let spacing = max(8, 24 * compressionFactor)

                VStack(spacing: spacing) {
                    Text("Time to rest your eyes")
                        .font(.system(size: 34, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text("Look at something 20 feet away")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    PixelCorgi()
                        .frame(width: 192, height: 192)
                        .scaleEffect(3.0)
                        .frame(width: 576, height: corgiFrameHeight)
                        .clipped()

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
                .padding(.top, topSafeArea)
                .padding(.bottom, bottomSafeArea)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

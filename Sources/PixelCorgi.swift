import SwiftUI
import AppKit

struct PixelCorgi: View {
    @State private var currentFrameIndex = 0
    @State private var bounceOffset: CGFloat = 0
    @State private var animationIndex: Int = 0

    private let animationTimer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()

    private static let animations: [(name: String, count: Int)] = [
        ("jump", 10), ("idle1", 5), ("idle2", 5), ("sit", 9),
        ("walk", 5), ("run", 8), ("sniff", 8), ("sniffwalk", 8),
    ]

    static let allFrames: [[NSImage]] = {
        animations.map { anim in
            (0..<anim.count).compactMap { i in
                guard let url = Bundle.main.url(forResource: "\(anim.name)_\(i)", withExtension: "png"),
                      let image = NSImage(contentsOf: url) else { return nil }
                return image
            }
        }
    }()

    private var currentAnimation: [NSImage] {
        guard animationIndex < Self.allFrames.count else { return [] }
        return Self.allFrames[animationIndex]
    }

    var body: some View {
        Group {
            let frames = currentAnimation
            if !frames.isEmpty {
                Image(nsImage: frames[currentFrameIndex % frames.count])
                    .interpolation(.none)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .offset(y: bounceOffset)
        .onAppear {
            animationIndex = Int.random(in: 0..<Self.animations.count)
            currentFrameIndex = 0
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                bounceOffset = -8
            }
        }
        .onReceive(animationTimer) { _ in
            let frames = currentAnimation
            guard !frames.isEmpty else { return }
            currentFrameIndex = (currentFrameIndex + 1) % frames.count
        }
    }
}

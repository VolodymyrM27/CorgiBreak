import SwiftUI
import AppKit

struct PixelCorgi: View {
    @State private var currentFrameIndex = 0
    @State private var bounceOffset: CGFloat = 0
    @State private var animationIndex: Int = Int.random(in: 0..<8)

    private let animationTimer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()

    // Grid lines detected from the sprite sheet
    private static let vLines = [96, 159, 223, 287, 351, 415, 479, 543, 607, 671, 735, 799]
    private static let hLines = [0, 63, 127, 191, 255, 319, 383, 447, 511]
    private static let frameCounts = [10, 5, 5, 9, 5, 8, 8, 8]

    static let allFrames: [[NSImage]] = {
        guard let url = Bundle.main.url(forResource: "corgi-asset", withExtension: "png"),
              let source = NSImage(contentsOf: url),
              let cgImage = source.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return []
        }

        let inset = 2
        return (0..<8).map { row in
            let y = hLines[row] + inset
            let h = hLines[row + 1] - hLines[row] - inset * 2
            var frames: [NSImage] = []
            for col in 0..<frameCounts[row] {
                let x = vLines[col] + inset
                let w = vLines[col + 1] - vLines[col] - inset * 2
                let rect = CGRect(x: x, y: y, width: w, height: h)
                if let cropped = cgImage.cropping(to: rect) {
                    let frame = NSImage(cgImage: cropped, size: NSSize(width: w, height: h))
                    frames.append(frame)
                }
            }
            return frames
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
            animationIndex = Int.random(in: 0..<Self.frameCounts.count)
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

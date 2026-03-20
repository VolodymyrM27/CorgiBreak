import SwiftUI

struct PixelCorgi: View {
    @State private var isBlinking = false
    @State private var bounceOffset: CGFloat = 0
    @State private var tailFrame = 0

    private let blinkTimer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    private let tailTimer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()

    // Pixel colors
    static let palette: [Character: Color] = [
        ".": .clear,
        "o": Color(red: 0.91, green: 0.58, blue: 0.29),  // orange body
        "t": Color(red: 0.96, green: 0.76, blue: 0.49),   // tan / light
        "w": .white,                                        // white patches
        "k": Color(red: 0.15, green: 0.15, blue: 0.15),   // black (eyes/nose)
        "p": Color(red: 1.0, green: 0.5, blue: 0.55),     // pink tongue
        "b": Color(red: 0.75, green: 0.45, blue: 0.20),   // brown accents
        "e": Color(red: 0.20, green: 0.20, blue: 0.20),   // ear outline
    ]

    // Frame: eyes open
    static let eyesOpen: [String] = [
        "................",  //  0
        "..bo........bo..",  //  1 ear tips
        ".boob......boob.",  //  2 ears
        ".oooooooooooooo.",  //  3 head top
        "oottttttttttttoo",  //  4 forehead
        "ottkkttttttkktto",  //  5 eyes
        "otttttttttttttto",  //  6 cheeks
        ".otttttkkttttto.",  //  7 nose
        "..ottttpptttto..",  //  8 tongue
        "...oottttttoo...",  //  9 chin
        "....oooooooo....",  // 10 neck
        "...oooooooooo...",  // 11 body
        "..oowoooooowoo..",  // 12 white chest
        "..owwoooooowwoo.",  // 13 lower body
        "...ww......ww...",  // 14 legs
        "...oo......oo...",  // 15 paws
    ]

    // Frame: eyes closed (blink)
    static let eyesClosed: [String] = [
        "................",
        "..bo........bo..",
        ".boob......boob.",
        ".oooooooooooooo.",
        "oottttttttttttoo",
        "ottbbttttttbbtto",  // closed eyes (brown lines)
        "otttttttttttttto",
        ".otttttkkttttto.",
        "..ottttpptttto..",
        "...oottttttoo...",
        "....oooooooo....",
        "...oooooooooo...",
        "..oowoooooowoo..",
        "..owwoooooowwoo.",
        "...ww......ww...",
        "...oo......oo...",
    ]

    var currentFrame: [String] {
        isBlinking ? Self.eyesClosed : Self.eyesOpen
    }

    var body: some View {
        Canvas { context, size in
            let frame = currentFrame
            let rows = frame.count
            let cols = frame.first?.count ?? 0
            guard rows > 0, cols > 0 else { return }

            let pixelW = size.width / CGFloat(cols)
            let pixelH = size.height / CGFloat(rows)
            let px = min(pixelW, pixelH)

            let totalW = px * CGFloat(cols)
            let totalH = px * CGFloat(rows)
            let offsetX = (size.width - totalW) / 2
            let offsetY = (size.height - totalH) / 2

            for (r, row) in frame.enumerated() {
                for (c, char) in row.enumerated() {
                    guard let color = Self.palette[char], char != "." else { continue }
                    let rect = CGRect(
                        x: offsetX + CGFloat(c) * px,
                        y: offsetY + CGFloat(r) * px,
                        width: px + 0.5, // slight overlap to avoid gaps
                        height: px + 0.5
                    )
                    context.fill(Path(rect), with: .color(color))
                }
            }
        }
        .offset(y: bounceOffset)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                bounceOffset = -8
            }
        }
        .onReceive(blinkTimer) { _ in
            isBlinking = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                isBlinking = false
            }
        }
    }
}

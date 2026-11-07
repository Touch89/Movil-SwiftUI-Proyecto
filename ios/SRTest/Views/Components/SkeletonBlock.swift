import SwiftUI

struct SkeletonBlock: View {
    var cornerRadius: CGFloat = 6

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private static let stops: [Gradient.Stop] = [
        .init(color: Color(hex: 0x222831), location: 0.3),
        .init(color: Color(hex: 0x2C343E), location: 0.5),
        .init(color: Color(hex: 0x222831), location: 0.7),
    ]

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { context in
            let progress: Double = reduceMotion
                ? 0
                : context.date.timeIntervalSinceReferenceDate
                    .truncatingRemainder(dividingBy: 1.4) / 1.4
            // El degradado mide 4 veces el bloque (`background-size: 400%`) y se desplaza a través de él.
            let start = -3 + 3 * progress

            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        stops: Self.stops,
                        startPoint: UnitPoint(x: start, y: 0.5),
                        endPoint: UnitPoint(x: start + 4, y: 0.5)
                    )
                )
        }
    }
}

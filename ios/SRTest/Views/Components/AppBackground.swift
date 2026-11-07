import SwiftUI

struct AppBackground: View {
    var body: some View {
        Theme.background
            .overlay {
                RadialGradient(
                    colors: [Color(hex: 0x2B6B9F, opacity: 0.3), Color(hex: 0x2B6B9F, opacity: 0)],
                    center: UnitPoint(x: 0.5, y: -0.2),
                    startRadius: 0,
                    endRadius: 430
                )
            }
            .overlay(alignment: .topTrailing) {
                ambientGlow(Color(hex: 0x34A8FF))
                    .offset(x: 176, y: -192)
            }
            .overlay(alignment: .bottomLeading) {
                ambientGlow(Color(hex: 0xD9A627))
                    .offset(x: -192, y: 256)
            }
            .overlay {
                Theme.background.opacity(0.82)
            }
            .clipped()
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }

    private func ambientGlow(_ color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: 448, height: 448)
            .blur(radius: 120)
            .opacity(0.14)
    }
}

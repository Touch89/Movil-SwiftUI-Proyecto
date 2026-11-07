import SwiftUI

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

extension LinearGradient {
    /// Traduce el ángulo de `linear-gradient(<deg>, ...)`: 0° apunta hacia arriba, en sentido horario.
    init(cssAngle degrees: Double, colors: [Color]) {
        let radians = degrees * .pi / 180
        let dx = sin(radians) / 2
        let dy = -cos(radians) / 2
        self.init(
            colors: colors,
            startPoint: UnitPoint(x: 0.5 - dx, y: 0.5 - dy),
            endPoint: UnitPoint(x: 0.5 + dx, y: 0.5 + dy)
        )
    }
}

enum Theme {
    static let background = Color(hex: 0x07090D)
    static let textPrimary = Color(hex: 0xF4F7FB)
    static let textSecondary = Color(hex: 0x858E99)
    static let gold = Color(hex: 0xD9AF50)
    static let blue = Color(hex: 0x54C6FF)
    static let hairline = Color.white.opacity(0.07)
}

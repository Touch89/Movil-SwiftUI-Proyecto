import SwiftUI

struct StateCard: View {
    var systemImage: String?
    let title: String
    let message: String
    var topPadding: CGFloat = 64
    var onRetry: (() -> Void)?

    static func error(message: String, onRetry: @escaping () -> Void) -> StateCard {
        StateCard(
            systemImage: "waveform.path.ecg",
            title: "Fuera de ruta",
            message: "\(message) Revisa tu conexión e inténtalo de nuevo.",
            onRetry: onRetry
        )
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 22)

        VStack(spacing: 0) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 24))
                    .foregroundStyle(Color(hex: 0x65C8FF))
                    .frame(width: 56, height: 56)
                    .background(
                        Color(hex: 0x46B0EB, opacity: 0.1),
                        in: RoundedRectangle(cornerRadius: 18)
                    )
                    .padding(.bottom, 17)
                    .accessibilityHidden(true)
            }

            Text(title)
                .font(.system(size: 21, weight: .bold))
                .tracking(-0.63)
                .foregroundStyle(Theme.textPrimary)

            Text(message)
                .font(.system(size: 13))
                .lineSpacing(4)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(hex: 0x89929E))
                .padding(.top, 8)

            if let onRetry {
                PrimaryButton(
                    title: "Reintentar",
                    systemImage: "arrow.triangle.2.circlepath",
                    action: onRetry
                )
                .padding(.top, 21)
            }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 25)
        .frame(maxWidth: 320)
        .background(Color(hex: 0x12171E, opacity: 0.7), in: shape)
        .overlay {
            shape.strokeBorder(Color(hex: 0x52B0E8, opacity: 0.16), lineWidth: 1)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, topPadding)
    }
}

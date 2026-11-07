import SwiftUI

struct PrimaryButton: View {
    let title: LocalizedStringKey
    let systemImage: String
    var isFullWidth = false
    let action: () -> Void

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 13)

        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .semibold))
                Text(title)
                    .font(.system(size: 13, weight: .bold))
            }
            .foregroundStyle(Color(hex: 0xE8F7FF))
            .padding(.horizontal, 19)
            .frame(maxWidth: isFullWidth ? .infinity : nil, minHeight: 44)
            .background(
                LinearGradient(
                    cssAngle: 135,
                    colors: [Color(hex: 0x258EC7, opacity: 0.78), Color(hex: 0x236291, opacity: 0.78)]
                ),
                in: shape
            )
            .overlay {
                shape.strokeBorder(Color(hex: 0x62C4F8, opacity: 0.35), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

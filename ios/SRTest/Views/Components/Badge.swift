import SwiftUI

struct Badge: View {
    let text: String

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 5)

        Text(verbatim: text)
            .font(.system(size: 8, weight: .heavy))
            .tracking(0.8)
            .foregroundStyle(Color(hex: 0xDCB761))
            .padding(.vertical, 3)
            .padding(.horizontal, 6)
            .background(Color(hex: 0xDDAE4A, opacity: 0.08), in: shape)
            .overlay {
                shape.strokeBorder(Color(hex: 0xDDAE4A, opacity: 0.3), lineWidth: 1)
            }
    }
}

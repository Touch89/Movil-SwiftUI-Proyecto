import SwiftUI

/// Barra propia y no un `TabView`: Actividad y Perfil aún no existen y deben verse deshabilitadas.
struct AppTabBar: View {
    var body: some View {
        HStack(spacing: 0) {
            TabBarItem(title: "Juegos", systemImage: "gamecontroller", isActive: true)
            TabBarItem(title: "Actividad", systemImage: "waveform.path.ecg", isActive: false)
            TabBarItem(title: "Perfil", systemImage: "person", isActive: false)
        }
        .padding(.horizontal, 20)
        .padding(.top, 9)
        .padding(.bottom, 4)
        .background {
            Color(hex: 0x0B0E13, opacity: 0.9)
                .background(.ultraThinMaterial)
                .ignoresSafeArea(edges: .bottom)
        }
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Theme.hairline)
                .frame(height: 1)
        }
    }
}

private struct TabBarItem: View {
    let title: String
    let systemImage: String
    let isActive: Bool

    private var color: Color {
        isActive ? Color(hex: 0x5BC5FF) : Color(hex: 0x626B76)
    }

    var body: some View {
        Button {} label: {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 19))
                    .frame(height: 24)
                Text(title)
                    .font(.system(size: 10, weight: .semibold))
                Capsule()
                    .fill(isActive ? Color(hex: 0x55C3FF) : .clear)
                    .frame(width: 22, height: 2)
                    .shadow(color: isActive ? Color(hex: 0x55C3FF) : .clear, radius: 4)
            }
            .foregroundStyle(color)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .disabled(!isActive)
        .accessibilityLabel(isActive ? title : "\(title), próximamente")
        .accessibilityAddTraits(isActive ? .isSelected : [])
    }
}

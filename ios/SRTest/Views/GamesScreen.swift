import SwiftUI

struct GamesScreen: View {
    @Environment(CatalogStore.self) private var store

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                AppHeader(
                    count: store.games.value?.count ?? 0,
                    isRefreshing: store.games.isLoading,
                    onRefresh: refresh
                )
                content
                    .padding(.horizontal, 14)
                    .padding(.bottom, 23)
            }
        }
        .scrollIndicators(.hidden)
        .background(AppBackground())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            AppTabBar()
        }
        .navigationTitle("Juegos")
        .toolbar(.hidden, for: .navigationBar)
    }

    @ViewBuilder
    private var content: some View {
        switch store.games {
        case .loading:
            GamesLoadingList()
        case .failure(let message):
            StateCard.error(message: message, onRetry: refresh)
        case .success(let games):
            VStack(spacing: 9) {
                ForEach(Array(games.enumerated()), id: \.element.id) { index, game in
                    NavigationLink(value: game) {
                        GameRow(game: game)
                    }
                    .buttonStyle(PressableCardStyle())
                    .accessibilityLabel("Ver categorías de \(game.title)")
                    .modifier(StaggeredEntry(index: index))
                }
            }
        }
    }

    private func refresh() {
        Task { await store.loadGames() }
    }
}

private struct AppHeader: View {
    let count: Int
    let isRefreshing: Bool
    let onRefresh: () -> Void

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 7) {
                    Circle()
                        .fill(Theme.blue)
                        .frame(width: 6, height: 6)
                        .shadow(color: Theme.blue, radius: 6)
                    Text(verbatim: "SPEEDRUN.COM")
                        .font(.system(size: 10, weight: .heavy))
                        .tracking(1.7)
                        .foregroundStyle(Theme.gold)
                }
                .padding(.bottom, 7)

                Text("Juegos")
                    .font(.system(size: 36, weight: .bold))
                    .tracking(-1.6)
                    .foregroundStyle(Theme.textPrimary)

                Text(count > 0 ? "\(count) títulos recientes" : "Explora el catálogo")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(hex: 0x7F8793))
                    .padding(.top, 9)
            }

            Spacer()

            Button(action: onRefresh) {
                SpinningRefreshIcon(isSpinning: isRefreshing)
                    .frame(width: 42, height: 42)
                    .background(Color(hex: 0x13181F, opacity: 0.85), in: Circle())
                    .overlay {
                        Circle().strokeBorder(Color(hex: 0x7E9BB6, opacity: 0.18), lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)
            .disabled(isRefreshing)
            .accessibilityLabel("Actualizar juegos")
        }
        .padding(.horizontal, 22)
        .padding(.top, 26)
        .padding(.bottom, 20)
    }
}

private struct SpinningRefreshIcon: View {
    let isSpinning: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var isAnimating: Bool { isSpinning && !reduceMotion }

    var body: some View {
        TimelineView(.animation(paused: !isAnimating)) { context in
            let turn = context.date.timeIntervalSinceReferenceDate
                .truncatingRemainder(dividingBy: 0.9) / 0.9

            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color(hex: 0xB8C1CA))
                .rotationEffect(.degrees(isAnimating ? turn * 360 : 0))
        }
    }
}

private struct GameRow: View {
    let game: Game

    var body: some View {
        HStack(spacing: 0) {
            CoverImage(url: game.listCoverURL) {
                CoverFallback()
            }
            .frame(width: 57, height: 73)
            .background(Color(hex: 0x151921))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.32), radius: 8, y: 6)

            VStack(alignment: .leading, spacing: 9) {
                Text(game.title)
                    .font(.system(size: 15, weight: .semibold))
                    .tracking(-0.24)
                    .lineLimit(1)
                    .foregroundStyle(Theme.textPrimary)

                HStack(spacing: 9) {
                    Text(game.releasedText ?? "Sin fecha")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)
                    if game.isRomhack {
                        Badge(text: "ROMHACK")
                    }
                }
            }
            .padding(.leading, 14)
            .padding(.trailing, 12)
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color(hex: 0x69737F))
                .frame(width: 25, height: 25)
                .background(Color.white.opacity(0.035), in: Circle())
        }
        .gameCardStyle()
    }
}

private struct CoverFallback: View {
    var body: some View {
        ZStack {
            Color(hex: 0x11151B)
            LinearGradient(
                cssAngle: 145,
                colors: [Color(hex: 0x26749E, opacity: 0.18), Color(hex: 0xB48727, opacity: 0.13)]
            )
            Image(systemName: "gamecontroller")
                .font(.system(size: 20))
                .foregroundStyle(Color(hex: 0x63788A))
        }
    }
}

private struct GamesLoadingList: View {
    var body: some View {
        VStack(spacing: 9) {
            ForEach(0..<5, id: \.self) { _ in
                HStack(spacing: 0) {
                    SkeletonBlock(cornerRadius: 10)
                        .frame(width: 57, height: 73)

                    VStack(alignment: .leading, spacing: 9) {
                        SkeletonBlock()
                            .frame(maxWidth: 180)
                            .frame(height: 14)
                        SkeletonBlock()
                            .frame(width: 54, height: 9)
                    }
                    .padding(.leading, 14)
                    .padding(.trailing, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .gameCardStyle()
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Cargando juegos")
    }
}

private extension View {
    func gameCardStyle() -> some View {
        let shape = RoundedRectangle(cornerRadius: 17)

        return self
            .padding(.vertical, 9)
            .padding(.leading, 9)
            .padding(.trailing, 12)
            .frame(maxWidth: .infinity, minHeight: 93)
            .background(
                LinearGradient(
                    cssAngle: 110,
                    colors: [Color(hex: 0x1A1F27, opacity: 0.96), Color(hex: 0x0F1218, opacity: 0.94)]
                ),
                in: shape
            )
            .overlay {
                shape.strokeBorder(
                    LinearGradient(
                        cssAngle: 120,
                        colors: [Color(hex: 0xDDAE4A, opacity: 0.35), Color(hex: 0x3D9AD4, opacity: 0.28)]
                    ),
                    lineWidth: 1
                )
            }
            .shadow(color: .black.opacity(0.18), radius: 14, y: 10)
    }
}

private struct PressableCardStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.988 : 1)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}

private struct StaggeredEntry: ViewModifier {
    let index: Int

    @State private var isVisible = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 8)
            .onAppear {
                guard !isVisible else { return }
                if reduceMotion {
                    isVisible = true
                } else {
                    withAnimation(.easeOut(duration: 0.36).delay(Double(index) * 0.035)) {
                        isVisible = true
                    }
                }
            }
    }
}

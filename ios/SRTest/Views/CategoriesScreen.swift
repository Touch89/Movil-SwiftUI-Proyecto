import SwiftUI

struct CategoriesScreen: View {
    let game: Game

    @Environment(CatalogStore.self) private var store
    @State private var state: RequestState<[GameCategory]> = .loading
    @State private var retryCount = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                GameHero(game: game, categoryCount: state.value?.count)
                SectionTitle()
                content
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 46)
        }
        .scrollIndicators(.hidden)
        .background(AppBackground())
        .navigationTitle("Categorías")
        .navigationBarTitleDisplayMode(.inline)
        // Al salir de la pantalla la tarea se cancela, así que una respuesta tardía no pisa el estado.
        .task(id: retryCount) {
            await load(ignoreCache: retryCount > 0)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .loading:
            CategoriesLoadingList()
        case .failure(let message):
            StateCard.error(message: message) { retryCount += 1 }
        case .success(let categories) where categories.isEmpty:
            StateCard(
                title: "Sin categorías",
                message: "Este juego todavía no tiene modalidades publicadas.",
                topPadding: 20
            )
        case .success(let categories):
            VStack(spacing: 8) {
                ForEach(Array(categories.enumerated()), id: \.element.id) { index, category in
                    CategoryRow(number: index + 1, category: category)
                }
            }
        }
    }

    private func load(ignoreCache: Bool) async {
        state = .loading
        do {
            state = .success(try await store.categories(for: game, ignoreCache: ignoreCache))
        } catch {
            guard !Task.isCancelled else { return }
            state = .failure(message: SpeedrunAPI.message(for: error))
        }
    }
}

private struct GameHero: View {
    let game: Game
    let categoryCount: Int?

    private var countText: String {
        categoryCount.map { "\($0) categorías" } ?? "Speedrun"
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 24)

        HStack(alignment: .bottom, spacing: 17) {
            CoverImage(url: game.heroCoverURL) {
                Image(systemName: "gamecontroller")
                    .font(.system(size: 24))
                    .foregroundStyle(Color(hex: 0x7290A5))
            }
            .frame(width: 88, height: 116)
            .background(Color(hex: 0x171C23))
            .clipShape(RoundedRectangle(cornerRadius: 13))
            .overlay {
                RoundedRectangle(cornerRadius: 13)
                    .strokeBorder(Color.white.opacity(0.22), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.42), radius: 15, y: 15)
            .accessibilityElement()
            .accessibilityLabel("Portada de \(game.title)")

            VStack(alignment: .leading, spacing: 0) {
                Text(game.releasedText ?? "Fecha desconocida")
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(1.4)
                    .foregroundStyle(Color(hex: 0xD8AE4F))
                    .padding(.bottom, 5)

                Text(game.title)
                    .font(.system(size: 22, weight: .bold))
                    .tracking(-0.77)
                    .lineLimit(2)
                    .foregroundStyle(Theme.textPrimary)

                Text(countText)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color(hex: 0x939DAA))
                    .padding(.top, 9)
            }
            .padding(.bottom, 3)
        }
        .padding(.horizontal, 19)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, minHeight: 220, alignment: .bottomLeading)
        .background {
            ZStack {
                Color(hex: 0x12171E)

                CoverImage(url: game.heroCoverURL) {
                    EmptyView()
                }
                .scaleEffect(1.6)
                .blur(radius: 28)
                .saturation(0.8)
                .opacity(0.44)

                LinearGradient(
                    colors: [Color(hex: 0x070A0E, opacity: 0.87), Color(hex: 0x070A0E, opacity: 0.35)],
                    startPoint: .leading,
                    endPoint: .trailing
                )

                LinearGradient(
                    stops: [
                        .init(color: Color(hex: 0x070A0E, opacity: 0.82), location: 0),
                        .init(color: Color(hex: 0x070A0E, opacity: 0), location: 0.7),
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
            }
            .accessibilityHidden(true)
        }
        .clipShape(shape)
        .overlay {
            shape.strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
        }
    }
}

private struct SectionTitle: View {
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 5) {
                Text(verbatim: "MODALIDADES")
                    .font(.system(size: 9, weight: .heavy))
                    .tracking(1.44)
                    .foregroundStyle(Color(hex: 0x4D9DCC))

                Text("Elige una categoría")
                    .font(.system(size: 20, weight: .bold))
                    .tracking(-0.6)
                    .foregroundStyle(Color(hex: 0xEEF2F6))
            }

            Spacer()

            Image(systemName: "sparkles")
                .font(.system(size: 18))
                .foregroundStyle(Color(hex: 0xD3AC56))
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 5)
        .padding(.top, 30)
        .padding(.bottom, 14)
    }
}

private struct CategoryRow: View {
    let number: Int
    let category: GameCategory

    var body: some View {
        HStack(spacing: 0) {
            Text(String(format: "%02d", number))
                .font(.system(size: 11, weight: .bold))
                .monospacedDigit()
                .tracking(0.66)
                .foregroundStyle(Color(hex: 0xB89243))
                .frame(width: 35, alignment: .leading)

            VStack(alignment: .leading, spacing: 5) {
                Text(category.name)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)
                    .foregroundStyle(Theme.textPrimary)

                Text(category.isMiscellaneous ? "Categoría miscelánea" : "Categoría principal")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Color(hex: 0x737D89))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if category.isMiscellaneous {
                Badge(text: "MISC")
                    .padding(.leading, 8)
            }
        }
        .categoryRowStyle()
        .accessibilityElement(children: .combine)
    }
}

private struct CategoriesLoadingList: View {
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { _ in
                HStack(spacing: 15) {
                    SkeletonBlock()
                        .frame(width: 20, height: 10)
                    SkeletonBlock()
                        .frame(width: 130, height: 13)
                    Spacer(minLength: 0)
                }
                .categoryRowStyle()
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Cargando categorías")
    }
}

private extension View {
    func categoryRowStyle() -> some View {
        let shape = RoundedRectangle(cornerRadius: 15)

        return self
            .padding(.vertical, 13)
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity, minHeight: 70)
            .background(
                LinearGradient(
                    cssAngle: 100,
                    colors: [Color(hex: 0x171C23, opacity: 0.93), Color(hex: 0x0F1319, opacity: 0.93)]
                ),
                in: shape
            )
            .overlay {
                shape.strokeBorder(Color.white.opacity(0.06), lineWidth: 1)
            }
    }
}

import SwiftUI

/// Imagen remota que rellena su marco sin alterar el layout (`object-fit: cover`).
struct CoverImage<Fallback: View>: View {
    private let url: URL?
    private let fallback: Fallback

    init(url: URL?, @ViewBuilder fallback: () -> Fallback) {
        self.url = url
        self.fallback = fallback()
    }

    var body: some View {
        Color.clear
            .overlay {
                if let url {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            fallback
                        default:
                            Color.clear
                        }
                    }
                } else {
                    fallback
                }
            }
            .clipped()
    }
}

import SwiftUI

struct ContentView: View {
    @Environment(CatalogStore.self) private var store

    var body: some View {
        NavigationStack {
            GamesScreen()
                .navigationDestination(for: Game.self) { game in
                    CategoriesScreen(game: game)
                }
        }
        // Va fuera del stack: dentro, se repetiría cada vez que se vuelve a la lista.
        .task {
            await store.loadGames()
        }
    }
}

#Preview {
    ContentView()
        .environment(CatalogStore())
        .preferredColorScheme(.dark)
}

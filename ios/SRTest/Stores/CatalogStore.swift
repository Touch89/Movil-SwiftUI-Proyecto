import Observation

@MainActor
@Observable
final class CatalogStore {
    private(set) var games: RequestState<[Game]> = .loading

    @ObservationIgnored private var categoryCache: [Game.ID: [GameCategory]] = [:]
    private let api = SpeedrunAPI()

    func loadGames() async {
        games = .loading
        do {
            games = .success(try await api.recentGames())
        } catch {
            guard !Task.isCancelled else { return }
            games = .failure(message: SpeedrunAPI.message(for: error))
        }
    }

    func categories(for game: Game, ignoreCache: Bool) async throws -> [GameCategory] {
        if !ignoreCache, let cached = categoryCache[game.id] {
            return cached
        }
        let categories = try await api.categories(gameID: game.id)
        categoryCache[game.id] = categories
        return categories
    }
}

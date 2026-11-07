import Foundation

struct SpeedrunAPI {
    private enum APIError: Error {
        case badStatus
    }

    private struct Envelope<Payload: Decodable>: Decodable {
        let data: Payload
    }

    private static let baseURL = URL(string: "https://www.speedrun.com/api/v1")!

    /// `timeoutIntervalForResource` limita la petición completa a 5 segundos,
    /// igual que el `AbortController` de la versión web.
    private static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        return URLSession(configuration: configuration)
    }()

    func recentGames() async throws -> [Game] {
        let url = Self.baseURL
            .appending(path: "games")
            .appending(queryItems: [
                URLQueryItem(name: "orderby", value: "released"),
                URLQueryItem(name: "direction", value: "desc"),
                URLQueryItem(name: "max", value: "20"),
            ])
        let games: [Game] = try await getJSON(url)
        return games.sorted { ($0.released ?? 0) > ($1.released ?? 0) }
    }

    func categories(gameID: String) async throws -> [GameCategory] {
        try await getJSON(Self.baseURL.appending(path: "games/\(gameID)/categories"))
    }

    static func message(for error: Error) -> String {
        if let urlError = error as? URLError, urlError.code == .timedOut {
            return "La consulta tardó más de 5 segundos."
        }
        return "No pudimos conectar con Speedrun.com."
    }

    private func getJSON<Payload: Decodable>(_ url: URL) async throws -> Payload {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await Self.session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw APIError.badStatus
        }
        return try JSONDecoder().decode(Envelope<Payload>.self, from: data).data
    }
}

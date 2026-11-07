import Foundation

struct Game: Identifiable, Hashable, Decodable {
    struct Names: Hashable, Decodable {
        let international: String
    }

    struct Asset: Hashable, Decodable {
        let uri: String?
    }

    struct Assets: Hashable, Decodable {
        let coverMedium: Asset?
        let coverLarge: Asset?

        enum CodingKeys: String, CodingKey {
            case coverMedium = "cover-medium"
            case coverLarge = "cover-large"
        }
    }

    let id: String
    let names: Names
    let released: Int?
    let romhack: Bool?
    let assets: Assets?

    var title: String { names.international }
    var isRomhack: Bool { romhack ?? false }

    /// Texto ya formateado: interpolar el `Int` en un `Text` mostraría "2,024".
    var releasedText: String? { released.map { String($0) } }

    var listCoverURL: URL? {
        Self.url(from: assets?.coverMedium?.uri ?? assets?.coverLarge?.uri)
    }

    var heroCoverURL: URL? {
        Self.url(from: assets?.coverLarge?.uri ?? assets?.coverMedium?.uri)
    }

    private static func url(from string: String?) -> URL? {
        string.flatMap { URL(string: $0) }
    }
}

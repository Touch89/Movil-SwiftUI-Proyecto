import Foundation

/// No se llama `Category` porque ese nombre ya existe en el módulo ObjectiveC.
struct GameCategory: Identifiable, Hashable, Decodable {
    let id: String
    let name: String
    let miscellaneous: Bool?

    var isMiscellaneous: Bool { miscellaneous ?? false }
}

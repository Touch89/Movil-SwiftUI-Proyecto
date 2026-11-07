import Foundation

/// Credenciales de prueba escritas en la app: esto no es seguridad real.
/// Debe sustituirse por una validación en servidor antes de publicar.
enum AuthService {
    private static let testUsername = "admin"
    private static let testPassword = "123"

    static func isValid(username: String, password: String) -> Bool {
        username.trimmingCharacters(in: .whitespacesAndNewlines) == testUsername
            && password == testPassword
    }
}

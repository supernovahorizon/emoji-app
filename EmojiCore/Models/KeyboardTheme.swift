import Foundation

/// Visual theme identifier for keyboard chrome (not emoji artwork).
public struct KeyboardTheme: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let name: String
    public let isDefault: Bool

    public init(id: String, name: String, isDefault: Bool = false) {
        self.id = id
        self.name = name
        self.isDefault = isDefault
    }

    /// KATSEYE-inspired: deep night black + dreamy pink (EYEKON vibes).
    public static let katseye = KeyboardTheme(id: "katseye", name: "KATSEYE", isDefault: true)
    public static let system = KeyboardTheme(id: "system", name: "System")
    public static let soft = KeyboardTheme(id: "soft", name: "Soft")
    public static let highContrast = KeyboardTheme(id: "highContrast", name: "High Contrast")

    public static let all: [KeyboardTheme] = [.katseye, .system, .soft, .highContrast]

    public static func resolve(id: String?) -> KeyboardTheme {
        guard let id else { return .katseye }
        return all.first(where: { $0.id == id }) ?? .katseye
    }
}

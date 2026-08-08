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

    /// Pastel gem / KATSEYE personal theme (asset kit V2).
    public static let katseyePastel = KeyboardTheme(id: "katseye.pastel", name: "KATSEYE Pastel", isDefault: true)
    /// Legacy alias id still resolved for saved preferences.
    public static let katseye = KeyboardTheme(id: "katseye", name: "KATSEYE (legacy)")
    public static let system = KeyboardTheme(id: "system", name: "System")
    public static let soft = KeyboardTheme(id: "soft", name: "Soft")
    public static let highContrast = KeyboardTheme(id: "highContrast", name: "High Contrast")

    public static let all: [KeyboardTheme] = [.katseyePastel, .system, .soft, .highContrast]

    public static func resolve(id: String?) -> KeyboardTheme {
        guard let id else { return .katseyePastel }
        if id == "katseye" || id == "system" || id == "pastelGem" {
            return .katseyePastel
        }
        return all.first(where: { $0.id == id }) ?? .katseyePastel
    }

    public var isKatseyeFamily: Bool {
        id == KeyboardTheme.katseyePastel.id || id == KeyboardTheme.katseye.id || id == "pastelGem"
    }
}

/// Which background image family to load for KATSEYE pastel.
/// Personal photo is for local builds; abstract is store-safer.
public enum KatseyeBackgroundVariant: String, Codable, Sendable, CaseIterable {
    case personalPhoto
    case abstractPastel

    /// Personal local builds use the real reference photo background.
    public static let current: KatseyeBackgroundVariant = .personalPhoto

    public var imageAssetName: String {
        switch self {
        case .personalPhoto: return "KatseyePhotoBackground"
        case .abstractPastel: return "KatseyeAbstractBackground"
        }
    }
}

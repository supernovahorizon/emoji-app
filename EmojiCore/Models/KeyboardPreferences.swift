import Foundation

/// Local product preferences only — never typed content.
public struct KeyboardPreferences: Hashable, Codable, Sendable {
    public var favoriteIds: [String]
    public var recentIds: [String]
    public var selectedCategoryId: String?
    public var themeId: String

    public static let recentLimit = 24

    public init(
        favoriteIds: [String] = [],
        recentIds: [String] = [],
        selectedCategoryId: String? = nil,
        themeId: String = KeyboardTheme.system.id
    ) {
        self.favoriteIds = favoriteIds
        self.recentIds = recentIds
        self.selectedCategoryId = selectedCategoryId
        self.themeId = themeId
    }

    public var theme: KeyboardTheme {
        KeyboardTheme.resolve(id: themeId)
    }

    public mutating func toggleFavorite(id: String) {
        if let index = favoriteIds.firstIndex(of: id) {
            favoriteIds.remove(at: index)
        } else {
            favoriteIds.append(id)
        }
    }

    public mutating func addRecent(id: String, limit: Int = KeyboardPreferences.recentLimit) {
        recentIds.removeAll { $0 == id }
        recentIds.insert(id, at: 0)
        if recentIds.count > limit {
            recentIds = Array(recentIds.prefix(limit))
        }
    }

    public func isFavorite(_ id: String) -> Bool {
        favoriteIds.contains(id)
    }
}

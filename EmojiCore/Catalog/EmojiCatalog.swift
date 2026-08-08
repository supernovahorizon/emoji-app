import Foundation

/// Versioned emoji catalog payload.
public struct EmojiCatalog: Codable, Sendable, Hashable {
    public let schemaVersion: Int
    public let categories: [EmojiCategory]
    public let items: [EmojiItem]

    public static let supportedSchemaVersion = 1
    public static let fallbackCategoryId = "smileys"

    public init(schemaVersion: Int, categories: [EmojiCategory], items: [EmojiItem]) {
        self.schemaVersion = schemaVersion
        self.categories = categories
        self.items = items
    }

    public var sortedCategories: [EmojiCategory] {
        categories.sorted { $0.sortOrder < $1.sortOrder }
    }

    public func category(id: String) -> EmojiCategory? {
        categories.first { $0.id == id }
    }

    public func items(in categoryId: String) -> [EmojiItem] {
        if categoryId == "favorites" {
            return []
        }
        return items.filter { $0.categoryId == categoryId }
    }

    public func item(id: String) -> EmojiItem? {
        items.first { $0.id == id }
    }

    public func items(ids: [String]) -> [EmojiItem] {
        ids.compactMap { item(id: $0) }
    }

    /// Prefer selected category; otherwise first real category; otherwise smileys fallback id.
    public func resolvedCategoryId(selected: String?) -> String {
        if let selected, category(id: selected) != nil || selected == "favorites" {
            return selected
        }
        if let first = sortedCategories.first(where: { $0.id != "favorites" }) {
            return first.id
        }
        return Self.fallbackCategoryId
    }
}

import Foundation

/// A single emoji entry in the catalog.
public struct EmojiItem: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let glyph: String
    public let name: String
    public let categoryId: String
    public let keywords: [String]

    public init(
        id: String,
        glyph: String,
        name: String,
        categoryId: String,
        keywords: [String] = []
    ) {
        self.id = id
        self.glyph = glyph
        self.name = name
        self.categoryId = categoryId
        self.keywords = keywords
    }
}

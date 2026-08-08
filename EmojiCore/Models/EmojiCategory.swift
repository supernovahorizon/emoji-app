import Foundation

/// A named group of emoji items.
public struct EmojiCategory: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let title: String
    public let symbol: String
    public let sortOrder: Int

    public init(id: String, title: String, symbol: String, sortOrder: Int) {
        self.id = id
        self.title = title
        self.symbol = symbol
        self.sortOrder = sortOrder
    }
}

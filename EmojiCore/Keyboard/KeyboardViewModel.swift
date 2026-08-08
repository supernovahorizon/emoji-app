import Foundation
import Combine

/// Presentation logic for the keyboard UI (UI-framework agnostic).
@MainActor
public final class KeyboardViewModel: ObservableObject {
    @Published public private(set) var catalog: EmojiCatalog
    @Published public private(set) var preferences: KeyboardPreferences
    @Published public var selectedCategoryId: String
    @Published public private(set) var loadFailed: Bool

    private let store: any KeyboardPreferencesStore
    private let input: any TextInputHandling

    public init(
        catalog: EmojiCatalog,
        store: any KeyboardPreferencesStore,
        input: any TextInputHandling,
        loadFailed: Bool = false
    ) {
        self.catalog = catalog
        self.store = store
        self.input = input
        self.loadFailed = loadFailed
        let prefs = store.load()
        self.preferences = prefs
        self.selectedCategoryId = catalog.resolvedCategoryId(selected: prefs.selectedCategoryId)
    }

    public var displayCategories: [EmojiCategory] {
        var list = catalog.sortedCategories
        // Ensure favorites chip exists even if not in JSON
        if !list.contains(where: { $0.id == "favorites" }) {
            list.insert(
                EmojiCategory(id: "favorites", title: "Favorites", symbol: "★", sortOrder: -1),
                at: 0
            )
        }
        return list.sorted { $0.sortOrder < $1.sortOrder }
    }

    public var visibleItems: [EmojiItem] {
        if selectedCategoryId == "favorites" {
            let favs = catalog.items(ids: preferences.favoriteIds)
            if !favs.isEmpty { return favs }
            return catalog.items(ids: preferences.recentIds)
        }
        return catalog.items(in: selectedCategoryId)
    }

    public func selectCategory(_ id: String) {
        selectedCategoryId = id
        preferences.selectedCategoryId = id
        persist()
    }

    public func insertEmoji(_ item: EmojiItem) {
        input.insertText(item.glyph)
        preferences.addRecent(id: item.id)
        persist()
    }

    public func toggleFavorite(_ item: EmojiItem) {
        preferences.toggleFavorite(id: item.id)
        persist()
    }

    public func deleteBackward() {
        input.deleteBackward()
    }

    public func nextKeyboard() {
        input.advanceToNextInputMode()
    }

    public func setTheme(_ theme: KeyboardTheme) {
        preferences.themeId = theme.id
        persist()
    }

    private func persist() {
        store.save(preferences)
        preferences = store.load()
    }
}

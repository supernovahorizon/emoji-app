import Foundation
import Combine

/// Presentation logic for the keyboard UI (UI-framework agnostic).
@MainActor
public final class KeyboardViewModel: ObservableObject {
    @Published public private(set) var catalog: EmojiCatalog
    @Published public private(set) var preferences: KeyboardPreferences
    @Published public var selectedCategoryId: String
    @Published public private(set) var loadFailed: Bool
    @Published public var panel: KeyboardPanel
    @Published public var shiftState: ShiftState

    private let store: any KeyboardPreferencesStore
    private let input: any TextInputHandling

    public init(
        catalog: EmojiCatalog,
        store: any KeyboardPreferencesStore,
        input: any TextInputHandling,
        loadFailed: Bool = false,
        initialPanel: KeyboardPanel = .letters
    ) {
        self.catalog = catalog
        self.store = store
        self.input = input
        self.loadFailed = loadFailed
        self.panel = initialPanel
        self.shiftState = .off
        let prefs = store.load()
        self.preferences = prefs
        self.selectedCategoryId = catalog.resolvedCategoryId(selected: prefs.selectedCategoryId)
    }

    public var displayCategories: [EmojiCategory] {
        var list = catalog.sortedCategories
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

    /// Whether letter keys should show uppercase glyphs.
    public var isUppercase: Bool {
        shiftState != .off
    }

    public func selectCategory(_ id: String) {
        selectedCategoryId = id
        preferences.selectedCategoryId = id
        persist()
    }

    public func showPanel(_ panel: KeyboardPanel) {
        self.panel = panel
        if panel != .letters {
            shiftState = .off
        }
    }

    public func toggleEmojiPanel() {
        if panel == .emoji {
            showPanel(.letters)
        } else {
            showPanel(.emoji)
        }
    }

    public func cycleShift() {
        switch shiftState {
        case .off:
            shiftState = .once
        case .once:
            shiftState = .locked
        case .locked:
            shiftState = .off
        }
    }

    public func insertKey(_ key: String) {
        var text = key
        if panel == .letters, key.count == 1, key.rangeOfCharacter(from: .letters) != nil {
            text = isUppercase ? key.uppercased() : key.lowercased()
            if shiftState == .once {
                shiftState = .off
            }
        }
        input.insertText(text)
    }

    public func insertSpace() {
        input.insertText(" ")
    }

    public func insertReturn() {
        input.insertText("\n")
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

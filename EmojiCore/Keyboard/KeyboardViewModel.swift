import Foundation
import Combine

/// Presentation logic for the keyboard UI (UI-framework agnostic).
@MainActor
public final class KeyboardViewModel: ObservableObject {
    @Published public private(set) var catalog: EmojiCatalog
    @Published public private(set) var stickerCatalog: KatseyeStickerCatalog
    @Published public private(set) var preferences: KeyboardPreferences
    @Published public var selectedCategoryId: String
    @Published public private(set) var loadFailed: Bool
    @Published public var panel: KeyboardPanel
    @Published public var shiftState: ShiftState
    /// Optional filter inside KATSEYE pack (`nil` = all members).
    @Published public var selectedMemberFilter: String?

    private let store: any KeyboardPreferencesStore
    private let input: any TextInputHandling

    public init(
        catalog: EmojiCatalog,
        store: any KeyboardPreferencesStore,
        input: any TextInputHandling,
        loadFailed: Bool = false,
        initialPanel: KeyboardPanel = .letters,
        stickerCatalog: KatseyeStickerCatalog = KatseyeStickerCatalog(stickers: [])
    ) {
        self.catalog = catalog
        self.stickerCatalog = stickerCatalog
        self.store = store
        self.input = input
        self.loadFailed = loadFailed
        self.panel = initialPanel
        self.shiftState = .off
        self.selectedMemberFilter = nil
        var prefs = store.load()
        let legacy = ["system", "katseye", "pastelGem"]
        if legacy.contains(prefs.themeId) {
            prefs.themeId = KeyboardTheme.katseyePastel.id
            store.save(prefs)
        }
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
        if !list.contains(where: { $0.id == "katseye" }) {
            list.insert(
                EmojiCategory(id: "katseye", title: "KATSEYE", symbol: "💎", sortOrder: 1),
                at: 1
            )
        }
        return list.sorted { $0.sortOrder < $1.sortOrder }
    }

    /// Unicode emoji for non-KATSEYE categories (and favorites of those).
    public var visibleItems: [EmojiItem] {
        if selectedCategoryId == "favorites" {
            let favs = catalog.items(ids: preferences.favoriteIds)
            if !favs.isEmpty { return favs }
            return catalog.items(ids: preferences.recentIds)
        }
        if selectedCategoryId == "katseye" {
            return []
        }
        return catalog.items(in: selectedCategoryId)
    }

    /// Facemoji-style member stickers for the KATSEYE tab.
    public var visibleStickers: [KatseyeSticker] {
        guard selectedCategoryId == "katseye" else { return [] }
        return stickerCatalog.stickers(forMember: selectedMemberFilter)
    }

    public var isKatseyeStickerMode: Bool {
        selectedCategoryId == "katseye" && !stickerCatalog.stickers.isEmpty
    }

    public var isUppercase: Bool {
        shiftState != .off
    }

    public func selectCategory(_ id: String) {
        selectedCategoryId = id
        preferences.selectedCategoryId = id
        if id != "katseye" {
            selectedMemberFilter = nil
        }
        persist()
    }

    public func selectMemberFilter(_ memberId: String?) {
        selectedMemberFilter = memberId
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

    /// Insert a KATSEYE sticker as an **image** on the pasteboard (how it looks in the pack).
    /// We intentionally do **not** insert a plain Unicode smiley — that looked wrong.
    /// Host apps (Notes/Messages) show the sticker after the user pastes (long-press → Paste).
    public func insertSticker(_ sticker: KatseyeSticker, imagePNGData: Data?) {
        if let imagePNGData {
            input.copyImageData(imagePNGData, uti: "public.png")
        }
        preferences.addRecent(id: sticker.id)
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

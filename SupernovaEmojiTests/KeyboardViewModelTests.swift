import XCTest
@testable import SupernovaEmoji

@MainActor
final class KeyboardViewModelTests: XCTestCase {
    private func makeCatalog() -> EmojiCatalog {
        EmojiCatalog(
            schemaVersion: 1,
            categories: [
                EmojiCategory(id: "favorites", title: "Favorites", symbol: "★", sortOrder: 0),
                EmojiCategory(id: "smileys", title: "Smileys", symbol: "😊", sortOrder: 1)
            ],
            items: [
                EmojiItem(id: "a", glyph: "😀", name: "A", categoryId: "smileys"),
                EmojiItem(id: "b", glyph: "😁", name: "B", categoryId: "smileys")
            ]
        )
    }

    func testCategorySelectionPersists() {
        let store = InMemoryPreferencesStore()
        let input = RecordingTextInputHandler()
        let vm = KeyboardViewModel(catalog: makeCatalog(), store: store, input: input)
        vm.selectCategory("smileys")
        XCTAssertEqual(vm.selectedCategoryId, "smileys")
        XCTAssertEqual(store.load().selectedCategoryId, "smileys")
    }

    func testInsertDispatchesAndAddsRecent() {
        let store = InMemoryPreferencesStore()
        let input = RecordingTextInputHandler()
        let vm = KeyboardViewModel(catalog: makeCatalog(), store: store, input: input)
        let item = makeCatalog().items[0]
        vm.insertEmoji(item)
        XCTAssertEqual(input.actions, [.insert("😀")])
        XCTAssertEqual(store.load().recentIds.first, "a")
    }

    func testDeleteAndNextKeyboard() {
        let input = RecordingTextInputHandler()
        let vm = KeyboardViewModel(
            catalog: makeCatalog(),
            store: InMemoryPreferencesStore(),
            input: input
        )
        vm.deleteBackward()
        vm.nextKeyboard()
        XCTAssertEqual(input.actions, [.deleteBackward, .nextKeyboard])
    }

    func testFavoritesCategoryShowsFavorites() {
        let store = InMemoryPreferencesStore(
            initial: KeyboardPreferences(favoriteIds: ["b"])
        )
        let vm = KeyboardViewModel(
            catalog: makeCatalog(),
            store: store,
            input: RecordingTextInputHandler()
        )
        vm.selectCategory("favorites")
        XCTAssertEqual(vm.visibleItems.map(\.id), ["b"])
    }
}

import XCTest
@testable import SupernovaEmoji

final class PreferencesTests: XCTestCase {
    func testFavoritesToggle() {
        var prefs = KeyboardPreferences()
        prefs.toggleFavorite(id: "a")
        XCTAssertTrue(prefs.isFavorite("a"))
        prefs.toggleFavorite(id: "a")
        XCTAssertFalse(prefs.isFavorite("a"))
    }

    func testRecentsBoundedAndOrdered() {
        var prefs = KeyboardPreferences()
        for i in 0..<30 {
            prefs.addRecent(id: "id-\(i)", limit: 24)
        }
        XCTAssertEqual(prefs.recentIds.count, 24)
        XCTAssertEqual(prefs.recentIds.first, "id-29")
        XCTAssertFalse(prefs.recentIds.contains("id-0"))
    }

    func testThemeResolution() {
        XCTAssertEqual(KeyboardTheme.resolve(id: nil).id, KeyboardTheme.system.id)
        XCTAssertEqual(KeyboardTheme.resolve(id: "soft").id, "soft")
        XCTAssertEqual(KeyboardTheme.resolve(id: "nope").id, KeyboardTheme.system.id)
    }

    func testInMemoryStoreRoundTrip() {
        let store = InMemoryPreferencesStore()
        var prefs = KeyboardPreferences()
        prefs.themeId = "soft"
        prefs.toggleFavorite(id: "x")
        store.save(prefs)
        let loaded = store.load()
        XCTAssertEqual(loaded.themeId, "soft")
        XCTAssertTrue(loaded.isFavorite("x"))
        store.reset()
        XCTAssertTrue(store.load().favoriteIds.isEmpty)
    }

    func testLocalPreferencesStoreRoundTrip() {
        let key = "test.prefs.\(UUID().uuidString)"
        let store = LocalPreferencesStore(key: key)
        var prefs = KeyboardPreferences()
        prefs.addRecent(id: "r1")
        store.save(prefs)
        XCTAssertEqual(store.load().recentIds, ["r1"])
        store.reset()
        XCTAssertTrue(store.load().recentIds.isEmpty)
    }

    func testFallbackStore() {
        let primary = InMemoryPreferencesStore(initial: KeyboardPreferences(themeId: "soft"))
        let fallback = InMemoryPreferencesStore(initial: KeyboardPreferences(themeId: "system"))
        let store = FallbackPreferencesStore(primary: primary, fallback: fallback)
        XCTAssertEqual(store.load().themeId, "soft")
        store.forceFallback(true)
        XCTAssertEqual(store.load().themeId, "system")
        store.save(KeyboardPreferences(themeId: "highContrast"))
        XCTAssertEqual(fallback.load().themeId, "highContrast")
    }
}

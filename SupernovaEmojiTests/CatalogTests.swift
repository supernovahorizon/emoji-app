import XCTest
@testable import SupernovaEmoji

final class CatalogTests: XCTestCase {
    func testBundledCatalogLoadsAndValidates() throws {
        let catalog = try EmojiCatalogLoader().loadBundled()
        XCTAssertEqual(catalog.schemaVersion, 1)
        XCTAssertFalse(catalog.items.isEmpty)
        XCTAssertFalse(catalog.categories.isEmpty)
        XCTAssertNotNil(catalog.category(id: "smileys"))
    }

    func testDuplicateItemIdsRejected() throws {
        let catalog = EmojiCatalog(
            schemaVersion: 1,
            categories: [EmojiCategory(id: "smileys", title: "S", symbol: "😊", sortOrder: 1)],
            items: [
                EmojiItem(id: "a", glyph: "😀", name: "A", categoryId: "smileys"),
                EmojiItem(id: "a", glyph: "😁", name: "B", categoryId: "smileys")
            ]
        )
        XCTAssertThrowsError(try EmojiCatalogValidator().validate(catalog)) { error in
            XCTAssertEqual(error as? EmojiCatalogValidationError, .duplicateItemId("a"))
        }
    }

    func testInvalidCategoryReferenceRejected() throws {
        let catalog = EmojiCatalog(
            schemaVersion: 1,
            categories: [EmojiCategory(id: "smileys", title: "S", symbol: "😊", sortOrder: 1)],
            items: [
                EmojiItem(id: "a", glyph: "😀", name: "A", categoryId: "missing")
            ]
        )
        XCTAssertThrowsError(try EmojiCatalogValidator().validate(catalog)) { error in
            XCTAssertEqual(
                error as? EmojiCatalogValidationError,
                .invalidCategoryReference(itemId: "a", categoryId: "missing")
            )
        }
    }

    func testUnsupportedSchemaRejected() throws {
        let catalog = EmojiCatalog(
            schemaVersion: 99,
            categories: [EmojiCategory(id: "smileys", title: "S", symbol: "😊", sortOrder: 1)],
            items: [EmojiItem(id: "a", glyph: "😀", name: "A", categoryId: "smileys")]
        )
        XCTAssertThrowsError(try EmojiCatalogValidator().validate(catalog)) { error in
            XCTAssertEqual(error as? EmojiCatalogValidationError, .unsupportedSchemaVersion(99))
        }
    }

    func testDuplicateCategoryIdsRejected() throws {
        let catalog = EmojiCatalog(
            schemaVersion: 1,
            categories: [
                EmojiCategory(id: "smileys", title: "S", symbol: "😊", sortOrder: 1),
                EmojiCategory(id: "smileys", title: "S2", symbol: "😀", sortOrder: 2)
            ],
            items: [EmojiItem(id: "a", glyph: "😀", name: "A", categoryId: "smileys")]
        )
        XCTAssertThrowsError(try EmojiCatalogValidator().validate(catalog)) { error in
            XCTAssertEqual(error as? EmojiCatalogValidationError, .duplicateCategoryId("smileys"))
        }
    }

    func testResolvedCategoryFallback() {
        let catalog = EmojiCatalog(
            schemaVersion: 1,
            categories: [
                EmojiCategory(id: "favorites", title: "F", symbol: "★", sortOrder: 0),
                EmojiCategory(id: "smileys", title: "S", symbol: "😊", sortOrder: 1)
            ],
            items: [EmojiItem(id: "a", glyph: "😀", name: "A", categoryId: "smileys")]
        )
        XCTAssertEqual(catalog.resolvedCategoryId(selected: nil), "smileys")
        XCTAssertEqual(catalog.resolvedCategoryId(selected: "food"), "smileys")
        XCTAssertEqual(catalog.resolvedCategoryId(selected: "favorites"), "favorites")
    }
}

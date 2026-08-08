import XCTest
@testable import SupernovaEmoji

final class KatseyeCatalogTests: XCTestCase {
    func testKatseyeCategoryExistsWithCombos() throws {
        let catalog = try EmojiCatalogLoader().loadBundled()
        XCTAssertNotNil(catalog.category(id: "katseye"))
        let items = catalog.items(in: "katseye")
        XCTAssertGreaterThanOrEqual(items.count, 8)
        XCTAssertTrue(items.contains(where: { $0.glyph.contains("💎") || $0.glyph.contains("✨") }))
    }

    func testKatseyeCombosAreInsertableText() throws {
        let catalog = try EmojiCatalogLoader().loadBundled()
        for item in catalog.items(in: "katseye") {
            XCTAssertFalse(item.glyph.isEmpty)
            XCTAssertFalse(item.id.isEmpty)
            XCTAssertEqual(item.categoryId, "katseye")
        }
    }

    func testBackgroundVariantAssetsNamed() {
        XCTAssertEqual(KatseyeBackgroundVariant.personalPhoto.imageAssetName, "KatseyePhotoBackground")
        XCTAssertEqual(KatseyeBackgroundVariant.abstractPastel.imageAssetName, "KatseyeAbstractBackground")
    }
}

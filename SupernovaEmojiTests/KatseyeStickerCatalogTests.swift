import XCTest
@testable import SupernovaEmoji

final class KatseyeStickerCatalogTests: XCTestCase {
    func testBundledStickerCatalogLoads() throws {
        let catalog = try KatseyeStickerCatalog.loadBundled()
        XCTAssertGreaterThanOrEqual(catalog.stickers.count, 20)
        // No empty assets
        for s in catalog.stickers {
            XCTAssertFalse(s.asset.isEmpty)
            XCTAssertFalse(s.fallbackText.isEmpty)
            XCTAssertFalse(s.memberName.isEmpty)
        }
    }

    func testMemberFilter() throws {
        let catalog = try KatseyeStickerCatalog.loadBundled()
        let members = catalog.members
        XCTAssertFalse(members.isEmpty)
        let first = members[0]
        let filtered = catalog.stickers(forMember: first)
        XCTAssertFalse(filtered.isEmpty)
        XCTAssertTrue(filtered.allSatisfy { $0.memberId == first })
    }
}

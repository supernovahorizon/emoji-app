import XCTest
@testable import SupernovaEmoji

final class KeyboardMetricsTests: XCTestCase {
    func testPhoneBoardHeightIsClampedAgainstZoom() {
        // iPhone 13 Pro logical points
        let height = KeyboardMetrics.boardHeight(
            screenWidth: 390,
            screenHeight: 844,
            isPad: false
        )
        XCTAssertNil(KeyboardMetrics.validateBoardHeight(height, isPad: false))
        XCTAssertGreaterThanOrEqual(height, KeyboardMetrics.minBoardHeightPhone)
        XCTAssertLessThanOrEqual(height, KeyboardMetrics.maxBoardHeightPhone)
    }

    func testTallScreenDoesNotProduceGiantBoard() {
        // Pathological / future ultra-tall screen
        let height = KeyboardMetrics.boardHeight(
            screenWidth: 430,
            screenHeight: 2000,
            isPad: false
        )
        XCTAssertLessThanOrEqual(height, KeyboardMetrics.maxBoardHeightPhone)
        XCTAssertNil(KeyboardMetrics.validateBoardHeight(height, isPad: false))
    }

    func testKeyHeightNeverExceedsMaxEvenIfContentIsHuge() {
        let key = KeyboardMetrics.keyHeight(forContentHeight: 900)
        XCTAssertLessThanOrEqual(key, KeyboardMetrics.maxKeyHeight)
        XCTAssertNil(KeyboardMetrics.validateKeyHeight(key))
    }

    func testKeyHeightFloorOnTinyContent() {
        let key = KeyboardMetrics.keyHeight(forContentHeight: 20)
        XCTAssertGreaterThanOrEqual(key, KeyboardMetrics.minKeyHeight)
    }

    func testValidateFlagsOversizedBoard() {
        let issue = KeyboardMetrics.validateBoardHeight(500, isPad: false)
        XCTAssertNotNil(issue)
        XCTAssertTrue(issue?.contains("zoom") == true)
    }
}

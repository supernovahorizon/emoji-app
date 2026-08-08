import XCTest
@testable import SupernovaEmojiKeyboard

final class TextInputHandlerTests: XCTestCase {
    func testRecordingHandlerOrder() {
        let handler = RecordingTextInputHandler()
        handler.insertText("x")
        handler.deleteBackward()
        handler.advanceToNextInputMode()
        XCTAssertEqual(
            handler.actions,
            [.insert("x"), .deleteBackward, .nextKeyboard]
        )
    }
}

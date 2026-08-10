import Foundation

/// Abstracts keyboard text operations for testability.
public protocol TextInputHandling: AnyObject {
    func insertText(_ text: String)
    func deleteBackward()
    func advanceToNextInputMode()
    /// Optional: copy a sticker image for the host app (best-effort; may no-op in tests).
    func copyImageData(_ data: Data, uti: String)
}

public extension TextInputHandling {
    func copyImageData(_ data: Data, uti: String) {
        // Default no-op for tests / simple handlers.
    }
}

/// Records actions for unit tests. Does not log text content in production logging paths.
public final class RecordingTextInputHandler: TextInputHandling, @unchecked Sendable {
    public enum Action: Equatable, Sendable {
        case insert(String)
        case deleteBackward
        case nextKeyboard
        case copyImage(Int)
    }

    private let lock = NSLock()
    private var _actions: [Action] = []

    public init() {}

    public var actions: [Action] {
        lock.lock(); defer { lock.unlock() }
        return _actions
    }

    public func insertText(_ text: String) {
        lock.lock(); defer { lock.unlock() }
        _actions.append(.insert(text))
    }

    public func deleteBackward() {
        lock.lock(); defer { lock.unlock() }
        _actions.append(.deleteBackward)
    }

    public func advanceToNextInputMode() {
        lock.lock(); defer { lock.unlock() }
        _actions.append(.nextKeyboard)
    }

    public func copyImageData(_ data: Data, uti: String) {
        lock.lock(); defer { lock.unlock() }
        _actions.append(.copyImage(data.count))
    }

    public func reset() {
        lock.lock(); defer { lock.unlock() }
        _actions.removeAll()
    }
}

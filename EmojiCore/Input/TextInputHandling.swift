import Foundation

/// Abstracts keyboard text operations for testability.
public protocol TextInputHandling: AnyObject {
    func insertText(_ text: String)
    func deleteBackward()
    func advanceToNextInputMode()
}

/// Records actions for unit tests. Does not log text content in production logging paths.
public final class RecordingTextInputHandler: TextInputHandling, @unchecked Sendable {
    public enum Action: Equatable, Sendable {
        case insert(String)
        case deleteBackward
        case nextKeyboard
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

    public func reset() {
        lock.lock(); defer { lock.unlock() }
        _actions.removeAll()
    }
}

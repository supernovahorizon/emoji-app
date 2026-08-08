import Foundation

/// Which surface the keyboard is showing.
public enum KeyboardPanel: String, Codable, Sendable, CaseIterable {
    case letters
    case numbers
    case symbols
    case emoji
}

/// Shift / caps state for the English letter panel.
public enum ShiftState: String, Codable, Sendable, Equatable {
    case off
    case once
    case locked
}

/// Static QWERTY / number / symbol layouts (English).
public enum KeyboardLayout {
    public static let letterRows: [[String]] = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["z", "x", "c", "v", "b", "n", "m"]
    ]

    public static let numberRows: [[String]] = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
        ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
        [".", ",", "?", "!", "'"]
    ]

    public static let symbolRows: [[String]] = [
        ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
        ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"],
        [".", ",", "?", "!", "'"]
    ]
}

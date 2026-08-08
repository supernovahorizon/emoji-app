import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Single source of truth for keyboard plate + key sizing.
///
/// **Regression guard:** keys must never scale unboundedly with a huge plate.
/// Board height is clamped to a system-like range so the keyboard does not
/// look "zoomed in" or swallow the whole screen.
public enum KeyboardMetrics: Sendable {
    public static let rowCount: CGFloat = 4
    public static let rowSpacing: CGFloat = 7
    public static let keySpacing: CGFloat = 5

    /// Hard caps — if a future change offers more height, keys stop growing here.
    public static let minKeyHeight: CGFloat = 38
    public static let maxKeyHeight: CGFloat = 46
    public static let idealKeyHeight: CGFloat = 42

    /// Phone board height bounds (points), portrait-oriented.
    public static let minBoardHeightPhone: CGFloat = 246
    public static let maxBoardHeightPhone: CGFloat = 286

    /// iPad board height bounds (points).
    public static let minBoardHeightPad: CGFloat = 280
    public static let maxBoardHeightPad: CGFloat = 320

    /// Compute the keyboard plate height for the current device / screen.
    public static func boardHeight(
        screenWidth: CGFloat,
        screenHeight: CGFloat,
        isPad: Bool
    ) -> CGFloat {
        let longSide = max(screenWidth, screenHeight)
        // ~31% of the long side tracks stock iOS keyboards on modern iPhones
        // without overflowing into a full-screen "zoomed" plate.
        let proposed = longSide * 0.31
        if isPad {
            return min(max(proposed, minBoardHeightPad), maxBoardHeightPad)
        }
        return min(max(proposed, minBoardHeightPhone), maxBoardHeightPhone)
    }

    #if canImport(UIKit)
    public static func boardHeightForMainScreen() -> CGFloat {
        let bounds = UIScreen.main.bounds
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        return boardHeight(
            screenWidth: bounds.width,
            screenHeight: bounds.height,
            isPad: isPad
        )
    }
    #endif

    /// Key row height given available content height (after outer padding).
    /// Always clamped — never lets rows become giant when the plate is oversized.
    public static func keyHeight(forContentHeight contentHeight: CGFloat) -> CGFloat {
        let spacing = rowSpacing * (rowCount - 1)
        let raw = (contentHeight - spacing) / rowCount
        if raw.isNaN || raw.isInfinite || raw <= 0 {
            return idealKeyHeight
        }
        return min(maxKeyHeight, max(minKeyHeight, raw))
    }

    /// Letter font size scaled gently with key height (also clamped).
    public static func letterFontSize(forKeyHeight keyHeight: CGFloat) -> CGFloat {
        min(22, max(16, keyHeight * 0.42))
    }

    /// Side keys (shift/delete) width relative to board width.
    public static func sideKeyWidth(forBoardWidth width: CGFloat) -> CGFloat {
        min(52, max(40, width * 0.115))
    }

    // MARK: - Validation (tests / agents)

    /// Returns nil if metrics are healthy; otherwise a human-readable failure.
    public static func validateBoardHeight(_ height: CGFloat, isPad: Bool) -> String? {
        let minH = isPad ? minBoardHeightPad : minBoardHeightPhone
        let maxH = isPad ? maxBoardHeightPad : maxBoardHeightPhone
        if height < minH - 0.5 {
            return "board height \(height) is below minimum \(minH)"
        }
        if height > maxH + 0.5 {
            return "board height \(height) exceeds maximum \(maxH) (zoom risk)"
        }
        return nil
    }

    public static func validateKeyHeight(_ height: CGFloat) -> String? {
        if height < minKeyHeight - 0.5 {
            return "key height \(height) below minimum \(minKeyHeight)"
        }
        if height > maxKeyHeight + 0.5 {
            return "key height \(height) exceeds maximum \(maxKeyHeight) (zoom risk)"
        }
        return nil
    }
}

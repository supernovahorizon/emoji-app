import SwiftUI

/// Resolves keyboard chrome colors for the active theme.
struct KeyboardThemePalette {
    let theme: KeyboardTheme
    let colorScheme: ColorScheme

    // MARK: - Surfaces

    var boardBackground: Color {
        switch theme.id {
        case "katseye":
            // Deep night / stage black
            return Color(red: 0.07, green: 0.05, blue: 0.10)
        case "soft":
            return colorScheme == .dark
                ? Color(white: 0.18)
                : Color(red: 0.96, green: 0.95, blue: 0.98)
        case "highContrast":
            return colorScheme == .dark ? .black : .white
        default:
            return Color(uiColor: .systemGray5)
        }
    }

    var letterKeyFill: Color {
        switch theme.id {
        case "katseye":
            // Soft blush keycaps
            return Color(red: 1.0, green: 0.78, blue: 0.90)
        case "highContrast":
            return colorScheme == .dark ? Color(white: 0.15) : .white
        default:
            return colorScheme == .dark ? Color(white: 0.34) : .white
        }
    }

    var letterKeyText: Color {
        switch theme.id {
        case "katseye":
            return Color(red: 0.12, green: 0.06, blue: 0.16)
        case "highContrast":
            return colorScheme == .dark ? .white : .black
        default:
            return .primary
        }
    }

    var actionKeyFill: Color {
        switch theme.id {
        case "katseye":
            // Magenta-plum action keys
            return Color(red: 0.55, green: 0.18, blue: 0.48)
        case "highContrast":
            return colorScheme == .dark ? Color(white: 0.3) : Color(white: 0.75)
        default:
            return colorScheme == .dark ? Color(white: 0.22) : Color(white: 0.78)
        }
    }

    var actionKeyText: Color {
        switch theme.id {
        case "katseye":
            return Color(red: 1.0, green: 0.92, blue: 0.97)
        default:
            return .primary
        }
    }

    var returnKeyFill: Color {
        switch theme.id {
        case "katseye":
            // Hot KATSEYE pink
            return Color(red: 1.0, green: 0.28, blue: 0.62)
        default:
            return Color.accentColor.opacity(colorScheme == .dark ? 0.85 : 1)
        }
    }

    var returnKeyText: Color { .white }

    var shiftActiveFill: Color {
        switch theme.id {
        case "katseye":
            return Color(red: 1.0, green: 0.45, blue: 0.78)
        default:
            return colorScheme == .dark ? Color.white : Color.black.opacity(0.85)
        }
    }

    var shiftActiveText: Color {
        switch theme.id {
        case "katseye":
            return Color(red: 0.15, green: 0.05, blue: 0.18)
        default:
            return colorScheme == .dark ? .black : .white
        }
    }

    var keyShadow: Color {
        switch theme.id {
        case "katseye":
            return Color(red: 1.0, green: 0.3, blue: 0.7).opacity(0.35)
        default:
            return .black.opacity(colorScheme == .dark ? 0.35 : 0.12)
        }
    }

    var categorySelectedFill: Color {
        switch theme.id {
        case "katseye":
            return Color(red: 1.0, green: 0.35, blue: 0.7).opacity(0.35)
        default:
            return Color.accentColor.opacity(0.25)
        }
    }

    var categorySelectedStroke: Color {
        switch theme.id {
        case "katseye":
            return Color(red: 1.0, green: 0.45, blue: 0.8)
        default:
            return Color.accentColor
        }
    }

    var categoryIdleFill: Color {
        switch theme.id {
        case "katseye":
            return Color.white.opacity(0.08)
        default:
            return Color.primary.opacity(0.06)
        }
    }

    var secondaryLabel: Color {
        switch theme.id {
        case "katseye":
            return Color(red: 1.0, green: 0.85, blue: 0.94).opacity(0.75)
        default:
            return .secondary
        }
    }

    var primaryLabel: Color {
        switch theme.id {
        case "katseye":
            return Color(red: 1.0, green: 0.92, blue: 0.97)
        default:
            return .primary
        }
    }

    /// Soft pink glow strip behind the board (Katseye only).
    var boardGlow: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.85, green: 0.15, blue: 0.55).opacity(0.45),
                Color(red: 0.35, green: 0.08, blue: 0.55).opacity(0.35),
                Color(red: 0.07, green: 0.05, blue: 0.10).opacity(0.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

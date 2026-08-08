import SwiftUI

/// Resolves keyboard chrome colors for the active theme.
struct KeyboardThemePalette {
    let theme: KeyboardTheme
    let colorScheme: ColorScheme

    var isKatseye: Bool { theme.id == "katseye" }

    // MARK: - Surfaces

    var boardBackground: Color {
        switch theme.id {
        case "katseye":
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

    /// Letter keys — glass/transparent on Katseye so the wallpaper shows through.
    var letterKeyFill: Color {
        switch theme.id {
        case "katseye":
            return Color.white.opacity(0.14)
        case "highContrast":
            return colorScheme == .dark ? Color(white: 0.15) : .white
        default:
            return colorScheme == .dark ? Color(white: 0.34) : .white
        }
    }

    var letterKeyStroke: Color {
        switch theme.id {
        case "katseye":
            return Color.white.opacity(0.42)
        default:
            return .clear
        }
    }

    var letterKeyText: Color {
        switch theme.id {
        case "katseye":
            // Bright white letters for contrast over dark photo
            return .white
        case "highContrast":
            return colorScheme == .dark ? .white : .black
        default:
            return .primary
        }
    }

    var letterKeyTextShadow: Color {
        switch theme.id {
        case "katseye":
            return Color.black.opacity(0.75)
        default:
            return .clear
        }
    }

    var actionKeyFill: Color {
        switch theme.id {
        case "katseye":
            // Slightly stronger glass so actions stay tappable/readable
            return Color(red: 0.85, green: 0.2, blue: 0.55).opacity(0.42)
        case "highContrast":
            return colorScheme == .dark ? Color(white: 0.3) : Color(white: 0.75)
        default:
            return colorScheme == .dark ? Color(white: 0.22) : Color(white: 0.78)
        }
    }

    var actionKeyText: Color {
        switch theme.id {
        case "katseye":
            return .white
        default:
            return .primary
        }
    }

    var returnKeyFill: Color {
        switch theme.id {
        case "katseye":
            return Color(red: 1.0, green: 0.28, blue: 0.62).opacity(0.88)
        default:
            return Color.accentColor.opacity(colorScheme == .dark ? 0.85 : 1)
        }
    }

    var returnKeyText: Color { .white }

    var shiftActiveFill: Color {
        switch theme.id {
        case "katseye":
            return Color(red: 1.0, green: 0.45, blue: 0.78).opacity(0.85)
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
            return Color.black.opacity(0.25)
        default:
            return .black.opacity(colorScheme == .dark ? 0.35 : 0.12)
        }
    }

    var categorySelectedFill: Color {
        switch theme.id {
        case "katseye":
            return Color(red: 1.0, green: 0.35, blue: 0.7).opacity(0.4)
        default:
            return Color.accentColor.opacity(0.25)
        }
    }

    var categorySelectedStroke: Color {
        switch theme.id {
        case "katseye":
            return Color(red: 1.0, green: 0.55, blue: 0.85)
        default:
            return Color.accentColor
        }
    }

    var categoryIdleFill: Color {
        switch theme.id {
        case "katseye":
            return Color.black.opacity(0.28)
        default:
            return Color.primary.opacity(0.06)
        }
    }

    var secondaryLabel: Color {
        switch theme.id {
        case "katseye":
            return Color.white.opacity(0.85)
        default:
            return .secondary
        }
    }

    var primaryLabel: Color {
        switch theme.id {
        case "katseye":
            return .white
        default:
            return .primary
        }
    }

    var boardGlow: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.85, green: 0.15, blue: 0.55).opacity(0.25),
                Color(red: 0.35, green: 0.08, blue: 0.55).opacity(0.15),
                Color.clear
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

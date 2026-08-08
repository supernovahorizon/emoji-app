import SwiftUI

/// Resolves keyboard chrome colors for the active theme.
struct KeyboardThemePalette {
    let theme: KeyboardTheme
    let colorScheme: ColorScheme

    var isKatseye: Bool { theme.isKatseyeFamily }

    // Pastel gem tokens from asset kit palette.json
    static let pearl = Color(hex: 0xF8F4F7)
    static let blush = Color(hex: 0xEFC5C8)
    static let pink = Color(hex: 0xEFA8B6)
    static let sky = Color(hex: 0x8CC9DF)
    static let butter = Color(hex: 0xEEDB87)
    static let lime = Color(hex: 0xB2A742)
    static let lilac = Color(hex: 0xCBC3E9)
    static let plum = Color(hex: 0x6D486A)
    static let ink = Color(hex: 0x342C3B)
    static let chrome = Color(hex: 0xE5E6EE)

    var boardBackground: Color {
        switch theme.id {
        case KeyboardTheme.katseyePastel.id, "katseye", "pastelGem":
            return Self.pearl
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
        if isKatseye {
            // Clear glass — photo shows through; letters stay readable via ink + halo.
            return Color.white.opacity(0.18)
        }
        switch theme.id {
        case "highContrast":
            return colorScheme == .dark ? Color(white: 0.15) : .white
        default:
            return colorScheme == .dark ? Color(white: 0.34) : .white
        }
    }

    var letterKeyStroke: Color {
        if isKatseye { return Color.white.opacity(0.55) }
        return .clear
    }

    var letterKeyText: Color {
        if isKatseye { return Self.ink }
        switch theme.id {
        case "highContrast":
            return colorScheme == .dark ? .white : .black
        default:
            return .primary
        }
    }

    var letterKeyTextShadow: Color {
        // Light halo so dark ink stays visible over bright photo regions.
        if isKatseye { return Color.white.opacity(0.95) }
        return .clear
    }

    var actionKeyFill: Color {
        if isKatseye { return Color.white.opacity(0.22) }
        switch theme.id {
        case "highContrast":
            return colorScheme == .dark ? Color(white: 0.3) : Color(white: 0.75)
        default:
            return colorScheme == .dark ? Color(white: 0.22) : Color(white: 0.78)
        }
    }

    var actionKeyText: Color {
        if isKatseye { return Self.ink }
        return .primary
    }

    var returnKeyFill: Color {
        if isKatseye { return Self.pink.opacity(0.55) }
        return Color.accentColor.opacity(colorScheme == .dark ? 0.85 : 1)
    }

    var returnKeyText: Color {
        if isKatseye { return Self.ink }
        return .white
    }

    var shiftActiveFill: Color {
        if isKatseye { return Self.sky.opacity(0.55) }
        return colorScheme == .dark ? Color.white : Color.black.opacity(0.85)
    }

    var shiftActiveText: Color {
        if isKatseye { return Self.ink }
        return colorScheme == .dark ? .black : .white
    }

    var keyShadow: Color {
        if isKatseye { return Color.black.opacity(0.12) }
        return .black.opacity(colorScheme == .dark ? 0.35 : 0.12)
    }

    var categorySelectedFill: Color {
        if isKatseye { return Self.sky.opacity(0.45) }
        return Color.accentColor.opacity(0.25)
    }

    var categorySelectedStroke: Color {
        if isKatseye { return Self.butter }
        return Color.accentColor
    }

    var categoryIdleFill: Color {
        if isKatseye { return Color.white.opacity(0.55) }
        return Color.primary.opacity(0.06)
    }

    var secondaryLabel: Color {
        if isKatseye { return Self.plum.opacity(0.9) }
        return .secondary
    }

    var primaryLabel: Color {
        if isKatseye { return Self.ink }
        return .primary
    }

    var boardGlow: LinearGradient {
        LinearGradient(
            colors: [
                Self.pink.opacity(0.22),
                Self.sky.opacity(0.18),
                Self.butter.opacity(0.12),
                Color.clear
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var backgroundAssetName: String {
        KatseyeBackgroundVariant.current.imageAssetName
    }
}

private extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

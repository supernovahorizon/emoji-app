import SwiftUI

struct ThemesView: View {
    @State private var preferences: KeyboardPreferences = LocalPreferencesStore().load()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Themes change keyboard chrome colors. Emoji glyphs use the system font.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .listRowBackground(Color.clear)
                }

                Section("Available themes") {
                    ForEach(KeyboardTheme.all) { theme in
                        Button {
                            preferences.themeId = theme.id
                            LocalPreferencesStore().save(preferences)
                        } label: {
                            HStack(spacing: 12) {
                                themeSwatch(theme)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(theme.name)
                                        .foregroundStyle(.primary)
                                    if theme.isDefault {
                                        Text("Default · EYEKON energy")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                if preferences.themeId == theme.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.accentColor)
                                        .accessibilityLabel("Selected")
                                }
                            }
                            .frame(minHeight: 44)
                        }
                        .accessibilityAddTraits(preferences.themeId == theme.id ? .isSelected : [])
                    }
                }

                Section("Preview") {
                    KeyboardThemePreview(theme: preferences.theme)
                        .frame(height: 140)
                        .listRowInsets(EdgeInsets())
                }
            }
            .navigationTitle("Themes")
            .onAppear {
                preferences = LocalPreferencesStore().load()
            }
        }
    }

    private func themeSwatch(_ theme: KeyboardTheme) -> some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(swatchGradient(theme))
            .frame(width: 36, height: 36)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            )
            .accessibilityHidden(true)
    }

    private func swatchGradient(_ theme: KeyboardTheme) -> LinearGradient {
        switch theme.id {
        case "katseye":
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.28, blue: 0.62),
                    Color(red: 0.15, green: 0.05, blue: 0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "soft":
            return LinearGradient(colors: [Color.pink.opacity(0.3), Color.purple.opacity(0.2)], startPoint: .top, endPoint: .bottom)
        case "highContrast":
            return LinearGradient(colors: [.black, .white], startPoint: .leading, endPoint: .trailing)
        default:
            return LinearGradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.2)], startPoint: .top, endPoint: .bottom)
        }
    }
}

struct KeyboardThemePreview: View {
    let theme: KeyboardTheme
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            background
            VStack(spacing: 10) {
                if theme.id == "katseye" {
                    Text("KATSEYE")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(Color(red: 1.0, green: 0.85, blue: 0.94))
                }
                HStack(spacing: 8) {
                    previewKey("Q", fill: letterFill, text: letterText)
                    previewKey("W", fill: letterFill, text: letterText)
                    previewKey("E", fill: letterFill, text: letterText)
                    previewKey("space", fill: letterFill, text: letterText, wide: true)
                    previewKey("return", fill: returnFill, text: .white)
                }
            }
            .padding()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Theme preview for \(theme.name)")
    }

    private func previewKey(_ title: String, fill: Color, text: Color, wide: Bool = false) -> some View {
        Text(title)
            .font(.system(size: wide ? 11 : 14, weight: .semibold, design: .rounded))
            .foregroundStyle(text)
            .frame(width: wide ? 72 : 36, height: 36)
            .background(RoundedRectangle(cornerRadius: 8).fill(fill))
    }

    private var background: some View {
        Group {
            switch theme.id {
            case "katseye":
                ZStack {
                    Color(red: 0.07, green: 0.05, blue: 0.10)
                    LinearGradient(
                        colors: [
                            Color(red: 0.85, green: 0.15, blue: 0.55).opacity(0.5),
                            Color(red: 0.35, green: 0.08, blue: 0.55).opacity(0.35),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            case "soft":
                (colorScheme == .dark ? Color(white: 0.18) : Color(red: 0.96, green: 0.95, blue: 0.98))
            case "highContrast":
                colorScheme == .dark ? Color.black : Color.white
            default:
                Color(uiColor: .secondarySystemBackground)
            }
        }
    }

    private var letterFill: Color {
        switch theme.id {
        case "katseye": return Color(red: 1.0, green: 0.78, blue: 0.90)
        case "highContrast": return colorScheme == .dark ? Color(white: 0.2) : .white
        default: return colorScheme == .dark ? Color(white: 0.34) : .white
        }
    }

    private var letterText: Color {
        switch theme.id {
        case "katseye": return Color(red: 0.12, green: 0.06, blue: 0.16)
        default: return .primary
        }
    }

    private var returnFill: Color {
        switch theme.id {
        case "katseye": return Color(red: 1.0, green: 0.28, blue: 0.62)
        default: return Color.accentColor
        }
    }
}

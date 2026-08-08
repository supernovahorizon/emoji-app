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
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(theme.name)
                                        .foregroundStyle(.primary)
                                    if theme.isDefault {
                                        Text("Default")
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
                        .frame(height: 120)
                        .listRowInsets(EdgeInsets())
                }
            }
            .navigationTitle("Themes")
            .onAppear {
                preferences = LocalPreferencesStore().load()
            }
        }
    }
}

struct KeyboardThemePreview: View {
    let theme: KeyboardTheme
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            background
            HStack(spacing: 12) {
                Text("😀")
                Text("🐶")
                Text("🎉")
            }
            .font(.system(size: 36))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primary.opacity(0.06))
            )
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Theme preview for \(theme.name)")
    }

    private var background: some View {
        Group {
            switch theme.id {
            case "soft":
                (colorScheme == .dark ? Color(white: 0.18) : Color(red: 0.96, green: 0.95, blue: 0.98))
            case "highContrast":
                colorScheme == .dark ? Color.black : Color.white
            default:
                Color(uiColor: .secondarySystemBackground)
            }
        }
    }
}

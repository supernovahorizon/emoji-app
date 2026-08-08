import SwiftUI

struct ThemesView: View {
    @State private var preferences: KeyboardPreferences = LocalPreferencesStore().load()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Themes change keyboard chrome. KATSEYE Pastel uses the asset-kit photo background on this personal build.")
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
                                        Text("Default · pastel gem")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                if KeyboardTheme.resolve(id: preferences.themeId).id == theme.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.accentColor)
                                        .accessibilityLabel("Selected")
                                }
                            }
                            .frame(minHeight: 44)
                        }
                        .accessibilityAddTraits(
                            KeyboardTheme.resolve(id: preferences.themeId).id == theme.id ? .isSelected : []
                        )
                    }
                }

                Section("Preview") {
                    KeyboardThemePreview(theme: KeyboardTheme.resolve(id: preferences.themeId))
                        .frame(height: 160)
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
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(swatchGradient(theme))
            if theme.isKatseyeFamily {
                Image("katseyeCharmGemEye")
                    .resizable()
                    .scaledToFit()
                    .padding(6)
            }
        }
        .frame(width: 40, height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
        )
        .accessibilityHidden(true)
    }

    private func swatchGradient(_ theme: KeyboardTheme) -> LinearGradient {
        switch theme.id {
        case KeyboardTheme.katseyePastel.id, "katseye":
            return LinearGradient(
                colors: [
                    Color(red: 0.94, green: 0.66, blue: 0.71),
                    Color(red: 0.55, green: 0.79, blue: 0.87),
                    Color(red: 0.93, green: 0.86, blue: 0.53)
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

    var body: some View {
        ZStack {
            if theme.isKatseyeFamily {
                Image("KatseyeAbstractBackground")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                LinearGradient(
                    colors: [Color.white.opacity(0.35), Color.white.opacity(0.2)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                Color(uiColor: .secondarySystemBackground)
            }

            VStack(spacing: 10) {
                HStack(spacing: 6) {
                    if theme.isKatseyeFamily {
                        Image("katseyeCharmGemEye")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    Text(theme.isKatseyeFamily ? "KATSEYE" : theme.name)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .tracking(1.2)
                        .foregroundStyle(Color(red: 0.2, green: 0.17, blue: 0.23))
                    Spacer()
                }
                .padding(.horizontal, 12)

                HStack(spacing: 8) {
                    previewKey("Q")
                    previewKey("W")
                    previewKey("E")
                    previewKey("space", wide: true)
                    previewKey("⏎", fill: Color(red: 0.94, green: 0.66, blue: 0.71))
                }
                .padding(.horizontal, 12)

                HStack(spacing: 8) {
                    charmChip("💎👁️✨")
                    charmChip("🎀💗✨")
                    charmChip("🎤⭐💫")
                }
            }
            .padding(.vertical, 12)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Theme preview for \(theme.name)")
    }

    private func previewKey(_ title: String, wide: Bool = false, fill: Color = Color.white.opacity(0.7)) -> some View {
        Text(title)
            .font(.system(size: wide ? 11 : 14, weight: .semibold, design: .rounded))
            .foregroundStyle(Color(red: 0.2, green: 0.17, blue: 0.23))
            .frame(width: wide ? 72 : 36, height: 36)
            .background(RoundedRectangle(cornerRadius: 8).fill(fill))
            .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.white.opacity(0.8), lineWidth: 1))
    }

    private func charmChip(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.white.opacity(0.55)))
    }
}

import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    AboutShreyaaView()
                } label: {
                    Label("About Shreyaa", systemImage: "star.fill")
                        .frame(minHeight: 44)
                }

                NavigationLink {
                    HelpView()
                } label: {
                    Label("Help", systemImage: "questionmark.circle")
                        .frame(minHeight: 44)
                }

                NavigationLink {
                    DiagnosticsView()
                } label: {
                    Label("Nerd stuff", systemImage: "wrench.and.screwdriver")
                        .frame(minHeight: 44)
                }
            }
            .navigationTitle("More")
        }
    }
}

struct HelpView: View {
    var body: some View {
        List {
            Section("Can't find the keyboard?") {
                Text("Settings → General → Keyboard → Keyboards → Add New Keyboard → Shreyaa's Slayy.")
                Text("In a chat, tap the globe key until it switches to mine.")
            }
            Section("Favorites") {
                Text("Press and hold an emoji to add (or yeet) a favorite.")
            }
            Section("Vibes") {
                Text("This is Shreyaa's Slayy Keyboard — made for fun texts, silly reactions, and main-character energy.")
            }
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DiagnosticsView: View {
    private var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
        return "\(v) (\(b))"
    }

    private var catalogStatus: String {
        do {
            let catalog = try EmojiCatalogLoader().loadBundled()
            return "OK · \(catalog.items.count) items · schema \(catalog.schemaVersion)"
        } catch {
            return "Unavailable"
        }
    }

    var body: some View {
        List {
            Section("Build") {
                LabeledContent("App name", value: "Shreyaa's Slayy Keyboard")
                LabeledContent("App version", value: appVersion)
                LabeledContent("Bundle ID", value: Bundle.main.bundleIdentifier ?? "—")
                LabeledContent("Catalog", value: catalogStatus)
            }
            Section {
                Text("Just build info — nothing personal, nothing boring.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Nerd stuff")
        .navigationBarTitleDisplayMode(.inline)
    }
}

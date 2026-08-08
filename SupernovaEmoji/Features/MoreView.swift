import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    PrivacyCardView()
                } label: {
                    Label("Privacy", systemImage: "hand.raised")
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
                    Label("Diagnostics", systemImage: "wrench.and.screwdriver")
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
            Section("Keyboard") {
                Text("If the keyboard does not appear, confirm it is added under Settings → General → Keyboard → Keyboards.")
                Text("Keep Allow Full Access turned OFF.")
                Text("Use the globe key to switch keyboards.")
            }
            Section("Favorites") {
                Text("In the keyboard, press and hold an emoji to add or remove a favorite.")
            }
            Section("Privacy") {
                Text("Supernova Emoji does not need network access and does not log typing.")
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
                LabeledContent("App version", value: appVersion)
                LabeledContent("Bundle ID", value: Bundle.main.bundleIdentifier ?? "—")
                LabeledContent("Catalog", value: catalogStatus)
            }
            Section("Privacy") {
                LabeledContent("Full Access required", value: "No")
                LabeledContent("Networking", value: "None in product")
                LabeledContent("Analytics", value: "None")
            }
            Section {
                Text("This screen never shows device identifiers, Team IDs, or personal data.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Diagnostics")
        .navigationBarTitleDisplayMode(.inline)
    }
}

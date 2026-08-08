import SwiftUI
import Combine

struct EmojiExplorerView: View {
    @StateObject private var model = ExplorerModel()

    private let columns = [GridItem(.adaptive(minimum: 52), spacing: 8)]

    var body: some View {
        NavigationStack {
            Group {
                if let catalog = model.catalog {
                    VStack(spacing: 0) {
                        Picker("Category", selection: $model.selectedCategoryId) {
                            ForEach(catalog.sortedCategories.filter { $0.id != "favorites" }) { category in
                                Text(category.title).tag(category.id)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        .accessibilityLabel("Category")

                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(catalog.items(in: model.selectedCategoryId)) { item in
                                    VStack(spacing: 4) {
                                        Text(item.glyph)
                                            .font(.system(size: 32))
                                            .frame(minWidth: 44, minHeight: 44)
                                        Text(item.name)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)
                                    }
                                    .padding(6)
                                    .accessibilityElement(children: .combine)
                                    .accessibilityLabel(item.name)
                                }
                            }
                            .padding()
                        }
                    }
                } else if model.errorMessage != nil {
                    ContentUnavailableView(
                        "Catalog unavailable",
                        systemImage: "exclamationmark.triangle",
                        description: Text("The bundled emoji catalog could not be loaded.")
                    )
                } else {
                    ProgressView("Loading…")
                }
            }
            .navigationTitle("Explore")
            .task { model.load() }
        }
    }
}

@MainActor
final class ExplorerModel: ObservableObject {
    @Published var catalog: EmojiCatalog?
    @Published var selectedCategoryId: String = EmojiCatalog.fallbackCategoryId
    @Published var errorMessage: String?

    func load() {
        do {
            let loaded = try EmojiCatalogLoader().loadBundled()
            catalog = loaded
            selectedCategoryId = loaded.resolvedCategoryId(selected: nil)
            errorMessage = nil
        } catch {
            catalog = nil
            errorMessage = "load_failed"
        }
    }
}

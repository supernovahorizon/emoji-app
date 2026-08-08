import SwiftUI

struct WelcomeView: View {
    @ObservedObject private var photoStore = ProfilePhotoStore.shared
    @State private var showEditLooks = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CoverImageView(store: photoStore, height: 380)

                    Text("Shreyaa's Slayy Keyboard")
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .minimumScaleFactor(0.85)
                        .lineLimit(3)
                        .accessibilityAddTraits(.isHeader)

                    Text("Heyyy 👋 this is my emoji keyboard. Peace signs up, boring vibes out.")
                        .font(.title3)
                        .foregroundStyle(.secondary)

                    vibeCard

                    NavigationLink {
                        EnableKeyboardView()
                    } label: {
                        Label("Turn it onnn", systemImage: "sparkles")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.borderedProminent)

                    NavigationLink {
                        EmojiExplorerView()
                    } label: {
                        Label("Peek the emoji stash", systemImage: "face.smiling")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.bordered)

                    NavigationLink {
                        AboutShreyaaView()
                    } label: {
                        Label("Meet the main character", systemImage: "star.fill")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showEditLooks = true
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                            .frame(minWidth: 44, minHeight: 44)
                            .contentShape(Rectangle())
                    }
                    .accessibilityLabel("Edit looks")
                    .accessibilityHint("Change cover photo or get help with a custom app icon")
                }
            }
            .sheet(isPresented: $showEditLooks) {
                EditLooksView(store: photoStore)
            }
        }
    }

    private var vibeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            bullet("Emoji that actually slap", icon: "flame.fill")
            bullet("Favorites for your go-to reactions", icon: "heart.fill")
            bullet("Switch keyboards with the globe key", icon: "globe")
            bullet("Made for pure chaos (the fun kind)", icon: "party.popper.fill")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.orange.opacity(0.18),
                            Color.pink.opacity(0.14)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }

    private func bullet(_ text: String, icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(.body)
            .frame(minHeight: 28, alignment: .leading)
    }
}

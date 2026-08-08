import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    coverPhoto

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
        }
    }

    private var coverPhoto: some View {
        // Align to top so hair/face are not clipped when filling the frame.
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: 380)
            .overlay(alignment: .top) {
                Image("CoverPhoto")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(alignment: .bottomLeading) {
                LinearGradient(
                    colors: [.clear, .black.opacity(0.45)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .allowsHitTesting(false)
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("✨ main character energy")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                    Text("Shreyaa")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("slay mode: ON")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(16)
            }
            .accessibilityLabel("Cover photo of Shreyaa making a fun peace-sign pose")
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

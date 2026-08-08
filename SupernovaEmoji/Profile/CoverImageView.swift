import SwiftUI

/// Shared cover rendering — uses the custom photo when set, else bundled default.
struct CoverImageView: View {
    @ObservedObject var store: ProfilePhotoStore
    var height: CGFloat
    var cornerRadius: CGFloat = 24
    var showCaption: Bool = true

    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .overlay(alignment: .top) {
                Group {
                    if let coverImage = store.coverImage {
                        Image(uiImage: coverImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image("CoverPhoto")
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(alignment: .bottomLeading) {
                if showCaption {
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.45)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .allowsHitTesting(false)
                }
            }
            .overlay(alignment: .bottomLeading) {
                if showCaption {
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
            }
            .accessibilityLabel("Cover photo")
    }
}

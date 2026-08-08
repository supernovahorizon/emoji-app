import SwiftUI

/// Fun about page (replaces corporate privacy card on the home flow).
struct AboutShreyaaView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image("CoverPhoto")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .accessibilityLabel("Photo of Shreyaa")

                Text("About this keyboard")
                    .font(.title.bold())

                Text("Hi, I'm Shreyaa ✌️ and this is my Slayy Keyboard. I made it so texting can feel more like me — silly faces, big energy, zero boring.")
                    .font(.body)

                Group {
                    row("Peace signs are kind of my brand.")
                    row("Orange dress energy forever.")
                    row("If it's not fun, why are we even typing?")
                    row("Pick favorites, spam your besties, live your best chat life.")
                }

                Text("Pro tip: after you enable it, hit the globe key and boom — you're in Slayy mode.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "sparkle")
                .foregroundStyle(.orange)
                .accessibilityHidden(true)
            Text(text)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }
}

// Keep old name as alias so any leftover links still compile.
typealias PrivacyCardView = AboutShreyaaView

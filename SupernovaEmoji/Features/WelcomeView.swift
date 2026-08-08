import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("✨")
                        .font(.system(size: 64))
                        .frame(maxWidth: .infinity)
                        .accessibilityHidden(true)

                    Text("Supernova Emoji")
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("A private, ad-free emoji keyboard for families.")
                        .font(.title3)
                        .foregroundStyle(.secondary)

                    privacyBullets

                    NavigationLink {
                        PrivacyCardView()
                    } label: {
                        Label("Read our privacy promise", systemImage: "hand.raised.fill")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.borderedProminent)

                    NavigationLink {
                        EnableKeyboardView()
                    } label: {
                        Label("Enable the keyboard", systemImage: "keyboard")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .navigationTitle("Welcome")
        }
    }

    private var privacyBullets: some View {
        VStack(alignment: .leading, spacing: 12) {
            bullet("No ads or subscriptions", icon: "nosign")
            bullet("No accounts or tracking", icon: "eye.slash")
            bullet("Works offline", icon: "airplane")
            bullet("Full Access not required", icon: "lock.shield")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.secondary.opacity(0.12)))
    }

    private func bullet(_ text: String, icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(.body)
            .frame(minHeight: 28, alignment: .leading)
    }
}

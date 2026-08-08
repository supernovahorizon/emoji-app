import SwiftUI

struct PrivacyCardView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy promise")
                    .font(.title.bold())

                Text("Supernova Emoji is built to stay on your device.")
                    .font(.body)

                Group {
                    row("We do not collect personal information.")
                    row("We do not log what you type.")
                    row("We do not use analytics or ads.")
                    row("The keyboard does not need Full Access.")
                    row("Preferences like favorites stay local.")
                }

                Text("You can leave Allow Full Access turned OFF when enabling the keyboard in Settings.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .accessibilityHidden(true)
            Text(text)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }
}

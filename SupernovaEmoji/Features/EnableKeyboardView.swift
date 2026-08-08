import SwiftUI
import UIKit

struct EnableKeyboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Turn on Supernova Emoji")
                        .font(.title2.bold())

                    Text("iOS requires these steps once. They only take a minute.")
                        .foregroundStyle(.secondary)

                    step(1, title: "Open Settings", detail: "Go to the Settings app on your iPhone or iPad.")
                    step(2, title: "General → Keyboard", detail: "Tap General, then Keyboard, then Keyboards.")
                    step(3, title: "Add New Keyboard", detail: "Choose Supernova Emoji from the list.")
                    step(4, title: "Keep Full Access OFF", detail: "Do not enable Allow Full Access. The keyboard works without it.")

                    Text("In any app, tap a text field, then tap the globe key to switch to Supernova Emoji.")
                        .font(.callout)
                        .padding(.top, 8)

                    Button {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Open Settings", systemImage: "gear")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
                .padding()
            }
            .navigationTitle("Enable")
        }
    }

    private func step(_ number: Int, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.headline)
                .frame(width: 36, height: 36)
                .background(Circle().fill(Color.accentColor.opacity(0.2)))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(detail)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .frame(minHeight: 44, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Step \(number): \(title). \(detail)")
    }
}

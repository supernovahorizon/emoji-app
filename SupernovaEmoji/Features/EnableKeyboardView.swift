import SwiftUI
import UIKit

struct EnableKeyboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Let's turn on the Slayy Keyboard")
                        .font(.title2.bold())

                    Text("One-time setup. Super quick. Then you can drop emoji like confetti.")
                        .foregroundStyle(.secondary)

                    step(1, title: "Open Settings", detail: "Jump into the Settings app.")
                    step(2, title: "General → Keyboard", detail: "Tap General, then Keyboard, then Keyboards.")
                    step(3, title: "Add New Keyboard", detail: "Pick Shreyaa's Slayy from the list.")
                    step(4, title: "You're good!", detail: "Jump into Messages (or Notes), tap a text field, then hit the globe key until you see Shreyaa's Slayy.")

                    Text("Globe key = keyboard switcher. Spam it till you land on mine.")
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

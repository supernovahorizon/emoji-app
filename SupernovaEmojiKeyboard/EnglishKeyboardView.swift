import SwiftUI

/// English QWERTY / numbers / symbols surfaces with rounded lettering.
struct EnglishKeyboardView: View {
    @ObservedObject var viewModel: KeyboardViewModel
    @Environment(\.colorScheme) private var colorScheme

    private let keyHeight: CGFloat = 42
    private let keySpacing: CGFloat = 5
    private let rowSpacing: CGFloat = 8

    var body: some View {
        VStack(spacing: rowSpacing) {
            ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                keyRow(row, isThirdLetterRow: viewModel.panel == .letters && index == 2)
            }
            bottomRow
        }
    }

    private var rows: [[String]] {
        switch viewModel.panel {
        case .letters:
            return KeyboardLayout.letterRows
        case .numbers:
            return KeyboardLayout.numberRows
        case .symbols:
            return KeyboardLayout.symbolRows
        case .emoji:
            return []
        }
    }

    // MARK: Rows

    @ViewBuilder
    private func keyRow(_ keys: [String], isThirdLetterRow: Bool) -> some View {
        HStack(spacing: keySpacing) {
            if isThirdLetterRow {
                shiftKey
            } else if viewModel.panel != .letters, keys.count <= 5 {
                // indent short bottom symbol/number rows slightly via flexible spacers
                Spacer(minLength: 0)
            }

            ForEach(keys, id: \.self) { key in
                characterKey(key)
            }

            if isThirdLetterRow {
                deleteKey
            } else if viewModel.panel != .letters, keys.count <= 5 {
                Spacer(minLength: 0)
                deleteKey
            }
        }
    }

    private var bottomRow: some View {
        HStack(spacing: keySpacing) {
            modeKey
            if viewModel.panel == .numbers || viewModel.panel == .symbols {
                symbolsToggleKey
            }
            globeKey
            spaceKey
            emojiToggleKey
            returnKey
        }
    }

    // MARK: Keys

    private func characterKey(_ key: String) -> some View {
        let label: String = {
            if viewModel.panel == .letters, key.count == 1, key.rangeOfCharacter(from: .letters) != nil {
                return viewModel.isUppercase ? key.uppercased() : key.lowercased()
            }
            return key
        }()

        return Button {
            viewModel.insertKey(key)
        } label: {
            Text(label)
                .font(.system(size: letterSize(for: label), weight: .medium, design: .rounded))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .frame(height: keyHeight)
                .background(keyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel(accessibilityName(for: label))
    }

    private var shiftKey: some View {
        Button {
            viewModel.cycleShift()
        } label: {
            Image(systemName: shiftSymbol)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(shiftForeground)
                .frame(width: 46, height: keyHeight)
                .background(shiftBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel(shiftAccessibilityLabel)
    }

    private var deleteKey: some View {
        Button {
            viewModel.deleteBackward()
        } label: {
            Image(systemName: "delete.left")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .frame(width: 46, height: keyHeight)
                .background(actionKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel("Delete")
    }

    private var modeKey: some View {
        Button {
            if viewModel.panel == .letters {
                viewModel.showPanel(.numbers)
            } else {
                viewModel.showPanel(.letters)
            }
        } label: {
            Text(modeKeyTitle)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .frame(width: 46, height: keyHeight)
                .background(actionKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel(modeAccessibilityLabel)
    }

    private var symbolsToggleKey: some View {
        Button {
            if viewModel.panel == .numbers {
                viewModel.showPanel(.symbols)
            } else {
                viewModel.showPanel(.numbers)
            }
        } label: {
            Text(viewModel.panel == .numbers ? "#+=" : "123")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .frame(width: 42, height: keyHeight)
                .background(actionKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel(viewModel.panel == .numbers ? "Symbols" : "Numbers")
    }

    private var globeKey: some View {
        Button {
            viewModel.nextKeyboard()
        } label: {
            Image(systemName: "globe")
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .frame(width: 42, height: keyHeight)
                .background(actionKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel("Next keyboard")
    }

    private var spaceKey: some View {
        Button {
            viewModel.insertSpace()
        } label: {
            Text("space")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(height: keyHeight)
                .background(keyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel("Space")
    }

    private var emojiToggleKey: some View {
        Button {
            viewModel.showPanel(.emoji)
        } label: {
            Text("😊")
                .font(.system(size: 22))
                .frame(width: 42, height: keyHeight)
                .background(actionKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel("Emoji keyboard")
    }

    private var returnKey: some View {
        Button {
            viewModel.insertReturn()
        } label: {
            Text("return")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .frame(width: 72, height: keyHeight)
                .background(returnBackground)
                .foregroundStyle(returnForeground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel("Return")
    }

    // MARK: Appearance

    private var keyBackground: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(colorScheme == .dark ? Color(white: 0.34) : Color.white)
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.35 : 0.12), radius: 0.5, y: 1)
    }

    private var actionKeyBackground: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(colorScheme == .dark ? Color(white: 0.22) : Color(white: 0.78))
    }

    private var shiftBackground: some View {
        let active = viewModel.shiftState != .off
        return RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(
                active
                    ? (colorScheme == .dark ? Color.white : Color.black.opacity(0.85))
                    : (colorScheme == .dark ? Color(white: 0.22) : Color(white: 0.78))
            )
    }

    private var shiftForeground: Color {
        viewModel.shiftState == .off
            ? .primary
            : (colorScheme == .dark ? .black : .white)
    }

    private var returnBackground: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(Color.accentColor.opacity(colorScheme == .dark ? 0.85 : 1))
    }

    private var returnForeground: Color {
        .white
    }

    private var shiftSymbol: String {
        switch viewModel.shiftState {
        case .off: return "shift"
        case .once: return "shift.fill"
        case .locked: return "capslock.fill"
        }
    }

    private var shiftAccessibilityLabel: String {
        switch viewModel.shiftState {
        case .off: return "Shift"
        case .once: return "Shift enabled"
        case .locked: return "Caps Lock"
        }
    }

    private var modeKeyTitle: String {
        viewModel.panel == .letters ? "123" : "ABC"
    }

    private var modeAccessibilityLabel: String {
        viewModel.panel == .letters ? "Numbers" : "Letters"
    }

    private func letterSize(for label: String) -> CGFloat {
        label.count > 1 ? 14 : 20
    }

    private func accessibilityName(for label: String) -> String {
        if label == " " { return "Space" }
        return label
    }
}

// MARK: - Press style

private struct KeyboardKeyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}

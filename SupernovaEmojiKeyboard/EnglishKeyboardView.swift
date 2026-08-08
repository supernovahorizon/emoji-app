import SwiftUI

/// English QWERTY / numbers / symbols surfaces with rounded lettering.
/// Keys expand to fill the full keyboard height (no dead space at the bottom).
struct EnglishKeyboardView: View {
    @ObservedObject var viewModel: KeyboardViewModel
    @Environment(\.colorScheme) private var colorScheme

    private let keySpacing: CGFloat = 5
    private let rowSpacing: CGFloat = 7

    var body: some View {
        GeometryReader { geo in
            let rowCount: CGFloat = 4
            let totalRowSpacing = rowSpacing * (rowCount - 1)
            let keyHeight = max(40, (geo.size.height - totalRowSpacing) / rowCount)
            let letterFont = max(17, min(24, keyHeight * 0.42))
            let sideKeyWidth = max(42, min(56, geo.size.width * 0.12))

            VStack(spacing: rowSpacing) {
                ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                    keyRow(
                        row,
                        isThirdLetterRow: viewModel.panel == .letters && index == 2,
                        keyHeight: keyHeight,
                        letterFont: letterFont,
                        sideKeyWidth: sideKeyWidth
                    )
                }
                bottomRow(keyHeight: keyHeight, sideKeyWidth: sideKeyWidth)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    private func keyRow(
        _ keys: [String],
        isThirdLetterRow: Bool,
        keyHeight: CGFloat,
        letterFont: CGFloat,
        sideKeyWidth: CGFloat
    ) -> some View {
        HStack(spacing: keySpacing) {
            if isThirdLetterRow {
                shiftKey(height: keyHeight, width: sideKeyWidth)
            } else if viewModel.panel != .letters, keys.count <= 5 {
                Spacer(minLength: 0)
            }

            ForEach(keys, id: \.self) { key in
                characterKey(key, height: keyHeight, letterFont: letterFont)
            }

            if isThirdLetterRow {
                deleteKey(height: keyHeight, width: sideKeyWidth)
            } else if viewModel.panel != .letters, keys.count <= 5 {
                Spacer(minLength: 0)
                deleteKey(height: keyHeight, width: sideKeyWidth)
            }
        }
        .frame(height: keyHeight)
    }

    private func bottomRow(keyHeight: CGFloat, sideKeyWidth: CGFloat) -> some View {
        HStack(spacing: keySpacing) {
            modeKey(height: keyHeight, width: sideKeyWidth)
            if viewModel.panel == .numbers || viewModel.panel == .symbols {
                symbolsToggleKey(height: keyHeight, width: sideKeyWidth * 0.9)
            }
            globeKey(height: keyHeight, width: sideKeyWidth * 0.9)
            spaceKey(height: keyHeight)
            emojiToggleKey(height: keyHeight, width: sideKeyWidth * 0.9)
            returnKey(height: keyHeight, width: max(64, sideKeyWidth * 1.35))
        }
        .frame(height: keyHeight)
    }

    // MARK: Keys

    private func characterKey(_ key: String, height: CGFloat, letterFont: CGFloat) -> some View {
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
                .font(.system(size: letterSize(for: label, base: letterFont), weight: .medium, design: .rounded))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(keyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel(accessibilityName(for: label))
    }

    private func shiftKey(height: CGFloat, width: CGFloat) -> some View {
        Button {
            viewModel.cycleShift()
        } label: {
            Image(systemName: shiftSymbol)
                .font(.system(size: max(15, height * 0.36), weight: .semibold, design: .rounded))
                .foregroundStyle(shiftForeground)
                .frame(width: width, height: height)
                .background(shiftBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel(shiftAccessibilityLabel)
    }

    private func deleteKey(height: CGFloat, width: CGFloat) -> some View {
        Button {
            viewModel.deleteBackward()
        } label: {
            Image(systemName: "delete.left")
                .font(.system(size: max(15, height * 0.36), weight: .semibold, design: .rounded))
                .frame(width: width, height: height)
                .background(actionKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel("Delete")
    }

    private func modeKey(height: CGFloat, width: CGFloat) -> some View {
        Button {
            if viewModel.panel == .letters {
                viewModel.showPanel(.numbers)
            } else {
                viewModel.showPanel(.letters)
            }
        } label: {
            Text(modeKeyTitle)
                .font(.system(size: max(13, height * 0.28), weight: .semibold, design: .rounded))
                .frame(width: width, height: height)
                .background(actionKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel(modeAccessibilityLabel)
    }

    private func symbolsToggleKey(height: CGFloat, width: CGFloat) -> some View {
        Button {
            if viewModel.panel == .numbers {
                viewModel.showPanel(.symbols)
            } else {
                viewModel.showPanel(.numbers)
            }
        } label: {
            Text(viewModel.panel == .numbers ? "#+=" : "123")
                .font(.system(size: max(11, height * 0.24), weight: .semibold, design: .rounded))
                .frame(width: width, height: height)
                .background(actionKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel(viewModel.panel == .numbers ? "Symbols" : "Numbers")
    }

    private func globeKey(height: CGFloat, width: CGFloat) -> some View {
        Button {
            viewModel.nextKeyboard()
        } label: {
            Image(systemName: "globe")
                .font(.system(size: max(16, height * 0.36), weight: .medium, design: .rounded))
                .frame(width: width, height: height)
                .background(actionKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel("Next keyboard")
    }

    private func spaceKey(height: CGFloat) -> some View {
        Button {
            viewModel.insertSpace()
        } label: {
            Text("space")
                .font(.system(size: max(14, height * 0.3), weight: .medium, design: .rounded))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(keyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel("Space")
    }

    private func emojiToggleKey(height: CGFloat, width: CGFloat) -> some View {
        Button {
            viewModel.showPanel(.emoji)
        } label: {
            Text("😊")
                .font(.system(size: max(20, height * 0.45)))
                .frame(width: width, height: height)
                .background(actionKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel("Emoji keyboard")
    }

    private func returnKey(height: CGFloat, width: CGFloat) -> some View {
        Button {
            viewModel.insertReturn()
        } label: {
            Text("return")
                .font(.system(size: max(12, height * 0.26), weight: .semibold, design: .rounded))
                .frame(width: width, height: height)
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

    private func letterSize(for label: String, base: CGFloat) -> CGFloat {
        label.count > 1 ? max(12, base * 0.7) : base
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
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.88 : 1)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}

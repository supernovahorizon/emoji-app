import SwiftUI
import UIKit

/// English QWERTY / numbers / symbols surfaces with rounded lettering.
/// Keys expand to fill the full keyboard height (no dead space at the bottom).
struct EnglishKeyboardView: View {
    @ObservedObject var viewModel: KeyboardViewModel
    @Environment(\.colorScheme) private var colorScheme

    private var palette: KeyboardThemePalette {
        KeyboardThemePalette(theme: viewModel.preferences.theme, colorScheme: colorScheme)
    }

    var body: some View {
        GeometryReader { geo in
            // Clamped — never lets keys grow into a "zoomed" full-screen look.
            let keyHeight = KeyboardMetrics.keyHeight(forContentHeight: geo.size.height)
            let letterFont = KeyboardMetrics.letterFontSize(forKeyHeight: keyHeight)
            let sideKeyWidth = KeyboardMetrics.sideKeyWidth(forBoardWidth: geo.size.width)

            VStack(spacing: KeyboardMetrics.rowSpacing) {
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
            // Pin rows to the bottom like the system keyboard (home-indicator side).
            .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
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
        HStack(spacing: KeyboardMetrics.keySpacing) {
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
        HStack(spacing: KeyboardMetrics.keySpacing) {
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
                .font(.system(size: letterSize(for: label, base: letterFont), weight: .bold, design: .rounded))
                .foregroundStyle(palette.letterKeyText)
                .shadow(color: palette.letterKeyTextShadow, radius: 0, x: 0, y: 1)
                .shadow(color: palette.letterKeyTextShadow, radius: 2, x: 0, y: 0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(letterKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(palette.letterKeyStroke, lineWidth: palette.isKatseye ? 1 : 0)
                )
                .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel(accessibilityName(for: label))
    }

    private func shiftKey(height: CGFloat, width: CGFloat) -> some View {
        let active = viewModel.shiftState != .off
        return Button {
            viewModel.cycleShift()
        } label: {
            Image(systemName: shiftSymbol)
                .font(.system(size: max(15, height * 0.36), weight: .semibold, design: .rounded))
                .foregroundStyle(active ? palette.shiftActiveText : palette.actionKeyText)
                .frame(width: width, height: height)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(active ? palette.shiftActiveFill : palette.actionKeyFill)
                )
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
                .foregroundStyle(palette.actionKeyText)
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
                .foregroundStyle(palette.actionKeyText)
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
                .foregroundStyle(palette.actionKeyText)
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
                .foregroundStyle(palette.actionKeyText)
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
                .font(.system(size: max(13, height * 0.28), weight: .bold, design: .rounded))
                .foregroundStyle(palette.letterKeyText)
                .shadow(color: palette.letterKeyTextShadow, radius: 0, x: 0, y: 1)
                .shadow(color: palette.letterKeyTextShadow, radius: 2, x: 0, y: 0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(letterKeyBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(palette.letterKeyStroke, lineWidth: palette.isKatseye ? 1 : 0)
                )
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel("Space")
    }

    private func emojiToggleKey(height: CGFloat, width: CGFloat) -> some View {
        Button {
            viewModel.showPanel(.emoji)
            viewModel.selectCategory("katseye")
        } label: {
            Group {
                if palette.isKatseye {
                    Image("katseyeCharmGemEye")
                        .resizable()
                        .scaledToFit()
                        .padding(6)
                } else {
                    Text("😊")
                        .font(.system(size: max(20, height * 0.45)))
                }
            }
            .frame(width: width, height: height)
            .background(actionKeyBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(palette.letterKeyStroke, lineWidth: palette.isKatseye ? 1 : 0)
            )
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel("KATSEYE emoji keyboard")
    }

    private func returnKey(height: CGFloat, width: CGFloat) -> some View {
        Button {
            viewModel.insertReturn()
        } label: {
            Text("return")
                .font(.system(size: max(12, height * 0.26), weight: .semibold, design: .rounded))
                .frame(width: width, height: height)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(palette.returnKeyFill)
                )
                .foregroundStyle(palette.returnKeyText)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(KeyboardKeyButtonStyle())
        .accessibilityLabel("Return")
    }

    // MARK: Appearance

    private var letterKeyBackground: some View {
        Group {
            if palette.isKatseye {
                // Frosted pearl key surface from palette (asset kit mood).
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.78),
                                KeyboardThemePalette.pearl.opacity(0.62),
                                KeyboardThemePalette.blush.opacity(0.35)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: palette.keyShadow, radius: 1, y: 1)
            } else {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(palette.letterKeyFill)
                    .shadow(color: palette.keyShadow, radius: 0.5, y: 1)
            }
        }
    }

    private var actionKeyBackground: some View {
        Group {
            if palette.isKatseye {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                KeyboardThemePalette.lilac.opacity(0.85),
                                KeyboardThemePalette.sky.opacity(0.55)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            } else {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(palette.actionKeyFill)
            }
        }
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

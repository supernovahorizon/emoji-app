import SwiftUI

struct KeyboardRootView: View {
    @ObservedObject var viewModel: KeyboardViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let columns = [GridItem(.adaptive(minimum: 44, maximum: 56), spacing: 6)]

    var body: some View {
        VStack(spacing: 8) {
            categoryBar
            emojiGrid
            actionBar
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
        .accessibilityElement(children: .contain)
    }

    private var backgroundColor: Color {
        switch viewModel.preferences.theme.id {
        case "soft":
            return colorScheme == .dark ? Color(white: 0.18) : Color(red: 0.96, green: 0.95, blue: 0.98)
        case "highContrast":
            return colorScheme == .dark ? .black : .white
        default:
            return Color(uiColor: .secondarySystemBackground)
        }
    }

    private var categoryBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.displayCategories) { category in
                    let selected = viewModel.selectedCategoryId == category.id
                    Button {
                        if reduceMotion {
                            viewModel.selectCategory(category.id)
                        } else {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                viewModel.selectCategory(category.id)
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(category.symbol)
                            Text(category.title)
                                .font(.caption.weight(selected ? .bold : .regular))
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 12)
                        .frame(minHeight: 44)
                        .background(
                            Capsule()
                                .fill(selected ? Color.accentColor.opacity(0.25) : Color.primary.opacity(0.06))
                        )
                        .overlay(
                            Capsule()
                                .strokeBorder(selected ? Color.accentColor : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(category.title)
                    .accessibilityAddTraits(selected ? .isSelected : [])
                }
            }
            .padding(.vertical, 2)
        }
        .accessibilityLabel("Emoji categories")
    }

    private var emojiGrid: some View {
        Group {
            if viewModel.visibleItems.isEmpty {
                VStack(spacing: 8) {
                    Text(viewModel.selectedCategoryId == "favorites" ? "No favorites yet" : "No emoji")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if viewModel.loadFailed {
                        Text("Using safe fallback catalog")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityElement(children: .combine)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 6) {
                        ForEach(viewModel.visibleItems) { item in
                            Button {
                                viewModel.insertEmoji(item)
                            } label: {
                                Text(item.glyph)
                                    .font(.system(size: 28))
                                    .frame(minWidth: 44, minHeight: 44)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(item.name)
                            .contextMenu {
                                Button(viewModel.preferences.isFavorite(item.id) ? "Remove Favorite" : "Add Favorite") {
                                    viewModel.toggleFavorite(item)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 4)
                }
            }
        }
    }

    private var actionBar: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.nextKeyboard()
            } label: {
                Image(systemName: "globe")
                    .font(.system(size: 20, weight: .medium))
                    .frame(minWidth: 44, minHeight: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Next keyboard")

            Spacer()

            Button {
                viewModel.deleteBackward()
            } label: {
                Image(systemName: "delete.left")
                    .font(.system(size: 20, weight: .medium))
                    .frame(minWidth: 44, minHeight: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Delete")
        }
        .padding(.horizontal, 4)
    }
}

import SwiftUI
import UIKit

struct KeyboardRootView: View {
    @ObservedObject var viewModel: KeyboardViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let columns = [GridItem(.adaptive(minimum: 44, maximum: 56), spacing: 6)]

    private var palette: KeyboardThemePalette {
        KeyboardThemePalette(theme: viewModel.preferences.theme, colorScheme: colorScheme)
    }

    var body: some View {
        ZStack {
            palette.boardBackground
            if palette.isKatseye {
                katseyeWallpaper
            }

            Group {
                if viewModel.panel == .emoji {
                    emojiChrome
                } else {
                    EnglishKeyboardView(viewModel: viewModel)
                }
            }
            .padding(.horizontal, 3)
            .padding(.top, 4)
            .padding(.bottom, 2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .accessibilityElement(children: .contain)
    }

    private var katseyeWallpaper: some View {
        // Sharp photo only — no blur/veil. Letter contrast comes from key labels.
        GeometryReader { geo in
            Image(palette.backgroundAssetName)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
        .allowsHitTesting(false)
    }

    // MARK: Emoji mode

    private var emojiChrome: some View {
        VStack(spacing: 6) {
            if palette.isKatseye {
                HStack(spacing: 8) {
                    Image("katseyeCharmGemEye")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .accessibilityHidden(true)
                    Text("KATSEYE")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(1.5)
                        .foregroundStyle(palette.primaryLabel)
                        .shadow(color: .white.opacity(0.9), radius: 1.5, x: 0, y: 0)
                    Spacer()
                }
                .padding(.horizontal, 6)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("KATSEYE theme")
            }
            categoryBar
            if viewModel.isKatseyeStickerMode {
                memberFilterBar
                stickerGrid
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                emojiGrid
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            emojiActionBar
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var memberFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                memberChip(id: nil, title: "All")
                ForEach(viewModel.stickerCatalog.members, id: \.self) { memberId in
                    let title = viewModel.stickerCatalog.stickers
                        .first(where: { $0.memberId == memberId })?.memberName ?? memberId
                    memberChip(id: memberId, title: title)
                }
            }
            .padding(.horizontal, 4)
        }
        .accessibilityLabel("KATSEYE members")
    }

    private func memberChip(id: String?, title: String) -> some View {
        let selected = viewModel.selectedMemberFilter == id
        return Button {
            viewModel.selectMemberFilter(id)
        } label: {
            Text(title)
                .font(.system(size: 12, weight: selected ? .bold : .medium, design: .rounded))
                .foregroundStyle(palette.primaryLabel)
                .padding(.horizontal, 12)
                .frame(minHeight: 32)
                .background(
                    Capsule()
                        .fill(selected ? palette.categorySelectedFill : palette.categoryIdleFill)
                )
                .overlay(
                    Capsule()
                        .strokeBorder(selected ? palette.categorySelectedStroke : Color.white.opacity(0.5), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    private var stickerGrid: some View {
        let stickerColumns = [GridItem(.adaptive(minimum: 64, maximum: 80), spacing: 8)]
        return Group {
            if viewModel.visibleStickers.isEmpty {
                Text("No stickers yet")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(palette.secondaryLabel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: stickerColumns, spacing: 8) {
                        ForEach(viewModel.visibleStickers) { sticker in
                            Button {
                                let data = UIImage(named: sticker.asset)?.pngData()
                                viewModel.insertSticker(sticker, imagePNGData: data)
                            } label: {
                                Image(sticker.asset)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(minWidth: 56, minHeight: 56)
                                    .frame(maxWidth: 72, maxHeight: 72)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color.white.opacity(0.55))
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(sticker.name)
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.bottom, 4)
                }
            }
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
                            categoryLeading(category)
                            Text(category.title)
                                .font(.system(.caption, design: .rounded).weight(selected ? .bold : .regular))
                                .foregroundStyle(palette.primaryLabel)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 12)
                        .frame(minHeight: 44)
                        .background(
                            Capsule()
                                .fill(selected ? palette.categorySelectedFill : palette.categoryIdleFill)
                        )
                        .overlay(
                            Capsule()
                                .strokeBorder(selected ? palette.categorySelectedStroke : Color.white.opacity(0.6), lineWidth: selected ? 2 : 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(category.id == "katseye" ? "KATSEYE favorites category" : category.title)
                    .accessibilityAddTraits(selected ? .isSelected : [])
                }
            }
            .padding(.vertical, 2)
        }
        .accessibilityLabel("Emoji categories")
    }

    @ViewBuilder
    private func categoryLeading(_ category: EmojiCategory) -> some View {
        if category.id == "katseye" {
            Image("katseyeCharmGemEye")
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                .accessibilityHidden(true)
        } else {
            Text(category.symbol)
        }
    }

    private var emojiGrid: some View {
        Group {
            if viewModel.visibleItems.isEmpty {
                VStack(spacing: 8) {
                    Text(viewModel.selectedCategoryId == "favorites" ? "No favorites yet" : "No emoji")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(palette.secondaryLabel)
                    if viewModel.loadFailed {
                        Text("Using safe fallback catalog")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(palette.secondaryLabel)
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
                                    .minimumScaleFactor(0.6)
                                    .lineLimit(1)
                                    .frame(minWidth: 44, minHeight: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.white.opacity(palette.isKatseye ? 0.45 : 0))
                                    )
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

    private var emojiActionBar: some View {
        HStack(spacing: 10) {
            Button {
                viewModel.nextKeyboard()
            } label: {
                Image(systemName: "globe")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.actionKeyText)
                    .frame(minWidth: 44, minHeight: 44)
                    .background(actionChrome)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Next keyboard")

            Button {
                viewModel.showPanel(.letters)
            } label: {
                Text("ABC")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(palette.actionKeyText)
                    .frame(minWidth: 52, minHeight: 44)
                    .padding(.horizontal, 8)
                    .background(actionChrome)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Letters keyboard")

            Spacer()

            Button {
                viewModel.deleteBackward()
            } label: {
                Image(systemName: "delete.left")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.actionKeyText)
                    .frame(minWidth: 44, minHeight: 44)
                    .background(actionChrome)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Backspace")
        }
        .padding(.horizontal, 4)
    }

    private var actionChrome: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(palette.actionKeyFill)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.7), lineWidth: 1)
            )
    }
}

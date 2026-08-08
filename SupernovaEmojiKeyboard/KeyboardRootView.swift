import SwiftUI

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
            // Base + photo wallpaper (Katseye)
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
        ZStack {
            // Aspect-fill clipped to the board — not a full-screen zoom crop.
            GeometryReader { geo in
                Image("KatseyeBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            // Slight dark veil so white lettering always pops
            LinearGradient(
                colors: [
                    Color.black.opacity(0.28),
                    Color.black.opacity(0.18),
                    Color.black.opacity(0.38)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            palette.boardGlow
                .opacity(0.55)
        }
        .allowsHitTesting(false)
    }

    // MARK: Emoji mode

    private var emojiChrome: some View {
        VStack(spacing: 6) {
            if palette.isKatseye {
                HStack(spacing: 8) {
                    if UIImage(named: "KatseyeLogo") != nil {
                        Image("KatseyeLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                    }
                    Text("KATSEYE")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(palette.secondaryLabel)
                        .shadow(color: .black.opacity(0.6), radius: 1, y: 1)
                    Spacer()
                }
                .padding(.horizontal, 6)
                .accessibilityHidden(true)
            }
            categoryBar
            emojiGrid
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            emojiActionBar
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                                .font(.system(.caption, design: .rounded).weight(selected ? .bold : .regular))
                                .foregroundStyle(palette.primaryLabel)
                                .shadow(color: .black.opacity(palette.isKatseye ? 0.5 : 0), radius: 1, y: 1)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 12)
                        .frame(minHeight: 40)
                        .background(
                            Capsule()
                                .fill(selected ? palette.categorySelectedFill : palette.categoryIdleFill)
                        )
                        .overlay(
                            Capsule()
                                .strokeBorder(selected ? palette.categorySelectedStroke : Color.clear, lineWidth: 2)
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
                                    .shadow(color: .black.opacity(palette.isKatseye ? 0.45 : 0), radius: 1, y: 1)
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

    private var emojiActionBar: some View {
        HStack(spacing: 10) {
            Button {
                viewModel.nextKeyboard()
            } label: {
                Image(systemName: "globe")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.actionKeyText)
                    .frame(minWidth: 44, minHeight: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(palette.actionKeyFill)
                    )
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
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(palette.actionKeyFill)
                    )
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
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(palette.actionKeyFill)
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Delete")
        }
        .padding(.horizontal, 4)
    }
}

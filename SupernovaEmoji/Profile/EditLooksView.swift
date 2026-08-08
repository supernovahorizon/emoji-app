import SwiftUI
import PhotosUI
import UIKit

/// Edit cover photo (fully supported) + home-screen icon guidance (iOS limits).
struct EditLooksView: View {
    @ObservedObject var store: ProfilePhotoStore
    @Environment(\.dismiss) private var dismiss

    @State private var coverPickerItem: PhotosPickerItem?
    @State private var iconPickerItem: PhotosPickerItem?
    @State private var isLoadingCover = false
    @State private var isLoadingIcon = false
    @State private var bannerMessage: String?
    @State private var showIconHowTo = false
    @State private var lastIconPreview: UIImage?

    var body: some View {
        NavigationStack {
            List {
                coverSection
                iconSection
            }
            .navigationTitle("Edit looks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
            .overlay(alignment: .bottom) {
                if let bannerMessage {
                    Text(bannerMessage)
                        .font(.subheadline.weight(.medium))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(.bottom, 24)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut, value: bannerMessage)
            .sheet(isPresented: $showIconHowTo) {
                IconHowToSheet(preview: lastIconPreview)
            }
        }
    }

    // MARK: Cover

    private var coverSection: some View {
        Section {
            CoverImageView(store: store, height: 220, cornerRadius: 16, showCaption: false)
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                .listRowBackground(Color.clear)

            PhotosPicker(selection: $coverPickerItem, matching: .images, photoLibrary: .shared()) {
                Label {
                    Text(isLoadingCover ? "Loading photo…" : "Choose a new cover photo")
                } icon: {
                    Image(systemName: "photo.on.rectangle.angled")
                }
                .frame(minHeight: 44)
            }
            .disabled(isLoadingCover)
            .onChange(of: coverPickerItem) { _, item in
                guard let item else { return }
                Task { await applyCover(from: item) }
            }

            Button(role: .destructive) {
                store.resetCoverToDefault()
                flash("Back to the classic cover ✨")
            } label: {
                Label("Reset cover to default", systemImage: "arrow.counterclockwise")
                    .frame(minHeight: 44)
            }
        } header: {
            Text("Cover photo")
        } footer: {
            Text("This is the big pic inside the app. Change it anytime — totally your vibe.")
        }
    }

    // MARK: App icon

    private var iconSection: some View {
        Section {
            HStack(spacing: 16) {
                iconPreviewTile
                VStack(alignment: .leading, spacing: 6) {
                    Text("Home screen icon")
                        .font(.headline)
                    Text("Apple doesn’t let apps set the home icon to *any* photo you pick (security rule).")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)

            PhotosPicker(selection: $iconPickerItem, matching: .images, photoLibrary: .shared()) {
                Label {
                    Text(isLoadingIcon ? "Preparing icon…" : "Pick a photo for icon help")
                } icon: {
                    Image(systemName: "app.badge")
                }
                .frame(minHeight: 44)
            }
            .disabled(isLoadingIcon)
            .onChange(of: iconPickerItem) { _, item in
                guard let item else { return }
                Task { await prepareIcon(from: item) }
            }

            Button {
                showIconHowTo = true
            } label: {
                Label("How to use a custom home icon", systemImage: "questionmark.circle")
                    .frame(minHeight: 44)
            }
        } header: {
            Text("App icon")
        } footer: {
            Text("We’ll square-crop your pic and you can save it to Photos, then use the Shortcuts app to put it on your home screen. The in-app cover still changes for real above.")
        }
    }

    private var iconPreviewTile: some View {
        Group {
            if let lastIconPreview {
                Image(uiImage: lastIconPreview)
                    .resizable()
                    .scaledToFill()
            } else if let cover = store.coverImage {
                Image(uiImage: store.makeIconReadyImage(from: cover))
                    .resizable()
                    .scaledToFill()
            } else {
                Image("CoverPhoto")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 72, height: 72)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
        )
        .accessibilityLabel("Icon preview")
    }

    // MARK: Actions

    private func applyCover(from item: PhotosPickerItem) async {
        isLoadingCover = true
        defer { isLoadingCover = false }
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                flash("Couldn’t load that photo — try another?")
                return
            }
            store.setCover(from: image)
            flash("Cover updated. Slay. 💅")
        } catch {
            flash("Couldn’t load that photo — try another?")
        }
        coverPickerItem = nil
    }

    private func prepareIcon(from item: PhotosPickerItem) async {
        isLoadingIcon = true
        defer { isLoadingIcon = false }
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                flash("Couldn’t load that photo — try another?")
                return
            }
            lastIconPreview = store.saveIconReadyImageToDisk(image)
            flash("Icon-ready pic is ready — see How to…")
            showIconHowTo = true
        } catch {
            flash("Couldn’t load that photo — try another?")
        }
        iconPickerItem = nil
    }

    private func flash(_ message: String) {
        bannerMessage = message
        Task {
            try? await Task.sleep(nanoseconds: 2_200_000_000)
            if bannerMessage == message {
                bannerMessage = nil
            }
        }
    }
}

// MARK: - How-to sheet

private struct IconHowToSheet: View {
    @Environment(\.dismiss) private var dismiss
    var preview: UIImage?
    @State private var saveMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let preview {
                        Image(uiImage: preview)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                            .frame(maxWidth: .infinity)
                            .padding(.top, 8)
                    }

                    Text("Custom home screen icon")
                        .font(.title2.bold())

                    Text("iOS won’t let this app swap its real icon for a random Camera Roll pic. Super annoying — but here’s the fun workaround almost every aesthetic icon uses:")
                        .font(.body)

                    step(1, "Save the square pic below to Photos (button under this).")
                    step(2, "Open the Shortcuts app → + → Add Action → Open App → pick Shreyaa's Slayy.")
                    step(3, "Tap the share / Add to Home Screen control.")
                    step(4, "Tap the icon → Choose Photo → pick the square pic you saved.")
                    step(5, "Name it Shreyaa's Slayy and Add. Hide the original app in a folder if you want.")

                    Button {
                        savePreviewToPhotos()
                    } label: {
                        Label("Save square icon to Photos", systemImage: "square.and.arrow.down")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(preview == nil)

                    if let saveMessage {
                        Text(saveMessage)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    Text("Your in-app cover photo still changes for real with the Edit button — that part is 100% yours.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
                .padding()
            }
            .navigationTitle("Icon tips")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func step(_ n: Int, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(n)")
                .font(.headline)
                .frame(width: 32, height: 32)
                .background(Circle().fill(Color.accentColor.opacity(0.2)))
            Text(text)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }

    private func savePreviewToPhotos() {
        guard let preview else { return }
        UIImageWriteToSavedPhotosAlbum(preview, nil, nil, nil)
        saveMessage = "Saved! Check your Photos library."
    }
}

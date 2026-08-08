import Foundation
import UIKit
import Combine

/// Stores the in-app cover photo on device (not typed content — just a display picture).
@MainActor
final class ProfilePhotoStore: ObservableObject {
    static let shared = ProfilePhotoStore()

    @Published private(set) var coverImage: UIImage?

    private let folderURL: URL
    private let coverURL: URL
    private let iconPreviewURL: URL

    private init() {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        folderURL = base.appendingPathComponent("ProfilePhotos", isDirectory: true)
        coverURL = folderURL.appendingPathComponent("cover.jpg")
        iconPreviewURL = folderURL.appendingPathComponent("icon_preview.png")
        try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
        reload()
    }

    func reload() {
        if let data = try? Data(contentsOf: coverURL), let image = UIImage(data: data) {
            coverImage = image
        } else {
            coverImage = UIImage(named: "CoverPhoto")
        }
    }

    func setCover(from image: UIImage) {
        let normalized = image.normalizedUpOrientation()
        coverImage = normalized
        if let data = normalized.jpegData(compressionQuality: 0.88) {
            try? data.write(to: coverURL, options: .atomic)
        }
    }

    func resetCoverToDefault() {
        try? FileManager.default.removeItem(at: coverURL)
        coverImage = UIImage(named: "CoverPhoto")
    }

    /// Square, icon-ready crop saved for Photos export (home-screen icon workaround).
    func makeIconReadyImage(from image: UIImage) -> UIImage {
        let normalized = image.normalizedUpOrientation()
        return normalized.centerSquareCropped().resized(to: CGSize(width: 1024, height: 1024))
    }

    func saveIconReadyImageToDisk(_ image: UIImage) -> UIImage {
        let icon = makeIconReadyImage(from: image)
        if let data = icon.pngData() {
            try? data.write(to: iconPreviewURL, options: .atomic)
        }
        return icon
    }
}

// MARK: - UIImage helpers

private extension UIImage {
    func normalizedUpOrientation() -> UIImage {
        guard imageOrientation != .up else { return self }
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }

    func centerSquareCropped() -> UIImage {
        guard let cgImage else { return self }
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let side = min(width, height)
        let rect = CGRect(
            x: (width - side) / 2,
            y: (height - side) / 2,
            width: side,
            height: side
        )
        guard let cropped = cgImage.cropping(to: rect) else { return self }
        return UIImage(cgImage: cropped, scale: 1, orientation: .up)
    }

    func resized(to target: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: target, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: target))
        }
    }
}


import Foundation

public enum EmojiCatalogLoadError: Error, Equatable, Sendable {
    case resourceMissing
    case decodeFailed
    case validationFailed(EmojiCatalogValidationError)
}

public struct EmojiCatalogLoader: Sendable {
    public init() {}

    public func loadBundled(in bundle: Bundle = .main) throws -> EmojiCatalog {
        guard let url = bundle.url(forResource: "emoji_catalog", withExtension: "json") else {
            throw EmojiCatalogLoadError.resourceMissing
        }
        return try load(from: url)
    }

    public func load(from url: URL) throws -> EmojiCatalog {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw EmojiCatalogLoadError.resourceMissing
        }
        return try load(from: data)
    }

    public func load(from data: Data) throws -> EmojiCatalog {
        let catalog: EmojiCatalog
        do {
            catalog = try JSONDecoder().decode(EmojiCatalog.self, from: data)
        } catch {
            throw EmojiCatalogLoadError.decodeFailed
        }
        do {
            try EmojiCatalogValidator().validate(catalog)
        } catch let error as EmojiCatalogValidationError {
            throw EmojiCatalogLoadError.validationFailed(error)
        }
        return catalog
    }
}

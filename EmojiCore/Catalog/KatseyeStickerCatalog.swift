import Foundation

/// Facemoji-style KATSEYE member sticker (image asset + text fallback).
public struct KatseyeSticker: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let memberId: String
    public let memberName: String
    public let expression: String
    public let asset: String
    public let name: String
    public let fallbackText: String

    public init(
        id: String,
        memberId: String,
        memberName: String,
        expression: String,
        asset: String,
        name: String,
        fallbackText: String
    ) {
        self.id = id
        self.memberId = memberId
        self.memberName = memberName
        self.expression = expression
        self.asset = asset
        self.name = name
        self.fallbackText = fallbackText
    }
}

private struct KatseyeStickerCatalogFile: Codable, Sendable {
    let schemaVersion: Int
    let stickers: [KatseyeSticker]
}

public enum KatseyeStickerCatalogError: Error, Equatable, Sendable {
    case resourceMissing
    case decodeFailed
}

public struct KatseyeStickerCatalog: Sendable {
    public let stickers: [KatseyeSticker]

    public init(stickers: [KatseyeSticker]) {
        self.stickers = stickers
    }

    public static func loadBundled(in bundle: Bundle = .main) throws -> KatseyeStickerCatalog {
        guard let url = bundle.url(forResource: "katseye_stickers", withExtension: "json") else {
            throw KatseyeStickerCatalogError.resourceMissing
        }
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw KatseyeStickerCatalogError.resourceMissing
        }
        do {
            let file = try JSONDecoder().decode(KatseyeStickerCatalogFile.self, from: data)
            return KatseyeStickerCatalog(stickers: file.stickers)
        } catch {
            throw KatseyeStickerCatalogError.decodeFailed
        }
    }

    public var members: [String] {
        var seen = Set<String>()
        var order: [String] = []
        for s in stickers {
            if seen.insert(s.memberId).inserted {
                order.append(s.memberId)
            }
        }
        return order
    }

    public func stickers(forMember memberId: String?) -> [KatseyeSticker] {
        guard let memberId else { return stickers }
        return stickers.filter { $0.memberId == memberId }
    }
}

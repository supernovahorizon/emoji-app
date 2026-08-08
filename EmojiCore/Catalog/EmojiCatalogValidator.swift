import Foundation

public enum EmojiCatalogValidationError: Error, Equatable, Sendable {
    case unsupportedSchemaVersion(Int)
    case duplicateItemId(String)
    case duplicateCategoryId(String)
    case invalidCategoryReference(itemId: String, categoryId: String)
    case emptyCategories
    case emptyItems
}

public struct EmojiCatalogValidator: Sendable {
    public init() {}

    public func validate(_ catalog: EmojiCatalog) throws {
        guard catalog.schemaVersion == EmojiCatalog.supportedSchemaVersion else {
            throw EmojiCatalogValidationError.unsupportedSchemaVersion(catalog.schemaVersion)
        }
        guard !catalog.categories.isEmpty else {
            throw EmojiCatalogValidationError.emptyCategories
        }
        guard !catalog.items.isEmpty else {
            throw EmojiCatalogValidationError.emptyItems
        }

        var categoryIds = Set<String>()
        for category in catalog.categories {
            if categoryIds.contains(category.id) {
                throw EmojiCatalogValidationError.duplicateCategoryId(category.id)
            }
            categoryIds.insert(category.id)
        }

        var itemIds = Set<String>()
        for item in catalog.items {
            if itemIds.contains(item.id) {
                throw EmojiCatalogValidationError.duplicateItemId(item.id)
            }
            itemIds.insert(item.id)

            // Favorites is a user list, not a catalog ownership category for items.
            if item.categoryId == "favorites" || !categoryIds.contains(item.categoryId) {
                throw EmojiCatalogValidationError.invalidCategoryReference(
                    itemId: item.id,
                    categoryId: item.categoryId
                )
            }
        }
    }
}

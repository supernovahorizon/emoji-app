# Asset Provenance — KATSEYE Pastel Theme

## Source kit

| Source | Location in repo / machine |
|--------|----------------------------|
| Asset kit archive | `docs/raw-requirements/KATSEYE-KEYBOARD-ASSET-KIT-V2.zip` |
| Kit internal root | `KATSEYE-PASTEL-KEYBOARD-ASSET-KIT/` |

## Imported into production targets

### From kit (personal-use photo backgrounds)

| File in kit | Imported as |
|-------------|-------------|
| `Backgrounds/PersonalUsePhoto/keyboard-photo-soft-1170x780.png` | `SupernovaEmojiKeyboard/.../KatseyePhotoBackground.imageset` |

Derived from the user-supplied KATSEYE reference photo in the kit (`Reference/katseye-source-reference.webp`). **Personal/local builds only.** Do not assume App Store rights for this photo/likeness.

### From kit (store-safer abstract)

| File in kit | Imported as |
|-------------|-------------|
| `Backgrounds/StoreSafeAbstract/keyboard-pastel-prism-1170x780.png` | Keyboard + companion abstract preview assets |
| `Charms/PNG/*-256.png` | `katseyeCharm*.imageset` (keyboard) |
| `Buttons/PNG/key-*.png` | `PastelGemKey*.imageset` |
| `AppIcons/AppIcon-GemEye-1024.png` | App `AppIcon` |
| `iOS/Code/PastelGemEmojiCombos.json` | `EmojiCore/Resources/katseye_combos.json` (merged into catalog) |

### Original / graphic kit assets

Charms, abstract prism backgrounds, key skins, and GemEye app icon are described by the kit as original graphic assets (not official KATSEYE merch). They remain safer for a future public build than the personal photo.

## Runtime selection

```swift
enum KatseyeBackgroundVariant {
    case personalPhoto   // current local default
    case abstractPastel  // store-safer switch
}
```

`KatseyeBackgroundVariant.current` is set to `.personalPhoto` for this personal build. Flip to `.abstractPastel` for public/App Store-oriented builds without redesigning the theme.

## Not claimed

This project does **not** claim ownership of third-party KATSEYE photography, trademarks, or official branding. Photo-based assets are for personal/local development use as provided by the user via the asset kit.

## Removed / superseded

- Earlier AI-generated dark stage wallpaper and hand-made pink logo badge used before the kit was available have been replaced by kit assets for the KATSEYE pastel theme.

## App icon (updated)

**Official KATSEYE symbol** from the official shop CDN:

`https://shop.katseye.world/cdn/shop/files/04_KATSEYE_Symbol_Black.png`

| Path | Notes |
|------|--------|
| `docs/assets/official-katseye-symbol-source.png` | Downloaded source |
| `SupernovaEmoji/Assets.xcassets/AppIcon.appiconset/AppIcon.png` | 1024×1024 RGB, white bg, safe margin |

Apple requires 1024×1024 app icons without transparency. Trademark: HYBE/Geffen — personal/local use only.

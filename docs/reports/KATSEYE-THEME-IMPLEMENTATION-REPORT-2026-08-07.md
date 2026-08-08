# KATSEYE Theme Implementation Report

**Date:** 2026-08-07  
**Branch:** `feat/keyboard-mvp`  
**Theme ID:** `katseye.pastel`

## Summary

Implemented the KATSEYE pastel keyboard experience from `KATSEYE-KEYBOARD-ASSET-KIT-V2.zip`: personal-use photo background, frosted pastel keys, dedicated KATSEYE emoji-combo category, GemEye app icon, companion theme preview, provenance docs, and regression tests. Privacy-first keyboard rules preserved (no Full Access, no typed-text logging, no network).

## Theme architecture

- `KeyboardTheme.katseyePastel` (`katseye.pastel`) — default
- Legacy ids `katseye`, `system`, `pastelGem` migrate to pastel
- `KatseyeBackgroundVariant` — `.personalPhoto` (current) / `.abstractPastel` (store-safer)
- `KeyboardThemePalette` — pastel gem tokens from kit `palette.json`
- Catalog category `katseye` with 12 insertable Unicode combos from kit JSON

## Background in use

**Personal photo soft keyboard background**  
`KatseyePhotoBackground` ← `keyboard-photo-soft-1170x780.png`  
Veil + glow for frosted key / ink contrast.

## KATSEYE category

- Toolbar category with gem-eye charm
- Inserts Unicode combos (e.g. `💎👁️✨`) via `insertText`
- Charms used as UI decoration only (not pretended as new Unicode emoji)

## App icon

**GemEye** 1024 (`AppIcon-GemEye-1024.png`)

## Validation

| Check | Result |
|-------|--------|
| Simulator build | PASS (run during implementation) |
| Unit tests | PASS (including Katseye + metrics) |
| Device build | PASS |
| Device install | PASS |
| Device launch | PASS / or trust if needed |
| Full Access | remains OFF |
| Privacy check | PASS |

## Performance notes

- Charm PNGs limited to 256px variants
- Single photo background loaded for keyboard (not all variants at once)
- No animated backgrounds / continuous blur
- Board height still clamped via `KeyboardMetrics` (anti-zoom)

## Accessibility

- ≥44pt targets on category chips and action keys
- Labels for KATSEYE category, globe, backspace, emoji toggle
- Selected category traits retained

## Privacy

- No new network APIs
- No clipboard/sticker paste in keyboard
- Photo asset is local bundled only

## Known issues

- Personal photo not App Store–safe without rights; switch `KatseyeBackgroundVariant.current` to `.abstractPastel` for public builds
- Keyboard and companion theme prefs still not App Group–shared

## Remaining work

- Optional alternate icons (PrismStar / RibbonGem)
- Optional App Group theme sync
- Human Notes smoke: insert combos, rotate, globe

## Commits

See `git log --oneline` on `feat/keyboard-mvp` for the theme series ending with this report.

# Handoff

## Completed

Initial MVP bootstrap for Supernova Emoji:

- Repository controls (AGENTS, docs, scripts, Makefile, CI)
- XcodeGen project: app, keyboard extension, unit/UI test targets
- EmojiCore: catalog, models, validator, preferences stores
- Keyboard: SwiftUI UI hosted in UIInputViewController; insert/delete/globe
- Companion app: onboarding, privacy, enablement, explorer, themes, help, diagnostics
- Privacy checks, simulator build/tests, device deploy attempt

## Architecture

- `EmojiCore` — shared pure Swift domain (compiled into app + keyboard)
- `SupernovaEmoji` — SwiftUI companion app
- `SupernovaEmojiKeyboard` — custom keyboard extension (`RequestsOpenAccess=false`)
- Preferences: `InMemoryPreferencesStore`, `LocalPreferencesStore`, `FallbackPreferencesStore`
- Catalog: `Resources/emoji_catalog.json` (schemaVersioned)

## Validation commands

```bash
make bootstrap
make validate
make privacy-check
make device-list
make device-build
```

## Physical device

- Target class: iPhone 13 Pro / iOS 26.x family when connected
- Device build: success
- Device install: success
- Device launch: blocked — trust developer profile (Settings → General → VPN & Device Management)
- Keyboard still requires manual iOS Settings enablement (Full Access OFF)

## Known issues

- Free personal team requires Trust Developer App before first launch
- Without App Groups, favorites/recents in keyboard and app are separate containers
- UITests are smoke-level only

## Exact next task

1. User trusts developer certificate and confirms welcome UI.
2. Enable keyboard with Full Access OFF; smoke-test insert/backspace/globe.
3. Expand emoji catalog density while keeping validator tests green.

## Branch

`feat/keyboard-mvp`

## Latest commit

Run: `git log -1 --oneline`

# Architecture

## Targets

| Target | Type | Bundle ID |
|--------|------|-----------|
| SupernovaEmoji | iOS App | com.supernovahorizon.emoji |
| SupernovaEmojiKeyboard | Keyboard extension | com.supernovahorizon.emoji.keyboard |
| SupernovaEmojiTests | Unit tests | — |
| SupernovaEmojiKeyboardTests | Unit tests | — |
| SupernovaEmojiUITests | UI tests | — |

## Shared domain: EmojiCore

Compiled into app and keyboard (shared sources, not a separate dylib in MVP).

```
EmojiCore/
  Models/          EmojiItem, EmojiCategory, KeyboardTheme, KeyboardPreferences
  Catalog/         EmojiCatalog, loader, validator
  Preferences/     KeyboardPreferencesStore + implementations
  Input/           TextInputHandling
  Resources/       emoji_catalog.json
```

## Keyboard

```
UIInputViewController (KeyboardViewController)
  └─ UIHostingController<KeyboardRootView>
       ├─ Category toolbar
       ├─ Emoji grid
       └─ Action bar (backspace, globe)
```

Actions go through `TextInputHandling`:

- `insertText`
- `deleteBackward`
- `advanceToNextInputMode`

Production adapter uses `UITextDocumentProxy` / `advanceToNextInputMode()`.

## Preferences

```
KeyboardPreferencesStore
  ├─ InMemoryPreferencesStore     (tests)
  ├─ LocalPreferencesStore        (UserDefaults)
  └─ FallbackPreferencesStore     (primary + fallback)
```

App Groups are optional and not required for MVP.

## Configuration

- `Config/Shared.xcconfig` — source-controlled build settings
- `Config/Local.example.xcconfig` — template for DEVELOPMENT_TEAM
- `Config/Local.xcconfig` — gitignored local team

## Privacy boundaries

- Keyboard Info.plist: `RequestsOpenAccess = false`
- No URLSession / network frameworks in product targets
- Logging: event names only; never emoji characters or surrounding text

## Project generation

`project.yml` → `xcodegen generate` → `SupernovaEmoji.xcodeproj`

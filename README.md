# Supernova Emoji

Privacy-first, ad-free custom emoji keyboard and companion app for iOS / iPadOS.

## Features (MVP)

- Custom keyboard extension with Unicode emoji categories
- Favorites and recent emojis (local only)
- Child-friendly companion app for setup, preview, and themes
- Offline by design — no accounts, ads, analytics, or tracking
- Full Access **not** required

## Requirements

- macOS with Xcode 16+ (developed against Xcode 26 / iOS 26 SDK)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
- Apple Development signing identity (for device builds)

## Quick start

```bash
make bootstrap   # generate project, copy Local.xcconfig if missing
make build       # simulator build (unsigned)
make test        # unit tests on simulator
make validate    # build + test + privacy + clean-tree checks
```

### Local signing (device only)

```bash
cp Config/Local.example.xcconfig Config/Local.xcconfig
# Edit DEVELOPMENT_TEAM in Config/Local.xcconfig (never commit this file)
make device-build
```

### Enable the keyboard on device

1. Install **Supernova Emoji** from Xcode / `make device-install`
2. Settings → General → Keyboard → Keyboards → Add New Keyboard → **Supernova Emoji**
3. Keep **Allow Full Access** **OFF**

## Project structure

See `AGENTS.md` and `docs/ARCHITECTURE.md`.

## Privacy

See `PRIVACY.md` and `docs/PRIVACY-DATA-MAP.md`.

## License

Proprietary — Supernova Horizon. All rights reserved unless otherwise noted.

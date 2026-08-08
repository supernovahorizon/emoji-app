# Security Policy

## Supported versions

Security fixes target the active development branch (`feat/keyboard-mvp` and subsequent release branches).

## Reporting a vulnerability

Please report security issues via GitHub Security Advisories for this repository when available, or a private maintainer channel.

Do **not** open a public issue that includes:

- exploit details that endanger users before a fix;
- personal data, device identifiers, or signing materials.

## Security design goals

- Offline product operation
- No Full Access for the keyboard extension
- No network clients in app/keyboard product code
- No third-party SDKs in the MVP
- Signing artifacts and Team IDs never committed
- Minimal local preference storage; never store typed text

## Hard rules for contributors and agents

- Do not add `URLSession`, sockets, remote WebViews, analytics, ads, or crash SDKs without an explicit decision record
- Do not set `RequestsOpenAccess` to `true`
- Do not commit `Config/Local.xcconfig`, `*.p12`, `*.mobileprovision`, private keys, or Team IDs
- Run `make privacy-check` before pushing product changes

# AGENTS.md — Supernova Emoji

Guidance for any AI coding agent continuing this repository.

## Product

**Supernova Emoji** is a privacy-first, ad-free custom emoji keyboard and companion iOS app.

- No ads, subscriptions, accounts, analytics, or tracking
- No network access in product code
- No Full Access requirement (`RequestsOpenAccess = false`)
- No collection or logging of typed content
- Zero third-party dependencies unless explicitly justified in `agent/DECISIONS.md`

## Repository layout

| Path | Purpose |
|------|---------|
| `EmojiCore/` | Shared domain models, catalog, preferences |
| `SupernovaEmoji/` | Companion app (SwiftUI) |
| `SupernovaEmojiKeyboard/` | Custom keyboard extension |
| `SupernovaEmojiTests/` | App + core unit tests |
| `SupernovaEmojiKeyboardTests/` | Keyboard-focused unit tests |
| `SupernovaEmojiUITests/` | UI tests (smoke) |
| `Config/` | Shared xcconfig; local team id ignored |
| `agent/` | Live task/status/decisions/handoff for agents |
| `docs/` | Design, architecture, testing, privacy |
| `reports/` | Implementation reports |
| `scripts/` | Validation and privacy checks |
| `project.yml` | XcodeGen project definition |

## Working branch

Primary development branch: `feat/keyboard-mvp`

Do not commit product work directly to `main` unless explicitly instructed.

## Mandatory workflow

1. Read `agent/HANDOFF.md` and `agent/STATUS.md`
2. Pick the next incomplete task from `agent/TASKS.md`
3. Implement with focused validation (`make validate` when applicable)
4. Update agent trackers
5. Conventional commit per logical task
6. `git push`
7. Confirm `git status --short` is empty

## Privacy absolutes

Never commit:

- personal data, Apple ID, Team ID, UDID, serials
- provisioning profiles, certificates, private keys
- `Config/Local.xcconfig`

Never add networking, analytics, ads, crash SDKs, or Full Access for the keyboard.

## Validation commands

```bash
make bootstrap
make build
make test
make validate
make privacy-check
make clean-check
make device-list
make device-build
```

## Signing

- Bundle IDs: `com.supernovahorizon.emoji`, `com.supernovahorizon.emoji.keyboard`
- Copy `Config/Local.example.xcconfig` → `Config/Local.xcconfig` and set `DEVELOPMENT_TEAM` locally
- Team ID must never be committed

## Regenerating the Xcode project

```bash
xcodegen generate
```

Only one agent may modify `project.yml` / generated project at a time.

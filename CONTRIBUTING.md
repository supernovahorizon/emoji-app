# Contributing

## Principles

1. Privacy and offline operation are non-negotiable for the MVP.
2. Prefer Apple SDKs; justify any third-party dependency in `agent/DECISIONS.md`.
3. Keep keyboard code free of networking and private-data APIs.
4. Every logical task gets a conventional commit and a clean tree after push.

## Setup

```bash
brew install xcodegen   # if needed
make bootstrap
make validate
```

Copy `Config/Local.example.xcconfig` to `Config/Local.xcconfig` only for device builds. Never commit it.

## Workflow

1. Branch from `feat/keyboard-mvp` (or the active feature branch named by maintainers).
2. Implement with tests for core logic.
3. Run `make validate`.
4. Update `agent/TASKS.md` / `agent/STATUS.md` when changing agent-owned workstreams.
5. Commit with conventional messages (`feat:`, `fix:`, `test:`, `docs:`, `chore:`, `build:`, `ci:`).
6. Push; do not force-push shared branches.

## Code style

- Value types for domain models
- Dependency injection for testability
- Explicit errors; no swallowed failures
- Accessibility: ≥44pt targets, VoiceOver labels, Dynamic Type for companion text
- No force unwraps unless mathematically guaranteed and documented

## What not to contribute

- Analytics, ads, accounts, cloud sync
- Full Access keyboard networking
- Personal data, screenshots with private content
- Signing credentials or Team IDs

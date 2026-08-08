# Tasks — Supernova Emoji

Legend: `[ ]` not started · `[-]` in progress · `[x]` complete · `[!]` blocked

## Initial bootstrap

[x] Task 1 — Audit repository
    Acceptance: safe to initialize; remote known
    Validation: git status / remote / branch
    Commit: (bootstrap series)

[x] Task 2 — Create development branch `feat/keyboard-mvp`
    Acceptance: branch exists and is used for work
    Validation: git branch --show-current
    Commit: (branch created pre-first-commit)

[x] Task 3 — Repository safety baseline
    Acceptance: docs, agent trackers, scripts, gitignore present
    Validation: make privacy-check (scripts present)
    Commit: see git log chore(repo)

[x] Task 4 — Xcode app and keyboard extension
    Acceptance: app + keyboard compile for simulator; RequestsOpenAccess=false
    Validation: make build
    Commit: see git log build(ios)

[x] Task 5 — Core models and catalog
    Acceptance: models, catalog, validator, preferences + unit tests
    Validation: make test
    Commit: see git log feat(core)

[x] Task 6 — Functional keyboard skeleton
    Acceptance: categories, grid, insert, backspace, globe, light/dark
    Validation: make validate
    Commit: see git log feat(keyboard)

[x] Task 7 — Companion application
    Acceptance: welcome, privacy, enablement, explorer, themes, help, diagnostics
    Validation: make build
    Commit: see git log feat(app)

[x] Task 8 — Device discovery
    Acceptance: iPhone 13 Pro detected without storing UDID
    Validation: make device-list
    Commit: report only

[x] Task 9 — Physical device build
    Acceptance: device build succeeds or blocker documented
    Validation: make device-build
    Commit: report

[x] Task 10 — Install and launch
    Acceptance: app installed and launched or blocker documented
    Validation: make device-install / device-launch
    Commit: report

[x] Task 11 — Keyboard device readiness
    Acceptance: extension embedded; human enablement steps documented
    Validation: build embed + report
    Commit: report

[x] Task 12 — Full validation
    Acceptance: make validate / privacy-check / clean-check pass
    Validation: make validate
    Commit: final docs

[x] Task 13 — Final report
    Acceptance: report + trackers committed and pushed
    Validation: git status --short empty
    Commit: docs(report)

## Next (post-bootstrap)

[ ] Expand emoji catalog density per category
[ ] Optional App Group preference sync (capability-gated)
[ ] On-device keyboard insertion smoke checklist with user
[ ] App Store metadata draft from docs/APP-STORE-READINESS.md

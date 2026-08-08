# Supernova Emoji — Initial Grok Build Execution Prompt

**Repository:** `supernovahorizon/emoji-app`  
**Project:** Supernova Emoji  
**Platform:** iOS / iPadOS  
**Primary language:** Swift  
**UI:** SwiftUI companion app + Custom Keyboard Extension  
**Primary build agent:** Grok Build  
**Current repository state:** Fresh clone / blank repository  
**Primary test device:** iPhone 13 Pro running iOS 26, already connected to this Mac  
**Apple development account:** Already configured on this Mac/Xcode  
**Working branch:** `feat/keyboard-mvp`

---

## 1. Mission

You are the primary implementation agent for **Supernova Emoji**, a privacy-first, ad-free custom emoji keyboard and companion iOS app.

Build the project professionally from the current blank repository.

The application must eventually provide:

- A real iOS custom emoji keyboard extension.
- Unicode emoji categories.
- Favorites and recent emojis.
- A simple child-friendly interface.
- A companion app for onboarding, keyboard setup instructions, previewing emojis, and themes.
- No ads.
- No subscriptions.
- No accounts.
- No analytics.
- No tracking.
- No network access.
- No Full Access requirement.
- No collection or logging of typed content.
- No third-party dependencies unless absolutely required and explicitly justified.

This repository must be designed so another AI coding agent can safely continue development at any time.

---

# 2. Operating Mode

Work autonomously.

Do **not** stop to ask the user routine engineering questions.

When several reasonable implementation choices exist:

1. choose the safest conventional option;
2. document the decision;
3. continue.

Only stop for a genuine external blocker that cannot be solved from the repository or development environment.

Examples:

- macOS asks the human to approve a signing/login prompt;
- the connected iPhone must be unlocked;
- Developer Mode must be enabled manually;
- iOS requires the human to enable the custom keyboard in Settings;
- a physical-device trust prompt requires interaction.

Even when blocked by one of those steps, complete every other non-blocked task first.

---

# 3. Important User Interaction Rule

The terminal/on-screen response shown to the user at the end of your run must be **very short**.

Do not dump large implementation summaries into the terminal.

Instead, save detailed progress in a repository report.

At the end, print only something similar to:

```text
Done.
Phase: <phase>
Report: reports/<report-file>.md
Commit: <latest-commit>
Push: successful
Device: <installed / blocker>
Tree: clean
```

If blocked:

```text
Blocked: <one short reason>
Human action: <one short instruction>
Report: reports/<report-file>.md
Tree: clean
```

The detailed explanation belongs in the report committed to Git.

---

# 4. Mandatory Repository Documentation

Create these files immediately:

```text
AGENTS.md

agent/
├── TASKS.md
├── STATUS.md
├── DECISIONS.md
└── HANDOFF.md

reports/
└── IMPLEMENTATION-REPORT-INITIAL-BOOTSTRAP-YYYY-MM-DD.md

docs/
├── DESIGN.md
├── ARCHITECTURE.md
├── TESTING.md
├── PRIVACY-DATA-MAP.md
└── APP-STORE-READINESS.md
```

Also create:

```text
README.md
PRIVACY.md
SECURITY.md
CONTRIBUTING.md
.gitignore
Makefile
```

The existing Supernova Emoji design requirements should be captured in `docs/DESIGN.md`.

---

# 5. Agent Progress Tracking

## `agent/TASKS.md`

Maintain a real implementation checklist.

Use:

```text
[ ] not started
[-] in progress
[x] complete
[!] blocked
```

Every completed task must include:

- acceptance criteria;
- validation performed;
- Git commit hash.

Example:

```text
[x] Create iOS app and keyboard targets
    Acceptance: app and extension compile successfully
    Validation: make build
    Commit: abc1234
```

---

## `agent/STATUS.md`

Always keep this current.

Include:

- current phase;
- current branch;
- latest validated commit;
- what currently works;
- tests currently passing;
- physical-device state;
- known blockers;
- next three tasks.

---

## `agent/DECISIONS.md`

Record architectural choices.

Format:

```text
Date | Decision | Reason | Alternatives | Consequences
```

Never store personal information here.

---

## `agent/HANDOFF.md`

This is the next-agent starting point.

It must contain:

- what was completed;
- current architecture;
- validation commands;
- current physical-device status;
- known issues;
- exact next task;
- latest commit;
- branch name.

---

# 6. Implementation Report

Create:

```text
reports/IMPLEMENTATION-REPORT-INITIAL-BOOTSTRAP-YYYY-MM-DD.md
```

Update it throughout the run.

The report must contain:

## Executive Summary

Very short description of what was accomplished.

## Repository State

- branch;
- commits created;
- remote;
- pushed state;
- clean-tree confirmation.

## Architecture Created

Summarize targets, shared code, configuration, and storage design.

## Files Added / Changed

List the important files.

## Build Results

Record:

- simulator build;
- unit tests;
- device build;
- device install;
- device launch.

## iPhone Validation

Record:

- device detected;
- target iOS version;
- signing result;
- app installed;
- app launched;
- keyboard extension embedded;
- any human action still needed.

Do **not** record:

- device UDID;
- Apple ID;
- personal email address;
- development team identifier;
- device serial number.

## Security / Privacy Validation

Record checks performed.

## Tests

List tests and results.

## Git History

List commits created during the run.

## Blockers

Only real blockers.

## Next Recommended Tasks

Maximum 5 items.

The report must be committed and pushed before finishing.

---

# 7. Git Discipline — Mandatory

These rules are absolute.

## Branch

Determine the repository's current default branch.

Create:

```text
feat/keyboard-mvp
```

Do all implementation work there.

Do not develop directly on `main`.

---

## Commit rule

After **every completed logical task**:

1. run focused validation;
2. update agent tracking files;
3. commit the task;
4. push the branch;
5. verify the working tree is clean.

A task is not complete until it is committed and pushed.

Use conventional commits.

Examples:

```text
chore(repo): establish agentic project controls
build(ios): create app and keyboard targets
feat(core): add emoji catalog models
feat(keyboard): add emoji grid
feat(keyboard): support text input actions
feat(app): add onboarding experience
test(core): add catalog validation tests
docs(report): update initial implementation report
```

Never use vague messages such as:

```text
changes
update
fix stuff
misc
```

---

## Push rule

After every successful task commit:

```bash
git push -u origin feat/keyboard-mvp
```

or, once upstream exists:

```bash
git push
```

If push fails:

- investigate;
- fix safely if possible;
- document failure;
- never pretend push succeeded.

Never force-push.

---

## Clean-tree rule

After every task:

```bash
git status --short
```

Expected output:

```text
<empty>
```

Before ending the run:

```bash
git status --short
```

must be empty.

If generated files should not be tracked:

- remove them; or
- intentionally add them to `.gitignore`.

Never end with uncommitted or untracked project files.

---

# 8. Git Safety

Before changing code:

```bash
git status
git remote -v
git branch --show-current
git log --oneline --decorate -10
```

Do not:

- rewrite history;
- force-push;
- delete unknown user work;
- reset destructive changes;
- commit credentials;
- commit generated signing files.

If unexpected pre-existing user modifications are found, preserve them and document them before proceeding.

---

# 9. Privacy Rules — Release Blockers

The repository must contain no personal information.

Never commit:

- child name;
- child age;
- birthdays;
- school name;
- personal photos;
- personal email addresses;
- Apple ID;
- Apple account details;
- development Team ID;
- device UDID;
- device serial number;
- provisioning profile;
- signing certificate;
- `.p12`;
- `.mobileprovision`;
- private key;
- passwords;
- tokens;
- secrets;
- screenshots containing personal notifications/messages.

Use generic names only.

Allowed product naming:

```text
Supernova Emoji
SupernovaEmoji
SupernovaEmojiKeyboard
EmojiCore
```

---

# 10. Keyboard Privacy Architecture

The keyboard must operate completely offline.

The MVP must contain:

```text
RequestsOpenAccess = false
```

Do not request Full Access.

Do not implement:

- URLSession networking;
- sockets;
- web views for remote content;
- analytics;
- telemetry;
- advertising;
- crash-reporting SDKs;
- cloud sync;
- clipboard reading;
- contacts;
- photos;
- microphone;
- camera;
- location;
- typed-text logging;
- surrounding-text storage;
- host-application tracking.

The keyboard may locally persist only product preferences such as:

- selected theme;
- selected category;
- favorite emoji IDs;
- bounded recent emoji IDs.

Never store what the user typed.

---

# 11. Logging Rules

Production logs must never contain:

- selected emoji characters;
- surrounding text;
- text before cursor;
- text after cursor;
- host application;
- personal data.

Debug logging should be minimal.

Good:

```text
keyboard_loaded
catalog_loaded
catalog_decode_failed
preferences_reset
```

Bad:

```text
user_inserted_😀
message_text=...
host_app=Messages
```

---

# 12. Dependencies

Use Apple SDKs whenever possible.

Expected third-party dependency count for the MVP:

```text
0
```

Do not add a dependency just for convenience.

If a dependency becomes unavoidable:

1. explain the problem;
2. review the license;
3. review privacy implications;
4. review keyboard memory/size implications;
5. record the decision in `agent/DECISIONS.md`.

---

# 13. Xcode Project

Create:

```text
SupernovaEmoji.xcodeproj
```

Targets:

```text
SupernovaEmoji
SupernovaEmojiKeyboard
SupernovaEmojiTests
SupernovaEmojiUITests
SupernovaEmojiKeyboardTests
```

Shared domain layer:

```text
EmojiCore
```

Prefer a simple shared source module initially.

Do not over-engineer the project.

---

# 14. Bundle Identifiers

Use source-controlled generic identifiers:

```text
com.supernovahorizon.emoji
com.supernovahorizon.emoji.keyboard
```

Any local signing-specific values must remain outside committed source if they expose account/team information.

Create source-controlled examples where needed:

```text
Config/Local.example.xcconfig
```

Ignore:

```text
Config/Local.xcconfig
```

Never commit the development Team ID.

---

# 15. First Functional Scope

Build the initial working vertical slice.

## Companion app

Implement:

- welcome screen;
- privacy message;
- keyboard enablement instructions;
- emoji preview;
- category browser;
- basic theme preview;
- help screen;
- diagnostics screen containing only non-sensitive build information.

---

## Keyboard extension

Implement:

- emoji category toolbar;
- emoji grid;
- tap emoji;
- backspace;
- globe/next-keyboard button;
- safe fallback category;
- portrait support;
- landscape support;
- light mode;
- dark mode.

Use:

```swift
textDocumentProxy.insertText(...)
textDocumentProxy.deleteBackward()
advanceToNextInputMode()
```

A visible globe/next-keyboard control must always remain available.

---

# 16. Initial Emoji Categories

Start with:

```text
Favorites
Smileys
Animals
Food
Activities
Nature
Hearts & Celebrations
Symbols
```

Use Unicode emoji characters.

Do not redistribute Apple's emoji image assets.

Do not copy another emoji keyboard's graphics, branding, screenshots, theme artwork, or proprietary layout.

---

# 17. Core Architecture

Create lightweight models such as:

```swift
EmojiItem
EmojiCategory
KeyboardTheme
KeyboardPreferences
```

Create storage abstraction:

```swift
protocol KeyboardPreferencesStore
```

Implement:

```text
InMemoryPreferencesStore
LocalPreferencesStore
FallbackPreferencesStore
```

App Group support is optional and capability-gated.

The MVP must work without App Groups.

Do not add a database.

---

# 18. Testing Requirements

Testing is part of implementation, not a later cleanup task.

Create unit tests for:

- catalog loading;
- duplicate IDs;
- invalid category references;
- unsupported schema versions;
- preferences;
- favorites;
- recent emojis;
- theme resolution;
- keyboard category selection;
- keyboard action dispatch;
- fallback storage.

Where possible, abstract keyboard actions behind a testable protocol.

Example:

```swift
protocol TextInputHandling {
    func insertText(_ text: String)
    func deleteBackward()
    func advanceToNextInputMode()
}
```

Use a production adapter for the real keyboard controller.

---

# 19. Build Scripts

Create stable commands.

At minimum:

```text
make bootstrap
make build
make test
make validate
make privacy-check
make clean-check
make device-list
make device-build
```

`make validate` should run all safe automated validation required before a task can be committed.

Do not hard-code a simulator UUID or physical-device UDID.

Discover them dynamically.

---

# 20. Simulator Validation

Build the containing app without signing.

Example pattern:

```bash
xcodebuild \
  -project SupernovaEmoji.xcodeproj \
  -scheme SupernovaEmoji \
  -sdk iphonesimulator \
  -configuration Debug \
  CODE_SIGNING_ALLOWED=NO \
  build
```

Use an installed simulator chosen dynamically.

Do not assume a specific personal simulator identifier.

---

# 21. Physical iPhone Deployment — Required

The user's:

```text
iPhone 13 Pro
iOS 26
```

is already connected to this Mac.

The Apple development account has already been configured previously.

Once the initial app builds successfully, deploy it to the connected iPhone.

Do not merely stop after Simulator success.

---

## Device discovery

Use supported Xcode command-line tooling to discover the connected device.

Examples may include:

```bash
xcrun devicectl list devices
```

and Xcode destination discovery.

Do not write the device UDID into committed files or reports.

Do not hard-code it into scripts.

It may be used transiently during the local command execution.

---

## Device build

Use the locally configured automatic signing setup.

The project must never commit:

- Apple account email;
- Team ID;
- provisioning profile;
- certificate;
- device UDID.

Build for the connected device using the discovered destination.

Prefer automatic signing.

If Xcode already knows the signing account, use that configuration rather than creating new credentials.

---

## Install

After successful device build:

- install the containing app on the connected iPhone;
- confirm installation succeeded.

Use supported Xcode command-line tooling such as `devicectl` where appropriate.

---

## Launch

Launch:

```text
Supernova Emoji
```

on the connected iPhone.

Verify:

- app opens;
- welcome UI displays;
- no crash;
- extension is embedded in the containing app.

---

# 22. Human iPhone Steps

Some iOS keyboard-extension actions may require manual interaction.

If required, give the user only the exact shortest instruction.

For example:

```text
Open Settings → General → Keyboard → Keyboards → Add New Keyboard → Supernova Emoji.
```

Then:

```text
Keep Allow Full Access OFF.
```

Do not ask the user to enable Full Access.

If device trust or Developer Mode is required, state the exact required action.

Do not dump long instructions into the terminal; place full instructions in the implementation report.

---

# 23. Device Validation

Once the keyboard can be enabled, validate on the physical iPhone when technically possible.

Use a blank safe test field.

Verify:

- keyboard appears;
- category switching works;
- emoji insertion works;
- backspace works;
- globe button works;
- Full Access remains off;
- portrait layout works;
- landscape layout works;
- companion app launches independently.

Never commit screenshots containing personal content.

---

# 24. Security Checks

Create:

```text
scripts/privacy-check.sh
scripts/clean-tree-check.sh
```

Check for at least:

- secrets;
- private keys;
- signing artifacts;
- provisioning profiles;
- suspicious personal emails;
- networking APIs;
- Full Access configuration;
- forbidden permissions.

Scan for files such as:

```text
*.p12
*.mobileprovision
*.cer
*.key
```

Scan source for suspicious use of:

```text
URLSession
NWConnection
UIPasteboard
PHPhotoLibrary
CNContactStore
CLLocationManager
AVCaptureDevice
RequestsOpenAccess
```

The presence of a symbol is not automatically an error if intentionally used by tooling/tests, but every finding must be reviewed.

For the keyboard target, network and private-data APIs should be absent.

---

# 25. `.gitignore`

At minimum exclude:

```text
.DS_Store
DerivedData/
build/
*.xcuserstate
xcuserdata/
*.xccheckout
Config/Local.xcconfig
*.mobileprovision
*.p12
*.cer
*.key
```

Also exclude appropriate temporary Xcode and macOS files.

Do not ignore important project source accidentally.

---

# 26. Accessibility

From the first implementation:

- interactive targets minimum 44 × 44 points;
- VoiceOver labels;
- selected category accessibility state;
- light/dark mode;
- Dynamic Type for companion text;
- avoid relying only on color;
- Reduce Motion-friendly behavior.

Do not postpone basic accessibility until the end.

---

# 27. Engineering Quality

Use:

- Swift concurrency safely where needed;
- `Sendable` where appropriate;
- value types for domain models;
- explicit error types;
- dependency injection for testability;
- small focused views;
- clear naming;
- no massive view controllers;
- no global mutable state;
- no unnecessary singletons;
- no force unwraps unless mathematically guaranteed and documented;
- no swallowed errors;
- no duplicated business logic;
- no premature abstraction.

Prefer simple code over clever code.

---

# 28. Swift / Xcode Quality

Build with the stable Swift language mode supported by the installed Xcode.

Enable useful compiler warnings.

Treat new warnings as defects whenever practical.

Do not commit code that introduces unexplained warnings.

Do not manually edit Xcode project internals recklessly.

Only one task/subagent may modify `project.pbxproj` at a time.

---

# 29. Subagent Rules

You may use specialized subagents for:

- repository setup;
- iOS architecture;
- keyboard extension;
- core models;
- testing;
- accessibility;
- privacy/security;
- CI.

Subagent tasks must be narrowly scoped.

Every subagent must receive:

- exact task;
- files it may modify;
- acceptance criteria;
- validation command.

Never allow multiple subagents to edit the Xcode project file simultaneously.

If concurrent Git work is unsafe, serialize tasks.

The primary Grok Build agent remains responsible for:

- integration;
- validation;
- commits;
- pushes;
- clean working tree.

---

# 30. CI

Add GitHub Actions after local builds are working.

CI should:

- build unsigned for Simulator;
- run unit tests;
- run privacy/security checks;
- require no signing secrets;
- use least-privilege permissions.

Example:

```yaml
permissions:
  contents: read
```

Do not configure App Store signing or upload secrets during this initial run.

---

# 31. Exact First-Run Task Order

Proceed in this order.

## Task 1 — Audit repository

Inspect:

```bash
pwd
git status
git remote -v
git branch -a
git log --oneline --decorate -10
```

Confirm it is safe to initialize.

---

## Task 2 — Create development branch

Create:

```text
feat/keyboard-mvp
```

Push the branch.

---

## Task 3 — Repository safety baseline

Create:

- `.gitignore`;
- `AGENTS.md`;
- `README.md`;
- `PRIVACY.md`;
- `SECURITY.md`;
- `CONTRIBUTING.md`;
- agent tracking files;
- reports directory;
- docs directory;
- initial scripts.

Run privacy scan.

Update tracker.

Commit.

Push.

Verify clean tree.

---

## Task 4 — Xcode app and keyboard extension

Create:

```text
SupernovaEmoji
SupernovaEmojiKeyboard
EmojiCore
```

Configure source-controlled generic bundle identifiers.

Configure keyboard extension:

```text
RequestsOpenAccess = false
```

Ensure the keyboard extension is embedded in the app.

Build Simulator.

Update tracker/report.

Commit.

Push.

Verify clean tree.

---

## Task 5 — Core models and catalog

Implement:

- emoji models;
- categories;
- catalog;
- validator;
- preferences;
- local storage abstraction.

Add tests.

Run tests.

Update tracker/report.

Commit.

Push.

Verify clean tree.

---

## Task 6 — Functional keyboard skeleton

Implement:

- SwiftUI keyboard root;
- UIKit `UIInputViewController` host;
- category toolbar;
- emoji grid;
- insertion;
- backspace;
- globe key;
- fallback state.

Add tests.

Run validation.

Update tracker/report.

Commit.

Push.

Verify clean tree.

---

## Task 7 — Companion application

Implement:

- welcome;
- privacy card;
- enablement guide;
- emoji explorer;
- keyboard preview;
- basic themes;
- help;
- diagnostics.

Run validation.

Update tracker/report.

Commit.

Push.

Verify clean tree.

---

## Task 8 — Device discovery

Discover connected iOS devices.

Find the connected iPhone 13 Pro.

Do not persist its identifiers.

Record only:

```text
iPhone 13 Pro detected: yes/no
iOS version detected: <version>
```

in the report.

---

## Task 9 — Physical device build

Use existing Xcode signing configuration.

Build the app for the connected iPhone.

Resolve normal project signing configuration issues without exposing account information.

If a macOS/iOS human approval is required, finish all other work first and then provide the minimal instruction.

Update report.

---

## Task 10 — Install and launch

Install the app on the connected iPhone.

Launch it.

Verify initial UI.

Record results.

Do not commit personal device identifiers.

---

## Task 11 — Keyboard device readiness

Confirm keyboard extension is embedded.

If manual iOS keyboard enabling is required, document the exact steps in the report and show only a one-line instruction on screen.

Full Access must remain OFF.

---

## Task 12 — Full validation

Run:

```bash
make validate
make privacy-check
make clean-check
```

Also run appropriate Xcode build/tests.

Confirm:

- Simulator build passes;
- tests pass;
- device build passes or exact blocker is documented;
- privacy scan passes;
- no signing files are tracked;
- tree is clean.

---

## Task 13 — Final report

Finish:

```text
reports/IMPLEMENTATION-REPORT-INITIAL-BOOTSTRAP-YYYY-MM-DD.md
```

Update:

```text
agent/TASKS.md
agent/STATUS.md
agent/DECISIONS.md
agent/HANDOFF.md
```

Commit the final report/tracker updates.

Push.

Verify remote push succeeded.

---

# 32. Definition of Done for This Run

This run is complete when all non-blocked work possible today has been completed and:

```text
[ ] Repository initialized professionally
[ ] feat/keyboard-mvp exists
[ ] Branch pushed to origin
[ ] AGENTS.md created
[ ] Agent trackers created
[ ] Initial implementation report created
[ ] Xcode app target builds
[ ] Keyboard extension target exists and is embedded
[ ] RequestsOpenAccess is false
[ ] Emoji core architecture exists
[ ] Initial tests exist
[ ] Initial keyboard UI exists
[ ] Initial companion UI exists
[ ] Simulator validation passes
[ ] Connected iPhone is discovered
[ ] Device build attempted
[ ] App installed on iPhone if no external blocker
[ ] App launched on iPhone if no external blocker
[ ] Keyboard enablement human step documented if required
[ ] No personal information committed
[ ] No secrets committed
[ ] No signing artifacts committed
[ ] No networking/analytics added
[ ] All completed logical tasks have commits
[ ] Every completed task has been pushed
[ ] Final report committed and pushed
[ ] git status --short is empty
```

---

# 33. Absolute Final Check

Before finishing:

```bash
git status --short
git log --oneline --decorate -15
git branch -vv
```

Verify:

1. working tree is completely clean;
2. current branch tracks the remote branch;
3. all intended commits exist remotely;
4. final report is committed;
5. agent tracker accurately matches repository state.

If any of these are false, fix them before declaring completion.

---

# 34. Final On-Screen Response

Do not provide a large summary.

Maximum approximately 6–8 short lines.

Example:

```text
Done.
Phase: Initial MVP bootstrap
Report: reports/IMPLEMENTATION-REPORT-INITIAL-BOOTSTRAP-2026-08-07.md
Latest commit: abc1234
Push: successful
iPhone: app installed and launched
Keyboard: ready for manual enablement
Tree: clean
```

If human action is required:

```text
Blocked only on iPhone setup.
Action: Unlock iPhone and approve Developer Mode.
Report: reports/IMPLEMENTATION-REPORT-INITIAL-BOOTSTRAP-2026-08-07.md
Tree: clean
```

The repository report is the authoritative handoff for the next ChatGPT review.

---

# 35. Begin Now

Start immediately with the repository audit.

Do not ask the user to repeat any information already provided in this prompt.

Do not stop after creating plans or documentation.

Implement, validate, commit, push, deploy to the connected iPhone where possible, update the report, and leave the repository completely clean.

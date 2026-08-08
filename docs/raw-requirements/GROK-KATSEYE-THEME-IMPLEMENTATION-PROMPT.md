# Grok Build Prompt — Implement KATSEYE Keyboard Theme from Asset Kit

## Goal

Implement the new **KATSEYE-themed keyboard experience** in the existing iOS keyboard app using the asset kit I downloaded to this Mac.

The asset archive should be located in my Downloads folder and is expected to be named:

```text
KATSEYE-KEYBOARD-ASSET-KIT-V2.zip
```

Use the ZIP as the source of truth for the visual assets.

Do **not** generate replacement people, faces, group photos, or AI recreations of KATSEYE.

The supplied archive already contains the actual reference photo and individual production assets.

---

# 1. Start With Repository Safety

Before making changes:

1. Inspect:
   ```bash
   pwd
   git status
   git branch --show-current
   git remote -v
   git log --oneline -10
   ```

2. Read all existing project instructions, especially:
   ```text
   AGENTS.md
   agent/TASKS.md
   agent/STATUS.md
   agent/DECISIONS.md
   agent/HANDOFF.md
   docs/
   ```

3. Do not overwrite working features.

4. Preserve the existing privacy-first keyboard architecture:
   - no analytics
   - no tracking
   - no accounts
   - no ads
   - no network access from the keyboard extension
   - no Full Access requirement
   - no storage of typed text
   - no clipboard reading
   - no logging of keyboard input

5. Confirm the working tree is clean before beginning.

If the tree is not clean, determine whether the changes belong to the current project and preserve them safely. Do not discard user work.

---

# 2. Locate and Extract the Asset Kit

Locate:

```text
~/Downloads/KATSEYE-KEYBOARD-ASSET-KIT-V2.zip
```

If needed, search for it:

```bash
find ~/Downloads -maxdepth 2 -iname 'KATSEYE-KEYBOARD-ASSET-KIT-V2.zip' -print
```

Inspect the ZIP contents before extracting:

```bash
unzip -l ~/Downloads/KATSEYE-KEYBOARD-ASSET-KIT-V2.zip
```

Extract it into a temporary working directory outside the repository first, for example:

```bash
rm -rf /tmp/katseye-keyboard-assets
mkdir -p /tmp/katseye-keyboard-assets
unzip ~/Downloads/KATSEYE-KEYBOARD-ASSET-KIT-V2.zip \
  -d /tmp/katseye-keyboard-assets
```

Review the included:

```text
KATSEYE-PASTEL-THEME-DESIGN.md
GROK-IMPLEMENTATION-PROMPT.md
Reference/
Backgrounds/
Buttons/
Charms/
AppIcons/
iOS/
```

The current prompt takes precedence where instructions differ.

---

# 3. Critical Asset Rule

## DO NOT slice assets from a single design-board image.

The large design/moodboard image is only a visual reference.

Use the **individual files supplied in the ZIP**.

Expected asset families include:

```text
Backgrounds/
Buttons/
Charms/
AppIcons/
iOS/Assets.xcassets/
iOS/Code/
Reference/
```

Import clean source assets into the actual Xcode asset catalog.

Avoid duplicate resources and do not blindly copy an entire nested `.xcassets` if doing so creates conflicting names.

---

# 4. KATSEYE Photo Requirement

For the personal/local version of this app, use the supplied real reference photo from the asset kit.

Look under:

```text
Reference/
Backgrounds/PersonalUsePhoto/
```

Examples may include:

```text
katseye-source-reference.webp
keyboard-photo-soft-1170x780.png
keyboard-photo-dreamy-1170x780.png
keyboard-concept-mockup.png
```

Important:

- Do not AI-generate replacement KATSEYE members.
- Do not alter faces.
- Do not reconstruct people.
- Do not use the AI-generated moodboard group image as the actual production image.
- Use the supplied real-photo-based asset for the personal keyboard background.

The people must remain visually recognizable from the supplied source image.

If the image needs cropping for device/layout fit, use non-destructive cropping only.

Do not distort aspect ratio.

---

# 5. Theme Direction

The primary KATSEYE theme should match the **bright pastel aesthetic** of the supplied reference image rather than a dark generic cosmic keyboard.

Visual direction:

- pastel pink
- baby blue
- butter yellow
- lilac
- lime / soft green
- pearl white
- subtle gloss
- translucent/frosted keys
- sparkles
- gem highlights
- ribbons/bows where appropriate
- youthful but polished
- readable above all else

Dark purple/black can be used sparingly for contrast or an alternate variant, but it should not replace the primary pastel theme.

---

# 6. Create a First-Class Theme in the App

Implement this as a real theme in the existing architecture, not a one-off hacked screen.

Suggested theme identifier:

```text
katseye.pastel
```

If the project already has a theme registry/model, extend it cleanly.

Add semantic properties for at least:

- keyboard background
- toolbar background
- normal key background
- pressed key background
- special key background
- selected category background
- normal foreground
- secondary foreground
- key border
- shadow/highlight
- category tint

Use the asset kit's existing Swift token files where helpful, but refactor to fit the current architecture rather than duplicating systems.

---

# 7. Keyboard Background

Implement the KATSEYE background so that:

- it fills the keyboard safely
- it maintains aspect ratio
- important faces are not covered unnecessarily
- text/key contrast remains excellent
- key labels remain readable
- background does not interfere with globe/backspace/category controls
- portrait and landscape both work
- the image does not cause excessive keyboard-extension memory usage

Use an overlay/blur/dimming treatment if necessary to protect legibility.

Do not make the background so opaque or busy that letters or emoji become hard to see.

---

# 8. Key / Button Styling

Use the supplied individual button/key assets where practical.

Preferred effect:

- translucent/frosted key surface
- soft pastel tint
- subtle white or pearlescent border
- light highlight
- small shadow only if performant
- visible pressed state
- high legibility

Buttons that need distinct treatment:

- regular keyboard keys
- category buttons
- selected category
- globe / next keyboard
- backspace
- space
- return if present
- favorites
- KATSEYE category

Pressed-state feedback must remain responsive and subtle.

Avoid heavyweight animations in the keyboard extension.

---

# 9. KATSEYE Category

Add a dedicated KATSEYE category in the keyboard toolbar.

It should use the supplied charm artwork and/or insertable emoji combinations from the asset kit.

Important iOS limitation:

Custom PNG artwork cannot be inserted as a new Unicode emoji into arbitrary text fields.

Therefore distinguish between:

### A. Insertable text emoji combinations

Examples can include combinations such as:

```text
💎👁️✨
🎀💗✨
🎤⭐💫
🦋💜✨
⭐💎⭐
```

Use the catalog supplied in the ZIP where present.

These can be inserted through:

```swift
textDocumentProxy.insertText(...)
```

### B. Decorative KATSEYE charms

Use PNG/SVG charms for:

- toolbar
- category cards
- theme preview
- companion app
- decorative UI
- favorite tiles

Do not pretend they are native Unicode emoji.

If the existing app supports copy/paste image stickers in the companion app, do not enable that in the keyboard extension unless it fits the existing privacy architecture and does not require Full Access.

---

# 10. Charm Asset Import

Import the supplied individual charms.

Requirements:

- transparent backgrounds where provided
- preserve vector assets when Xcode supports them
- avoid unnecessary raster duplication
- set correct rendering mode
- do not recolor artwork destructively
- use clear asset names

Examples:

```text
katseyeCharmGemEye
katseyeCharmSparkle
katseyeCharmRibbon
katseyeCharmHeart
katseyeCharmButterfly
katseyeCharmMic
```

Use naming consistent with the project.

---

# 11. App Icon Kit

The ZIP contains multiple home-screen app icon options.

Review all supplied 1024x1024 icons.

Add the best primary icon to the app's `AppIcon` asset catalog.

Do not add transparent pixels where Apple prohibits them for the final icon.

If the project supports alternate icons cleanly, optionally configure the other supplied variants as alternate app icons, but only if this does not complicate the current MVP.

Preferred icon priority:

1. Gem Eye
2. Prism Star
3. Ribbon Gem

Do not use the AI-generated fake group portrait as the main icon.

Do not put tiny unreadable text into the app icon.

---

# 12. Companion App Theme Screen

Add/update a theme preview in the companion app.

The KATSEYE theme card should clearly show:

- background
- key style
- category bar
- charms
- palette
- selected state

If theme selection already exists, add KATSEYE to the same flow.

Do not create a separate disconnected settings system.

If the keyboard and companion app cannot yet share theme state because App Groups are unavailable, preserve the project's existing fallback architecture and clearly reflect that behavior.

---

# 13. Performance Requirements

Keyboard extensions have tight memory constraints.

Optimize all artwork.

Before committing:

- inspect PNG dimensions
- remove duplicate large images
- avoid loading every large background simultaneously
- cache only what is necessary
- avoid giant UIKit/SwiftUI effects
- avoid expensive continuous blur
- avoid animated backgrounds
- avoid network-loaded assets

Prefer preprocessed static images.

Measure keyboard launch and category switch latency before and after.

Record approximate results in the implementation report.

---

# 14. Accessibility

Maintain:

- minimum 44pt touch targets
- VoiceOver labels
- selected-state accessibility
- high text contrast
- Reduce Motion awareness
- landscape support
- light/dark compatibility where applicable

Charm-only buttons must receive meaningful accessibility labels.

Example:

```text
"KATSEYE favorites"
"KATSEYE sparkle"
"Gem eye"
"Next keyboard"
"Backspace"
```

---

# 15. Do Not Break Core Keyboard Behavior

Test all existing functionality:

- normal letters if supported
- Unicode emoji insertion
- categories
- favorites
- recents
- backspace
- globe/next keyboard
- space
- return if present
- portrait
- landscape
- host apps
- keyboard switching
- keyboard reload

The theme must never interfere with `advanceToNextInputMode()`.

Full Access must remain OFF.

---

# 16. Build and Test

Run the repository's existing validation commands.

Prefer:

```bash
make validate
```

If unavailable, run the documented equivalents.

Also run an unsigned simulator build.

Example:

```bash
xcodebuild \
  -project SupernovaEmoji.xcodeproj \
  -scheme SupernovaEmoji \
  -sdk iphonesimulator \
  -configuration Debug \
  CODE_SIGNING_ALLOWED=NO \
  build
```

Adjust only if the actual project/scheme names differ.

Run unit tests.

Fix all failures introduced by this work.

---

# 17. Deploy to My Connected iPhone

My iPhone is already connected to this Mac.

Target:

- physical iPhone 13 Pro
- iOS 26
- Apple development/signing was already configured earlier

After local build validation:

1. Detect the connected iPhone using Xcode command-line tooling.
2. Build using the existing local development signing configuration.
3. Install the containing app to the connected phone.
4. Launch it if possible.
5. Verify the keyboard extension is embedded.
6. Do not change/delete my Apple account configuration.
7. Do not commit team IDs, UDIDs, provisioning profiles, certificates, or Apple IDs.

If iOS requires a manual action to enable the keyboard, stop only at that human action and clearly tell me the shortest exact steps.

Complete every other non-blocked task first.

---

# 18. Real Device Validation

On the connected iPhone, validate as much as can be done automatically/safely.

Human test target:

1. Open the app.
2. Select/preview KATSEYE theme.
3. Enable the keyboard if needed.
4. Open a blank Notes field.
5. Switch to the custom keyboard.
6. Verify real KATSEYE photo background.
7. Verify pastel/frosted keys.
8. Open KATSEYE category.
9. Insert several KATSEYE emoji combos.
10. Use backspace.
11. Use globe key.
12. Rotate device.
13. Confirm layout remains readable.
14. Confirm Full Access remains disabled.

Do not capture screenshots containing private notifications, personal messages, contacts, or device identifiers.

---

# 19. Asset Provenance

Add or update:

```text
docs/ASSET-PROVENANCE.md
```

Document:

- which files came from `KATSEYE-KEYBOARD-ASSET-KIT-V2.zip`
- which are derived from the user-supplied KATSEYE reference photo
- which are original generated graphic assets
- which assets are intended for personal/local use
- which abstract alternatives are safer for a future public/App Store build

Do not claim ownership of third-party KATSEYE photography.

Do not silently publish/relicense it.

---

# 20. Future Public/App Store Safety

For this implementation, the photo-based theme can be enabled for the local/personal build.

But architect the asset selection so a future public/App Store build can switch to the included abstract/original theme without invasive code changes.

For example:

```swift
enum KatseyeBackgroundVariant {
    case personalPhoto
    case abstractPastel
}
```

or equivalent build/theme configuration.

Do not build an entire new configuration system just for this if the existing architecture already has a better mechanism.

---

# 21. Git and Agent Discipline

This repository is agent-driven.

Maintain:

```text
agent/TASKS.md
agent/STATUS.md
agent/DECISIONS.md
agent/HANDOFF.md
```

Update them continuously.

Use small commits.

Suggested commit sequence:

```text
feat(theme): add katseye pastel asset catalog
feat(theme): implement katseye keyboard styling
feat(keyboard): add katseye emoji category
feat(app): add katseye theme preview and app icon
test(theme): validate katseye layout and catalog behavior
docs(theme): document katseye asset provenance and device validation
```

Do not force-push.

Push completed commits to the remote branch.

At the end:

```bash
git status --short
```

must return no output.

The working tree must be completely clean.

---

# 22. Implementation Report

Create:

```text
docs/reports/KATSEYE-THEME-IMPLEMENTATION-REPORT-2026-08-07.md
```

Include:

- summary
- files changed
- assets imported
- exact theme architecture
- which background is being used
- KATSEYE category behavior
- custom charm limitations
- app icon selected
- simulator build result
- unit test result
- physical-device build result
- physical-device install result
- keyboard manual-validation status
- latency/performance observations
- accessibility checks
- privacy checks
- known issues
- remaining work
- commit hashes

Do not include secrets or personal Apple/device identifiers.

Commit the report.

Push it.

---

# 23. Final Grok Response Must Be Very Short

Do not dump long logs into the chat.

When finished, only show something like:

```text
KATSEYE theme implemented ✅
iPhone deployment: PASS
Tests: PASS
Commits pushed: 6
Tree: CLEAN

Report:
docs/reports/KATSEYE-THEME-IMPLEMENTATION-REPORT-2026-08-07.md
```

If a human action is required, add only the exact short step required.

All details belong in the committed report, not the chat response.

---

# Definition of Done

Do not consider this work complete until:

- the ZIP was inspected
- individual assets were imported
- the real supplied photo is used for the personal KATSEYE background
- no AI-generated fake KATSEYE people are used
- theme is integrated into the real theme system
- key/button styling is implemented
- KATSEYE category exists
- insertable emoji combos work
- decorative charm assets are correctly treated as graphics
- app icon is implemented
- companion preview exists
- keyboard behavior remains functional
- Full Access remains OFF
- no network/analytics/tracking was added
- tests/build pass
- connected iPhone build/install is attempted and completed unless blocked by a required human iOS action
- report is committed
- all commits are pushed
- `git status --short` is empty

Proceed autonomously and complete all non-blocked work without asking routine implementation questions.

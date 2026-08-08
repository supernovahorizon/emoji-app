# Status

- **Current phase:** Initial MVP bootstrap (complete for non-blocked work)
- **Current branch:** `feat/keyboard-mvp`
- **Latest validated commit:** see `git log -1 --oneline` on branch
- **What works:**
  - Simulator build of app + embedded keyboard
  - Unit tests for catalog, preferences, input actions
  - Companion app screens (welcome, privacy, enablement, explorer, themes, help, diagnostics)
  - Keyboard UI (categories, grid, insert, backspace, globe)
  - Privacy/scripts/CI baseline
- **Tests currently passing:** SupernovaEmojiTests, SupernovaEmojiKeyboardTests (simulator)
- **Physical-device state:** iPhone 13 Pro detected (iOS 26.5.2); device build OK; app installed; launch blocked until user trusts developer profile
- **Known blockers:** Trust Developer App on device; keyboard must be enabled manually in iOS Settings; Full Access must stay OFF
- **Next three tasks:**
  1. User trusts developer profile and launches app
  2. Enable keyboard (Full Access OFF) and smoke-test insertion
  3. Expand catalog density

# Decisions

Format: `Date | Decision | Reason | Alternatives | Consequences`

2026-08-07 | Use XcodeGen (`project.yml`) for the Xcode project | Reproducible project file; easier agent edits than hand-written pbxproj | Hand-written pbxproj; Tuist | Contributors need `xcodegen`; run `make bootstrap` after project.yml changes
2026-08-07 | Shared `EmojiCore` as folder sources in both targets (not a separate framework target) | Simpler MVP linking; lower extension memory overhead | Dynamic framework; SPM local package | Source is compiled into app and keyboard separately; keep EmojiCore free of UIKit/AppKit UI
2026-08-07 | Bundle emoji catalog as JSON with schemaVersion | Easy validation tests; versioned format | Hard-coded Swift arrays only | Must keep JSON and models in sync; validator enforces integrity
2026-08-07 | Preferences via UserDefaults through `KeyboardPreferencesStore` | No database; works without App Groups | App Group suite only; Core Data; files | MVP works offline without App Groups; optional suite name reserved for later
2026-08-07 | `RequestsOpenAccess = false` permanently for MVP | Privacy product requirement | Full Access for shared container networking | No network from keyboard; preferences local to extension container unless App Groups added later
2026-08-07 | Zero third-party dependencies | Privacy, size, keyboard constraints | SPM packages for utilities | Slightly more hand-rolled code
2026-08-07 | DEVELOPMENT_TEAM only in gitignored `Config/Local.xcconfig` | Never commit Team ID | Check team into project | Device builds require local one-time setup
2026-08-07 | Text input behind `TextInputHandling` protocol | Unit-test keyboard actions without UIInputViewController | Direct proxy calls only | Production adapter wraps textDocumentProxy

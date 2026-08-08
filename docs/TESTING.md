# Testing

## Unit tests

### Catalog

- loads bundled JSON
- rejects duplicate emoji IDs
- rejects invalid category references
- rejects unsupported schema versions
- provides safe fallback category

### Preferences

- favorites add/remove/toggle
- recents are bounded and ordered
- theme resolution
- fallback store degrades safely

### Input

- `TextInputHandling` mock records insert/delete/next

### Keyboard view model

- category selection
- action dispatch without UIKit

## UI tests

Smoke launch of companion app only (MVP). Deep keyboard UI tests are limited by iOS keyboard extension automation constraints.

## Commands

```bash
make test
make validate
```

Simulator destination is discovered dynamically (prefer iPhone simulator).

## Device validation (manual)

1. Install app
2. Enable keyboard; Full Access OFF
3. Open Notes → blank field → switch to Supernova Emoji
4. Switch categories, insert emoji, backspace, globe
5. Rotate portrait/landscape
6. Confirm no network permission prompts

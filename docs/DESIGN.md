# Design — Supernova Emoji

## Vision

A calm, child-friendly emoji keyboard that families can trust: offline, ad-free, no accounts, no tracking, and no Full Access.

## Product principles

1. **Privacy first** — never capture typed text; no network; Full Access off.
2. **Simple** — large touch targets, clear categories, minimal chrome.
3. **Offline** — everything works in airplane mode.
4. **Inclusive** — VoiceOver labels, Dynamic Type (companion), light/dark, Reduce Motion friendly.
5. **Honest** — no dark patterns, no subscriptions in MVP.

## Personas

- Parent enabling a keyboard for a child or family device
- Child or teen picking emoji quickly in Messages/Notes
- Privacy-conscious adult who refuses Full Access keyboards

## Companion app information architecture

1. **Welcome** — product name, short promise
2. **Privacy** — plain-language guarantees
3. **Enable keyboard** — numbered iOS Settings steps; Full Access stays OFF
4. **Emoji explorer** — browse categories / preview
5. **Themes** — basic theme preview (local preference)
6. **Help** — FAQ
7. **Diagnostics** — non-sensitive build info only

## Keyboard information architecture

- Top: category toolbar (Favorites, Smileys, Animals, Food, Activities, Nature, Hearts & Celebrations, Symbols)
- Center: emoji grid (Unicode glyphs)
- Bottom: backspace + globe/next keyboard (always visible)

## Visual design

- Large emoji cells (≥44×44 pt hit areas)
- Rounded category chips with selected state not color-only (icon + label/selected trait)
- System semantic colors for light/dark
- Avoid clutter; no ads or banners

## Content

- Unicode emoji only (no Apple emoji asset redistribution)
- Categories listed in requirements §16
- Favorites and recents are user-local lists of IDs

## Non-goals (MVP)

- Stickers, GIFs, custom image packs
- Cloud sync / accounts
- Full Access features
- iMessage app extension
- Android

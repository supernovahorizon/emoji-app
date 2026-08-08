#!/usr/bin/env bash
# Privacy / security static checks for Supernova Emoji.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

FAIL=0

red() { printf 'ERROR: %s\n' "$*" >&2; FAIL=1; }
warn() { printf 'WARN: %s\n' "$*" >&2; }
ok() { printf 'OK: %s\n' "$*"; }

echo "== Privacy check =="

# Forbidden artifact files (tracked)
while IFS= read -r f; do
  red "Tracked signing artifact: $f"
done < <(git ls-files '*.p12' '*.mobileprovision' '*.cer' '*.key' '*.pem' 2>/dev/null || true)

if git ls-files 'Config/Local.xcconfig' 2>/dev/null | grep -q .; then
  red "Config/Local.xcconfig must not be tracked"
else
  ok "Local.xcconfig not tracked"
fi

# Scan product sources for high-risk APIs (keyboard + app + core)
PRODUCT_PATHS=(EmojiCore SupernovaEmoji SupernovaEmojiKeyboard)
PATTERN='URLSession|NWConnection|UIPasteboard|PHPhotoLibrary|CNContactStore|CLLocationManager|AVCaptureDevice|WKWebView|SFSafariViewController|AppTrackingTransparency|ASIdentifierManager|Firebase|Amplitude|Mixpanel|Segment\.|Sentry|Crashlytics'

HITS=0
for p in "${PRODUCT_PATHS[@]}"; do
  if [[ -d "$p" ]]; then
    if grep -RInE "$PATTERN" "$p" --include='*.swift' --include='*.m' --include='*.h' --include='*.plist' 2>/dev/null; then
      HITS=1
    fi
  fi
done

if [[ "$HITS" -ne 0 ]]; then
  red "Suspicious API/SDK symbols found in product sources (review required)"
else
  ok "No forbidden network/private-data APIs in product sources"
fi

# Full Access must be false
if grep -RIn 'RequestsOpenAccess' SupernovaEmojiKeyboard --include='*.plist' --include='*.entitlements' 2>/dev/null | grep -E 'true|YES' >/dev/null 2>&1; then
  red "RequestsOpenAccess must not be true"
else
  ok "RequestsOpenAccess not enabled"
fi

# RequestsOpenAccess should be explicitly false in Info.plist
if [[ -f SupernovaEmojiKeyboard/Info.plist ]]; then
  if grep -q 'RequestsOpenAccess' SupernovaEmojiKeyboard/Info.plist; then
    if plutil -extract NSExtension.NSExtensionAttributes.IsASCIICapable raw SupernovaEmojiKeyboard/Info.plist >/dev/null 2>&1 || true; then
      :
    fi
    if grep -A1 'RequestsOpenAccess' SupernovaEmojiKeyboard/Info.plist | grep -q '<false/>'; then
      ok "RequestsOpenAccess=false in keyboard Info.plist"
    else
      red "RequestsOpenAccess missing false value in keyboard Info.plist"
    fi
  else
    red "RequestsOpenAccess key missing from keyboard Info.plist"
  fi
fi

# Team ID pattern in tracked files (10 char alnum common for DEVELOPMENT_TEAM assignments)
if git grep -nE 'DEVELOPMENT_TEAM\s*=\s*[A-Z0-9]{10}' -- ':!Config/Local.example.xcconfig' ':!scripts/*' ':!docs/*' ':!agent/*' ':!reports/*' 2>/dev/null | grep -v 'YOURTEAMID' | grep -v 'XXXXXXXXXX'; then
  red "Possible DEVELOPMENT_TEAM committed in source-controlled config"
else
  ok "No DEVELOPMENT_TEAM value committed"
fi

# Personal email heuristic in tracked source (allow github generic)
if git grep -nE '[A-Za-z0-9._%+-]+@gmail\.com|[A-Za-z0-9._%+-]+@icloud\.com' -- '*.swift' '*.plist' '*.xcconfig' '*.md' 2>/dev/null | grep -v 'example.com' | grep -v 'PRIVACY' | head -20; then
  warn "Possible personal email strings in tracked files — review"
fi

if [[ "$FAIL" -ne 0 ]]; then
  echo "Privacy check FAILED"
  exit 1
fi

echo "Privacy check PASSED"
exit 0

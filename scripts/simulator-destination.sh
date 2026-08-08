#!/usr/bin/env bash
# Print a simulator destination for xcodebuild (dynamic, no hard-coded UDID).
set -euo pipefail

# Prefer any available iPhone simulator
LINE=$(xcrun simctl list devices available 2>/dev/null | grep -E 'iPhone' | head -1 || true)
if [[ -z "$LINE" ]]; then
  echo "platform=iOS Simulator,name=iPhone 16" 
  exit 0
fi

# Extract UUID in parentheses
UDID=$(echo "$LINE" | sed -n 's/.*(\([A-F0-9-]\{36\}\)).*/\1/p')
NAME=$(echo "$LINE" | sed -n 's/^[[:space:]]*\([^(]*\) (.*/\1/p' | sed 's/[[:space:]]*$//')

if [[ -n "$UDID" ]]; then
  echo "platform=iOS Simulator,id=${UDID}"
else
  echo "platform=iOS Simulator,name=${NAME:-iPhone 16}"
fi

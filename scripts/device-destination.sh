#!/usr/bin/env bash
# Print an xcodebuild -destination string for a connected physical iPhone.
# Prefers iPhone 13 Pro; does not write identifiers into the repository.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

DESTS=$(xcodebuild -project SupernovaEmoji.xcodeproj -scheme SupernovaEmoji -showdestinations 2>/dev/null || true)

# Collect physical iOS device lines (exclude Simulator and placeholder)
LINES=$(echo "$DESTS" | grep 'platform:iOS' | grep -v Simulator | grep -v placeholder || true)

if [[ -z "$LINES" ]]; then
  echo "No physical iPhone detected" >&2
  exit 1
fi

# Prefer 13 Pro by name substring; else first physical iPhone destination
UDID=""
while IFS= read -r line; do
  if echo "$line" | grep -qi '13 Pro\|iPhone14,2\|Shreyaa'; then
    UDID=$(echo "$line" | sed -n 's/.*id:\([0-9A-Fa-f-]*\).*/\1/p' | head -1)
    break
  fi
done <<< "$LINES"

if [[ -z "$UDID" ]]; then
  while IFS= read -r line; do
    UDID=$(echo "$line" | sed -n 's/.*id:\([0-9A-Fa-f-]*\).*/\1/p' | head -1)
    if [[ -n "$UDID" ]]; then
      break
    fi
  done <<< "$LINES"
fi

if [[ -z "$UDID" ]]; then
  echo "No physical iPhone detected" >&2
  exit 1
fi

echo "platform=iOS,id=${UDID}"

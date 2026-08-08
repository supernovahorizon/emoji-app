#!/usr/bin/env bash
# Fail if the git working tree is not clean.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ -n "$(git status --short)" ]]; then
  echo "ERROR: working tree is not clean:" >&2
  git status --short >&2
  exit 1
fi

echo "OK: working tree clean"

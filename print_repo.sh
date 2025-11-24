#!/usr/bin/env bash
# print_repo.sh — show repository structure and file contents in the console
# Usage: ./print_repo.sh [repo-path]
set -euo pipefail

ROOT="${1:-$(pwd)}"
ROOT="$(cd "${ROOT}" && pwd)"

cd "$ROOT"

printf '=== Repository structure: %s ===\n' "$ROOT"
if command -v tree >/dev/null 2>&1; then
  tree -a -I '.git' .
else
  find . -mindepth 1 \( -path './.git' -o -path './.git/*' \) -prune -o -print | sort
fi

echo
printf '=== File contents ===\n'

mapfile -t files < <(find . -type f \( -path './.git' -o -path './.git/*' \) -prune -o -print | sort)

for file in "${files[@]}"; do
  [ -f "$file" ] || continue
  echo
  printf -- '--- %s ---\n' "$file"
  cat "$file"
  echo
  printf -- '--- end %s ---\n' "$file"
  echo
  printf -- '==============================\n'
done

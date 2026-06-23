#!/usr/bin/env bash
# Kiro PostToolUse hook — blocks secret writes

INPUT=$(cat)
FILE=$(echo "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('path',''))" 2>/dev/null)

if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
  exit 0
fi

SECRET_PATTERNS=(
  "sk-[a-zA-Z0-9]{32,}"
  "AKIA[0-9A-Z]{16}"
  "-----BEGIN.*PRIVATE KEY-----"
  "password\s*=\s*['\"][^'\"]{8,}"
  "api_key\s*=\s*['\"][^'\"]{8,}"
  "secret\s*=\s*['\"][^'\"]{8,}"
)

FOUND=0
for pattern in "${SECRET_PATTERNS[@]}"; do
  if grep -qP "$pattern" "$FILE" 2>/dev/null; then
    echo "BLOCKED: Possible secret in $FILE (pattern: $pattern)" >&2
    FOUND=1
  fi
done

exit $FOUND

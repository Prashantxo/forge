#!/usr/bin/env bash
# After any file write, check for accidentally written secrets.

INPUT=$(cat)
FILE=$(echo "$INPUT" | grep -o '"path":"[^"]*"' | head -1 | sed 's/"path":"//;s/"//')

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
    echo "BLOCKED: Possible secret detected in $FILE (pattern: $pattern)" >&2
    echo "Move to environment variable or secrets manager before writing." >&2
    FOUND=1
  fi
done

exit $FOUND

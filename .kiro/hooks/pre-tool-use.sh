#!/usr/bin/env bash
# Kiro PreToolUse hook — blocks destructive commands

INPUT=$(cat)

if command -v python3 &>/dev/null; then
  CMD=$(echo "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('command',''))" 2>/dev/null)
else
  CMD=$(echo "$INPUT" | grep -o '"command"\s*:\s*"[^"]*"' | head -1 | sed 's/.*"command"\s*:\s*"//;s/"//')
fi

DANGEROUS_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "DROP TABLE"
  "DELETE FROM.*WHERE 1"
  "git push --force.*main"
  "git push --force.*master"
  "mkfs"
  "dd if=.*of=/dev/"
  "chmod -R 777"
  "curl.*|.*sh"
  "wget.*|.*bash"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$CMD" | grep -qi "$pattern"; then
    echo "BLOCK: Dangerous command detected: $pattern" >&2
    exit 1
  fi
done

exit 0

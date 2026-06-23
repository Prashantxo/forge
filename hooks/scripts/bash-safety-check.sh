#!/usr/bin/env bash
# Blocks destructive bash commands before execution.
# Reads CLAUDE_TOOL_INPUT from stdin (JSON with .command field).

INPUT=$(cat)

# Robust JSON extraction via python3 (handles whitespace, escaping)
if command -v python3 &>/dev/null; then
  CMD=$(echo "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('command',''))" 2>/dev/null)
else
  CMD=$(echo "$INPUT" | grep -o '"command"\s*:\s*"[^"]*"' | head -1 | sed 's/.*"command"\s*:\s*"//;s/"//')
fi

DANGEROUS_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \*"
  "DROP TABLE"
  "DELETE FROM.*WHERE 1"
  "git push --force.*main"
  "git push --force.*master"
  "> /dev/sda"
  "mkfs"
  "dd if=.*of=/dev/"
  "chmod -R 777"
  "curl.*|.*sh"
  "wget.*|.*sh"
  "curl.*|.*bash"
  "wget.*|.*bash"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$CMD" | grep -qi "$pattern"; then
    echo "BLOCK: Dangerous command pattern detected: $pattern" >&2
    exit 1
  fi
done

exit 0

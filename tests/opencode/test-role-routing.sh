#!/usr/bin/env bash
# Regression: OpenCode implementation and review dispatches use dedicated subagents.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

assert_contains() {
    local path="$1"
    local expected="$2"
    if ! grep -Fq -- "$expected" "$REPO_ROOT/$path"; then
        printf '[FAIL] %s does not contain: %s\n' "$path" "$expected" >&2
        return 1
    fi
    printf '[PASS] %s routes %s\n' "$path" "$expected"
}

implementation_files=(
    "skills/subagent-driven-development/implementer-prompt.md"
    "skills/dispatching-parallel-agents/SKILL.md"
)

review_files=(
    "skills/subagent-driven-development/task-reviewer-prompt.md"
    "skills/requesting-code-review/SKILL.md"
    "skills/requesting-code-review/code-reviewer.md"
    "skills/brainstorming/spec-document-reviewer-prompt.md"
    "skills/writing-plans/plan-document-reviewer-prompt.md"
)

for path in "${implementation_files[@]}"; do
    assert_contains "$path" 'OpenCode agent: `implementer`'
done

for path in "${review_files[@]}"; do
    assert_contains "$path" 'OpenCode agent: `reviewer`'
done

assert_contains "skills/subagent-driven-development/SKILL.md" 'OpenCode role routing'
assert_contains "docs/README.opencode.md" 'subagent_type: "implementer"'
assert_contains "docs/README.opencode.md" 'subagent_type: "reviewer"'
assert_contains "docs/README.opencode.md" '"model": "openai/gpt-5.6-terra"'
assert_contains "docs/README.opencode.md" '`mode: "subagent"` keeps these roles out of the primary-agent Tab rotation'

printf '\nOpenCode role-routing regression passed.\n'

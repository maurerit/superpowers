#!/usr/bin/env bash
# Regression: plan approval is not an execution-lane choice.
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../.." && pwd)"
plan_skill="$repo_root/skills/writing-plans/SKILL.md"

assert_contains() {
    if ! grep -Fq -- "$1" "$plan_skill"; then
        printf '[FAIL] writing-plans missing handoff contract: %s\n' "$1" >&2
        exit 1
    fi
}

assert_contains 'STOP after saving the plan.'
assert_contains 'Do not invoke an execution skill, dispatch an implementer, or edit implementation code until your human partner chooses an execution option.'
assert_contains 'Approval of the spec, a request to "go ahead and implement", or permission to write the plan is not a choice of execution method.'
assert_contains 'If your human partner already chose a method explicitly, follow that choice; otherwise ask "Which approach?" and wait for their reply.'

printf '[PASS] writing-plans requires an explicit execution-lane handoff\n'

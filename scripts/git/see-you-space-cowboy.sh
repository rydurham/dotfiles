#!/bin/bash

# See You, Space Cowboy: branch protection for a GitHub repository.
#
# Applies the "See You, Space Cowboy" ruleset to the default branch of the
# current repo. The ruleset blocks branch deletion and force-pushes, and
# requires changes to arrive through a pull request (squash merge only, no
# required approvals) and, by default, that the "check-title" status check
# passes (see feel-the-rhythm.sh). Use --no-ci to require no checks, or -c to
# name different ones. The rules are hard-coded, modeled on
# the ruleset in FirebrandTech/fps. Needs gh and jq.
#
# Safe to re-run: an existing ruleset with the same name is updated in place.
#
# Running order for a new project:
#   1. feel-the-rhythm.sh   (commit the files it creates)
#   2. create the GitHub repo and push main:
#        gh repo create <name> --source . --push
#   3. cool-runnings.sh
#   4. see-you-space-cowboy.sh   (last: it blocks direct pushes to main)
#
# Usage: see-you-space-cowboy.sh [--no-ci | -c "check name"...] [-n]
#   --no-ci        Do not require any status checks (repos without CI).
#   -c, --check    Required status check (repeatable). Replaces the defaults.
#   -n, --dry-run  Print the ruleset payload and exit.

set -euo pipefail

NAME="See You, Space Cowboy"
DEFAULT_CHECKS=("check-title")
checks=()
ci=1
dry_run=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-ci)
            ci=0
            shift
            ;;
        -c|--check)
            [[ $# -ge 2 ]] || { echo "$1 requires a value" >&2; exit 1; }
            checks+=("$2")
            shift 2
            ;;
        -n|--dry-run)
            dry_run=1
            shift
            ;;
        -h|--help)
            sed -n '3,/^$/{/^$/!p}' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

for cmd in gh jq; do
    command -v "$cmd" >/dev/null || { echo "$cmd is required" >&2; exit 1; }
done

if [[ $ci -eq 0 && ${#checks[@]} -gt 0 ]]; then
    echo "--no-ci cannot be combined with -c" >&2
    exit 1
fi

if [[ $ci -eq 1 && ${#checks[@]} -eq 0 ]]; then
    checks=("${DEFAULT_CHECKS[@]}")
fi

checks_json=$(printf '%s\n' "${checks[@]}" | jq -R . | jq -s 'map(select(length > 0))')

payload=$(jq -n --arg name "$NAME" --argjson checks "$checks_json" '
    {
        name: $name,
        target: "branch",
        enforcement: "active",
        conditions: { ref_name: { include: ["~DEFAULT_BRANCH"], exclude: [] } },
        bypass_actors: [],
        rules: (
            [
                { type: "deletion" },
                { type: "non_fast_forward" },
                {
                    type: "pull_request",
                    parameters: {
                        required_approving_review_count: 0,
                        dismiss_stale_reviews_on_push: true,
                        require_code_owner_review: false,
                        require_last_push_approval: false,
                        required_review_thread_resolution: false,
                        allowed_merge_methods: ["squash"]
                    }
                }
            ]
            + (if ($checks | length) > 0 then [{
                type: "required_status_checks",
                parameters: {
                    strict_required_status_checks_policy: false,
                    do_not_enforce_on_create: false,
                    required_status_checks: ($checks | map({ context: . }))
                }
            }] else [] end)
        )
    }')

if [[ $dry_run -eq 1 ]]; then
    echo "$payload"
    exit 0
fi

gh auth status >/dev/null 2>&1 || { echo "Run 'gh auth login' first" >&2; exit 1; }
repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null) || {
    echo "No GitHub repository found for this directory." >&2
    echo "Create it and push first: gh repo create <name> --source . --push" >&2
    exit 1
}

id=$(gh api "repos/$repo/rulesets" --jq ".[] | select(.name == \"$NAME\") | .id" | head -n1)

if [[ -n "$id" ]]; then
    echo "Updating ruleset $id on $repo"
    result=$(echo "$payload" | gh api -X PUT "repos/$repo/rulesets/$id" --input -)
else
    echo "Creating ruleset on $repo"
    result=$(echo "$payload" | gh api -X POST "repos/$repo/rulesets" --input -)
fi

echo "$result" | jq -r '._links.html.href'

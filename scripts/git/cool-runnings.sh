#!/bin/bash

# Cool Runnings: standard repository settings for a GitHub repository.
#
# Applies a fixed set of settings to the current repo, modeled on
# FirebrandTech/fps (hard-coded, not read from it):
#   - merge options: squash only, PR title/body as the commit message,
#     merged branches deleted automatically
#   - features: issues on; wiki, projects and discussions off
#   - security: Dependabot alerts and security updates, immutable releases
#   - Actions: all actions allowed, read-only default token, and Actions
#     cannot approve pull requests
# Needs gh and jq.
#
# Safe to re-run: every call sets a fixed state. A step that fails (for
# example a feature missing from the plan) warns, and the rest still run.
#
# Running order for a new project:
#   1. feel-the-rhythm.sh   (commit the files it creates)
#   2. create the GitHub repo and push main:
#        gh repo create <name> --source . --push
#   3. cool-runnings.sh
#   4. see-you-space-cowboy.sh   (last: it blocks direct pushes to main)
#
# Usage: cool-runnings.sh [-n]
#   -n, --dry-run  Print each API call and payload without sending it.

set -euo pipefail

dry_run=0

while [[ $# -gt 0 ]]; do
    case "$1" in
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

if [[ $dry_run -eq 1 ]]; then
    repo="OWNER/REPO"
else
    gh auth status >/dev/null 2>&1 || { echo "Run 'gh auth login' first" >&2; exit 1; }
    repo=$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null) || {
        echo "No GitHub repository found for this directory." >&2
        echo "Create it and push first: gh repo create <name> --source . --push" >&2
        exit 1
    }
fi

failed=0

# call <description> <method> <endpoint> [json body]
call() {
    local desc="$1" method="$2" endpoint="repos/$repo/$3" body="${4:-}"

    if [[ $dry_run -eq 1 ]]; then
        echo "$desc: $method $endpoint"
        [[ -n "$body" ]] && echo "$body"
        return 0
    fi

    echo "$desc"
    if [[ -n "$body" ]]; then
        echo "$body" | gh api -X "$method" "$endpoint" --input - >/dev/null || {
            echo "  warning: $desc failed" >&2
            failed=1
        }
    else
        gh api -X "$method" "$endpoint" >/dev/null || {
            echo "  warning: $desc failed" >&2
            failed=1
        }
    fi
}

call "Merge options and features" PATCH "" '{
    "allow_squash_merge": true,
    "allow_merge_commit": false,
    "allow_rebase_merge": false,
    "squash_merge_commit_title": "PR_TITLE",
    "squash_merge_commit_message": "PR_BODY",
    "allow_auto_merge": false,
    "allow_update_branch": false,
    "delete_branch_on_merge": true,
    "has_issues": true,
    "has_wiki": false,
    "has_projects": false,
    "has_discussions": false
}'

# Alerts must be enabled before security updates
call "Dependabot alerts" PUT vulnerability-alerts
call "Dependabot security updates" PUT automated-security-fixes
call "Immutable releases" PUT immutable-releases

call "Actions permissions" PUT actions/permissions '{
    "enabled": true,
    "allowed_actions": "all"
}'
call "Workflow token permissions" PUT actions/permissions/workflow '{
    "default_workflow_permissions": "read",
    "can_approve_pull_request_reviews": false
}'

exit $failed

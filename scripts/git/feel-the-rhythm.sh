#!/bin/bash

# Feel the Rhythm: Conventional Commits setup for a git repository.
#
# Prepares the current repo so commits and PR titles follow the format
# type(scope): subject, with the scope required. It adds:
#   - a GitHub workflow (check-title) that validates PR titles
#   - a commit-msg hook (.githooks, or .husky if the repo uses husky)
#   - a commit message template (.gitmessage)
#   - a "Commit Messages" section in the README
# Pair it with see-you-space-cowboy.sh -c check-title to make the PR title
# check required.
#
# Safe to re-run: files are only written when their content differs.
# Nothing is committed.
#
# Running order for a new project:
#   1. feel-the-rhythm.sh   (commit the files it creates)
#   2. create the GitHub repo and push main:
#        gh repo create <name> --source . --push
#   3. cool-runnings.sh
#   4. see-you-space-cowboy.sh   (last: it blocks direct pushes to main)
#
# Usage: feel-the-rhythm.sh [-n]
#   -n, --dry-run  Report what would change without touching anything.

set -euo pipefail

TYPES="feat|fix|docs|style|refactor|perf|test|chore"
TYPE_LIST="${TYPES//|/ }"
REGEX="^($TYPES)\\([a-zA-Z0-9._/-]+\\)!?: .+"

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

command -v git >/dev/null || { echo "git is required" >&2; exit 1; }
root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Not inside a git repository" >&2; exit 1; }
cd "$root"

# render <template>: fill in the shared type list and regex
render() {
    local text="$1"
    text="${text//@REGEX@/$REGEX}"
    text="${text//@TYPES@/$TYPE_LIST}"
    printf '%s' "$text"
}

# write_file <path> <content> [mode]
write_file() {
    local path="$1" content="$2" mode="${3:-}" state

    if [[ ! -e "$path" ]]; then
        state="create"
    elif [[ "$(cat "$path")" == "$content" ]]; then
        state="unchanged"
    else
        state="update"
    fi

    if [[ $dry_run -eq 0 ]]; then
        if [[ $state != "unchanged" ]]; then
            mkdir -p "$(dirname "$path")"
            printf '%s\n' "$content" > "$path"
        fi
        [[ -n "$mode" ]] && chmod "$mode" "$path"
        case "$state" in
            create) state="created" ;;
            update) state="updated" ;;
        esac
    elif [[ $state != "unchanged" ]]; then
        state="would $state"
    fi

    printf '  %-13s %s\n' "$state" "$path"
}

# set_config <key> <value>
set_config() {
    local key="$1" value="$2" current
    current=$(git config --local --get "$key" || true)

    if [[ "$current" == "$value" ]]; then
        printf '  %-13s git config %s\n' "unchanged" "$key"
    elif [[ $dry_run -eq 1 ]]; then
        printf '  %-13s git config %s %s\n' "would set" "$key" "$value"
    else
        git config --local "$key" "$value"
        printf '  %-13s git config %s %s\n' "set" "$key" "$value"
    fi
}

read -r -d '' WORKFLOW <<'EOF' || true
name: PR Title

on:
  pull_request:
    types: [opened, edited, synchronize]

jobs:
  check-title:
    runs-on: ubuntu-latest
    steps:
      - name: Validate PR title format
        env:
          TITLE: ${{ github.event.pull_request.title }}
        run: |
          re='@REGEX@'
          if ! [[ "$TITLE" =~ $re ]]; then
            echo "PR title must follow Conventional Commits with a scope: type(scope): subject"
            echo "Got: $TITLE"
            exit 1
          fi
EOF

# POSIX sh: husky runs hooks with sh
read -r -d '' HOOK <<'EOF' || true
#!/bin/sh

# Require Conventional Commits with a scope: type(scope): subject
line=$(grep -v '^#' "$1" | sed -n 1p)

case "$line" in
    "Merge "*|"Revert "*|"fixup! "*|"squash! "*|"amend! "*) exit 0 ;;
esac

if ! printf '%s\n' "$line" | grep -Eq '@REGEX@'; then
    echo "Commit message must follow Conventional Commits with a scope: type(scope): subject" >&2
    echo "Types: @TYPES@" >&2
    echo "Got: $line" >&2
    exit 1
fi
EOF

read -r -d '' TEMPLATE <<'EOF' || true

# type(scope): subject
#
# Types: @TYPES@
# Mark breaking changes with ! after the scope: feat(api)!: subject
EOF

read -r -d '' README_SECTION <<'EOF' || true
## Commit Messages

This project uses [Conventional Commits (with scope)](https://www.conventionalcommits.org/en/v1.0.0/#commit-message-with-scope)
for commit messages and pull request titles. This clarifies the work done in each commit and allows changelogs to be generated for releases.

The format is `type(scope): description`. For example:

```bash
feat(lambda): add new lambda function to handle data processing
```

For the type of work please use one of the following:

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools and libraries
EOF

echo "Repository: $root"

echo "PR title check"
write_file ".github/workflows/pr-title.yml" "$(render "$WORKFLOW")"

echo "Commit-msg hook"
if [[ -d .husky ]]; then
    write_file ".husky/commit-msg" "$(render "$HOOK")" +x
else
    write_file ".githooks/commit-msg" "$(render "$HOOK")" +x
    hooks_path=$(git config --local --get core.hooksPath || true)
    if [[ -z "$hooks_path" || "$hooks_path" == ".githooks" ]]; then
        set_config core.hooksPath .githooks
    else
        echo "  warning: core.hooksPath is '$hooks_path'; hook not activated" >&2
    fi
fi

echo "Commit template"
write_file ".gitmessage" "$(render "$TEMPLATE")"
set_config commit.template .gitmessage

echo "README"
if [[ ! -f README.md ]]; then
    echo "  skipped       no README.md"
elif grep -q '^## Commit Messages' README.md; then
    printf '  %-13s %s\n' "unchanged" "README.md"
elif [[ $dry_run -eq 1 ]]; then
    printf '  %-13s %s\n' "would update" "README.md"
else
    # Ensure the file ends in a newline before appending
    [[ -n "$(tail -c1 README.md)" ]] && echo >> README.md
    printf '\n%s\n' "$README_SECTION" >> README.md
    printf '  %-13s %s\n' "updated" "README.md"
fi

echo
echo "Nothing was committed. To make the PR title check required, run:"
echo "  see-you-space-cowboy.sh -c check-title"

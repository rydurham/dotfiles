---
name: new-repo
description: Apply the standard repo setup (Conventional Commits tooling, GitHub repo settings, branch protection) to a new or existing git project. Use when the user asks to set up, configure or bootstrap a new repo, or to apply their standard repo settings to a project.
---

# Setting up a repo

Applies the user's standard setup using three scripts in `~/Workbench/dotfiles/scripts/git/` (on PATH). Read each script's `-h` output if unsure of a flag; the scripts are the source of truth.

| Script | What it does |
| --- | --- |
| `feel-the-rhythm.sh` | Conventional Commits with required scope: `commit-msg` hook in `.githooks`, `.gitmessage`, README section, and (unless `--no-ci`) a PR-title workflow. Commits nothing. |
| `cool-runnings.sh` | GitHub repo settings via API: squash-only merges, auto-delete branches, Dependabot, immutable releases, read-only Actions token. |
| `see-you-space-cowboy.sh` | Branch-protection ruleset on the default branch: PR required, squash only, no force-push or deletion. |

## Before starting

Establish these from the repo, not by asking:

- Is it a git repo, and does it have a remote? `git remote -v`, `gh repo view --json nameWithOwner,visibility`.
- Is the working tree clean? Don't mix unrelated changes into the setup commit.
- Is `.husky/` present? `feel-the-rhythm.sh` puts the hook there instead of `.githooks`.
- Public or private, and which owner? Private repos on a free plan get no CI budget and reject rulesets.

Ask the user only about **CI**: whether they want the PR-title workflow. Default to no CI for private repos (the user doesn't pay for it). Without CI, use `--no-ci` on both `feel-the-rhythm.sh` and `see-you-space-cowboy.sh`.

## Order

1. `feel-the-rhythm.sh [--no-ci] -n` to preview, then without `-n`. Review `git status`, then commit as `chore(repo): add conventional commits tooling`. The hook is active immediately, so the message must follow `type(scope): subject`.
2. Create the GitHub repo if missing (`gh repo create <name> --source . --push`, confirm visibility and owner with the user first), or add the remote and push. Pushing to an empty or unprotected `main` is fine here.
3. `cool-runnings.sh`. Warnings are non-fatal; report which steps failed.
4. `see-you-space-cowboy.sh [--no-ci] [--private]` last, because it blocks direct pushes to `main`. Only pass `--private` if the user asked to try it; on free plans GitHub answers `HTTP 403: Upgrade to GitHub Pro or make this repository public`. That's an expected outcome, not an error to work around. Report that `main` is unprotected and stop.

## Reporting

State per step what was applied and what failed. If branch protection failed, say that the local hook is the only enforcement and that PR titles are unchecked, so squash-merge commit messages depend on the user writing them correctly.

## Don't

- Don't run `configure-git-global.sh`; it's machine-level.
- Don't hand-delete the workflow file when `--no-ci` exists.
- Don't rewrite existing commit history to match the format.
- Don't create the GitHub repo, change its visibility, or push without the user's go-ahead if that wasn't already clear from the request.

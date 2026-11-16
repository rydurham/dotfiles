---
name: update-plan
description: Update an existing implementation plan. Use when the user asks to revise a plan, record progress or status, answer an open question, add/remove/reorder steps, or reconcile a plan with what was actually built.
---

# Updating a plan

Edit an existing plan in place so it stays accurate and executable. Follow the structure and style rules from the `write-plan` skill; this skill covers only how to change a plan that already exists.

## Before updating

1. Locate the plan. Use the path the user gave, otherwise look in `~/Markdown` (or `plansDirectory`) for the most recent file matching the repo and topic. If more than one candidate fits, ask which.
2. Read the whole plan before touching it.
3. If the update depends on the state of the code (progress, drift, "is this done?"), read the relevant code and `git log`/`git status` rather than trusting memory or the plan's own claims.

## Making changes

- Edit the existing file. Never create a second copy or a new dated version unless asked.
- Change only what the update requires. Keep untouched sections and wording as they are.
- **Status:** record it on the step itself in a 'status' paragraph for that step section. Do not add a separate status section to the document itself.
- **Open Questions:** when one is answered, fold the answer into the affected steps or Approach, then remove the question. Never renumber questions; this might break external expectations.
- **Steps:** after any insert, removal, or reorder, renumber all steps so they are whole integers with no letter or fractional suffixes. Fix every reference to a step number elsewhere in the plan. Steps should always be listed in implementation order.
- **Scope changes:** move newly out-of-scope work to Out of Scope instead of silently deleting it. Pull items from Out of Scope into Steps only when the user says so.
- **Deployment Plan:** The strategy for releasing the code to production; order of operations and other rollout concerns.
- **Drift:** if the code has diverged from the plan (steps done differently, files renamed), update the plan to describe what is true now, and tell the user what changed.
- Don't rewrite the Approach because of a minor step change. Revise it only when the design itself changed, and say why.
- I will probably make edits as well, don't be surprised if the disk content is different from your memory.
- Never include time estimates.

## Output

Save in place. Give the user the path and a short summary of what changed (steps added, removed, completed, renumbered; questions resolved). Do not paste the whole plan back into chat.

In plan mode, update the plan file and present it through `ExitPlanMode`.

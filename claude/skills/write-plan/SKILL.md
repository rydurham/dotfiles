---
name: write-plan
description: Write an implementation plan for a feature, fix, or refactor. Use when the user asks for a plan, a design outline, or "how would we approach X" before any code is written.
---

# Writing a plan

Produce a plan another engineer could execute without asking questions. The focus is on implementation, not brainstorming or summarizing; those are different types of documents.

## Before writing

1. Read the relevant code first. Never plan against assumptions about files, functions, or conventions you haven't opened.
2. If a decision is genuinely the user's to make and can't be resolved from the code, ask before drafting. Otherwise pick a sensible default and note it.

## Structure

Use these sections, omitting any that don't apply:

- **Goal:** one or two sentences on what changes and why.
- **Approach:** the chosen design and the reason for it. Mention rejected alternatives only if the choice is non-obvious.
- **Open Questions:** Anything that needs to be answered as part of the implementation process. When these questions are answered steps will be updated and the question should be removed. Each question should be numbered with a Q: Q1, Q2, Q3, etc.
- **Steps:** an ordered, checkable list. Each step names the files touched and is small enough to verify on its own. If a new step needs to be inserted inbetween existing steps we should re-number all the steps so we have only whole integer step numbers, no letter or fractional suffixes.
- **PR Summary** If the plan spans multiple PRs or repos outline the PRs here and the steps they correspond with.
- **Testing:** what to add or run, and how to confirm the change works.
- **Out of Scope** ideas or extensions that are related but don't fit the current focus.

## Style

- Be concrete: name files, functions, and commands rather than describing them vaguely.
- Keep it as short as the task allows. A small fix gets a short plan.
- Do not include implementation code beyond short snippets that pin down an interface or tricky detail.
- State what is out of scope when the boundary isn't obvious.
- Steps should always be listed in implementation order. Whenever possible indicate which deployment PR they should belong to.
- If a step is blocked by an open question this should be indicated within the step description.
- Don't use markdown checklists unless an individual step needs to track subtasks. Each step should get a 'Step X' header (either h3 or h4 depending on context) then a one or more paragraphs describing what needs to be done. The final paragraph for the step is a '**Status**:' paragraph. If the step is blocked by an open question this should be mentioned here.
- Never include time estimates.

## Output

Save the plan as markdown in `~/Markdown` (unless told otherwise) with a descriptive kebab-case filename using a short name for the repo as the first word in the file name. Give the user the path and a two-line summary. Do not paste the whole plan back into chat.

In plan mode, write the plan to the plan file (`plansDirectory`) instead of `~/Markdown`, and present it through `ExitPlanMode`. The structure and style rules above still apply.

---
name: explain-code
description: Summarize code or answer questions about how it works. Use when the user asks "what does this do", "how does X work", "where is Y handled", or wants an overview of a file, module, function, flow, or repo. Read-only; makes no changes.
---

# Explaining code

Answer questions about existing code accurately and concisely. This is read-only: do not edit files, propose a plan, or review for bugs unless asked. Those are different tasks.

## Before answering

1. Read the code that the answer depends on. Never answer from file names, function names, or assumptions about conventions you haven't opened.
2. Follow the trail until the question is actually answered: callers, callees, config, and tests often explain behavior that the target file alone doesn't. Stop when you can answer; don't tour the whole repo.
3. For broad questions across many files, use an Explore agent rather than reading everything inline.
4. If the question is ambiguous about scope (one function vs. the whole subsystem), pick the most likely reading, state it, and answer. Only ask if the readings would lead to very different answers.

## Answering

- Lead with the direct answer or a one-to-two sentence summary of what the code does and why it exists. Details follow.
- Explain behavior and intent, not line-by-line narration. Say what goes in, what comes out, and what side effects occur.
- Reference code as `file_path:line_number` so the user can jump to it.
- For flows that span files, give the path in order (entry point -> ... -> result) as a short list.
- Distinguish what you verified in the code from what you inferred. If something is unclear, dynamic, or depends on runtime state you couldn't see, say so rather than guessing.
- Note surprises that affect understanding (dead code, misleading names, undocumented side effects) briefly. Don't turn the explanation into a review.
- Match depth to the question. A pointed question gets a short answer; "give me an overview of this repo" gets a structured summary.

## Summaries

For overviews of a repo, module, or large file, cover only what applies:

- **Purpose:** what it is for.
- **Layout:** key directories/files and what each owns.
- **Flow:** how the main path runs, from entry point to result.
- **Dependencies:** notable libraries, services, or config it relies on.
- **Gotchas:** non-obvious behavior worth knowing.

## Output

Answer in chat. Keep it as short as the question allows, with short snippets only when they clarify something that prose can't. If the user asks for the summary as a document, save it as markdown in `~/Markdown` (unless told otherwise) with a descriptive kebab-case filename starting with a short repo name, and give the path with a two-line summary instead of pasting it back.

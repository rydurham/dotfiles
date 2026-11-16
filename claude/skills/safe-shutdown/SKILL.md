---
name: "safe-shutdown"
description: "Use when the user asks to shut down, power off, or sleep the host machine when work is done, especially while monitoring remotely from a phone."
---

# Safe shutdown

Shut down the host machine only after confirming nothing is at risk. The session ends when the machine powers off, so the final report must be sent BEFORE shutdown happens.

## Steps

1. **Detect the OS** (`uname -s`, or `ver` / `$env:OS` on Windows) and pick the matching command from the table below.

2. **Check for unfinished work.** Look for:
   - Running background processes or builds started in this session (long-running `node`, `python`, `make`, test runners, dev servers, running Docker containers).
   - Uncommitted changes (`git status --porcelain`) and unpushed commits (`git status -sb`) in the working directory and any repo touched this session.
   - Files being downloaded or written (large recent writes, partial downloads).
   - Other logged-in users or open SSH sessions (`who`) on a shared machine.

3. **If anything is at risk, STOP.** Do not shut down. Report what was found and ask whether to proceed anyway, commit/push first, or wait. Never commit, push, or kill processes without the user saying so.

4. **If clear, ask for explicit confirmation before scheduling anything.** Use AskUserQuestion (or a plain-text question if it is unavailable) with a short summary: what was accomplished, anything left undone, the OS and exact command, and the delay. Offer Shut down / Sleep / Cancel. Do not schedule the shutdown until the user answers yes in this conversation; if they do not answer or say no, do nothing. A request to shut down made earlier in the conversation does not count as confirmation; ask again at this point.

5. **After confirmation, send the final summary** (what was done, what is left, the exact time the shutdown will fire) with SendUserMessage so it reaches the user's phone before the session dies. Then **schedule the shutdown with a delay (default 2 minutes)** so the user can still cancel. Tell the user the cancel command.

| OS | Shutdown with delay | Cancel | Notes |
|---|---|---|---|
| Linux | `shutdown -h +2 \|\| sudo -n shutdown -h +2` | `shutdown -c \|\| sudo -n shutdown -c` | Plain `shutdown` often works via logind/polkit on a local login; the `sudo -n` fallback fails fast instead of hanging on a password prompt. If both fail, do not work around it; tell the user and suggest a sudoers rule limited to `shutdown` (e.g. `youruser ALL=(root) NOPASSWD: /usr/sbin/shutdown` via `visudo -f /etc/sudoers.d/claude-shutdown`). |
| macOS | `sudo shutdown -h +2` | `sudo killall shutdown` | Without sudo: `osascript -e 'tell app "System Events" to shut down'` (no delay, no cancel, so only use if the user accepts that). |
| Windows | `shutdown /s /t 120` | `shutdown /a` | Usually works from a normal user account. |

If the user asks for sleep instead of shutdown, note that a sleeping machine cannot be woken from the phone unless Wake-on-LAN or similar is set up, and that after a true shutdown they must power it on physically.

6. **Confirm** the command was accepted (exit code 0). If it failed, say so plainly and do not retry with escalated or workaround methods.

## Rules

- Never shut down without an explicit request in the current conversation AND an explicit confirmation at step 4.
- Always use a delay unless the user explicitly asks for immediate shutdown.
- Never force-kill processes or use force flags (`-f`, `/f`, `shutdown -r now` style shortcuts) to get around a blocker.
- Expect a permission prompt for the command and let the user approve it.
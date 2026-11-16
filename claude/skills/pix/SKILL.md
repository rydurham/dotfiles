---
name: pix
description: Use the `pix` CLI for the user's personal image host. Use when the user wants to upload an image, get an image's URL (original or resized), find, tag, caption, delete or restore images, or manage pix sites and API tokens. Triggers include "upload this to pix", "put this image on my image host", "get me a URL for ...", and any mention of the `pix` command.
---

# Using the pix CLI

`pix` manages a personal image host on Cloudflare. Originals are served publicly from `https://pix.stagerightlabs.com`; the management API lives on `https://pix-api.stagerightlabs.com`. The CLI talks to the API. Images belong to a **site** (a slug such as `blog`), and each image has an id (a 26-character ULID).

The CLI is the source of truth. If a command or flag isn't covered here, run `pix <command> --help` before guessing. The source and README are in `~/Workbench/pix`.

## Before you run anything

- Check that it is installed: `pix --version`. If it isn't, point the user to the "The `pix` CLI" section of `~/Workbench/pix/README.md`.
- Authentication is a one-time `pix login`, which prompts for a token without echoing it. You can't type into a prompt, so if a command fails with "Not logged in" (exit 1), ask the user to run `! pix login` themselves.
- `PIX_API_URL` and `PIX_TOKEN` override the saved login for a single command.
- **Never handle token values.** Don't ask the user to paste a token into the chat, don't read `~/.config/pix/` (it holds the login and may hold an admin token), and don't pass `--token` on a command line (it lands in shell history and `ps`).

## Common tasks

**Upload** (the usual job). Pass the site, and tags and alt text if you have them:

```sh
pix upload hero.jpg --site blog --tag hero,landing --alt "Fog over the harbour at dawn"
pix upload "photos/*.jpg" --site blog     # quote globs so pix expands them
```

- stdout gets one URL per file, in input order. Progress, duplicates and failures go to stderr.
- An already-uploaded file (same bytes, same site) is reported as `duplicate` and prints the existing URL. That is not an error.
- If any file fails the exit code is 1, even though the others uploaded. Read stderr for which one and why.
- Allowed types are JPEG, PNG, WebP, AVIF and GIF, up to 25 MB. SVG is rejected.
- Write real alt text that describes the image. Ask if you can't tell what the image shows.

**Get a URL.** `pix upload` prints the original URL. For a resized or converted one:

```sh
pix url <id> --width 800 --format auto --quality 80
```

Options are `--width`, `--height`, `--fit` (scale-down, contain, cover, crop, pad), `--quality` (1 to 100) and `--format` (auto, webp, avif, jpeg, png). Prefer `--format auto`: `webp` and `avif` are only honored when the client's `Accept` header supports them (plain `curl` needs `-H 'Accept: image/webp'`). Always give an explicit width; never `width=auto`.

**Find images.** Newest first, 50 per page:

```sh
pix list --site blog --tag hero --q sunset
pix list --site blog --all --json         # every page
pix info <id>                              # details; add --json for the full record, including r2_key
```

`--q` searches filenames and alt text. Soft-deleted images are hidden unless you pass `--deleted include` or `--deleted only`.

**Edit.**

```sh
pix tag <id> --add landing,2026 --remove draft
pix alt <id> "New alt text"        # or: pix alt <id> --clear
```

**Delete and restore.**

- `pix rm <id>` is a soft delete: recoverable with `pix restore <id>`. It hides the original URL only. Resized `/cdn-cgi/image/...` variants can keep being served from Cloudflare's cache, so a soft delete is not a takedown.
- `pix rm <id> --hard` permanently deletes the file and its record. **Ask the user before running it**, and only with the specific ids they named. Never hard-delete everything matching a filter.

**Sites and tokens** (admin token only):

```sh
pix sites list
pix sites create docs --name "Docs"       # slug: lowercase letters, digits, hyphens
pix tokens list
pix tokens create blog-laptop --site blog  # omit --site for an admin token
pix tokens revoke <id>
```

`tokens create` prints the secret once and it can't be retrieved again. Have the user run it with `!` so the secret doesn't enter the conversation, and tell them to save it.

## Scripting

- Put `--json` anywhere on the command line. stdout is then only JSON; errors go to stderr as `{"error":{"code","message"}}`.
- `pix list --json` returns `{ "images": [...], "next_cursor": ... }`. `pix upload --json` returns an array of `{ file, status: "created" | "duplicate" | "error", image?, error? }`.
- Exit codes: `0` success, `1` error, `2` usage error (bad flags or arguments). Plain errors read `Error: <message> (<api error code>)`.
- Image fields worth knowing: `id`, `site_id`, `url` (original), `r2_key`, `width`, `height`, `alt_text`, `tags`, `deleted_at`.

## Using images on a website

- Store the image **key** (`r2_key`, like `blog/2026/<ulid>.png`) or a relative path in site content, not a full URL, so the host can change later without editing content.
- A client site's Content-Security-Policy needs `img-src https://pix.stagerightlabs.com`.
- A resized image is `https://pix.stagerightlabs.com/cdn-cgi/image/width=800,format=auto/<key>`. `pix url` builds this for you.
- Pages that send `Cross-Origin-Embedder-Policy: require-corp` need `crossorigin="anonymous"` on the `<img>` tag for resized images.

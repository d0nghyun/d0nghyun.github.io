# d0nghyun.github.io — Routing

Personal blog. Hugo + PaperMod, deployed to GitHub Pages by Actions on
push to main.

## Read before working

| Task | Read |
|------|------|
| Writing a new post end-to-end | `.claude/skills/write-post/` — the process |
| Writing or editing a post | `WRITING.md` — the writing contract. Binding. |
| Habits of thought | `THINKING.md` |

## Facts

- Posts: `content/posts/YYYY-MM-DD-kebab-case.md`
- Config: `hugo.toml`. Theme is a submodule (`themes/PaperMod`) — never
  edit it in place; override via `layouts/` or `assets/` if needed.
- Deploy: push to main → `.github/workflows/hugo.yml` → live in ~1 min.
  Local check: `hugo --gc --minify`.
- This repo is public. Nothing secret goes in it.

## Hard rules

- `WRITING.md` § Process: no new post ships without explicit human
  approval of the final text.
- Behavioral guards are hooked in `.claude/settings.json` (scope guard,
  silent-fallback lint, doc line cap).

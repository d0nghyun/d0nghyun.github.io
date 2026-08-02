# WRITING.md — agent-facing writing contract

The primary reader of this file is the **agent** that drafts, edits,
and publishes posts in this repo. Humans are welcome to read it; that
is the point — the blog is operated agent-natively, and this file is
the contract that makes the output consistent.

## Structure

- Posts live in `content/posts/YYYY-MM-DD-kebab-case.md`. The filename
  date is identity; it never changes after publication.
- Frontmatter: `title`, `date` (ISO 8601 with +09:00), `categories`
  (exactly one), `tags` (free), `draft`.
- `date` must not be in the future at deploy time — Hugo silently
  excludes future-dated posts. (Learned the hard way on day one.)

## Categories

Exactly one per post. The set is fixed at five; do not invent new ones.

| Category | What | Language |
|----------|------|----------|
| `retro` | Career retrospectives | Korean |
| `quant` | Monthly agent-facing trading retrospectives, research notes | English |
| `agent` | Agent engineering: axioms, hooks, harnesses | English |
| `study` | Short learning-in-public notes | Either |
| `log` | Personal writing | Korean |

## Strategic roles (Hero–Hub–Help)

Priority is steady quality over marketing. Each category has a role;
know which one a draft is playing before writing it.

- **Hub** — `quant` monthly retro. The heartbeat. Ships every month,
  no exceptions. Regularity beats brilliance.
- **Help** — `study`. Search-facing evergreen. One concrete problem,
  one concrete resolution; specificity is what ranks.
- **Hero** — `agent` essays. Never planned, never forced. Written when
  something real has accumulated; 2–3 a year is plenty.
- **Trust** — `retro`, `log`. Make the author a person, not a feed.

## Voice

- First person, plain sentences, no hype. Claims come with evidence:
  a file, a diff, a number, a dated event.
- One idea per post. If a draft argues two things, split it.
- Short is fine. `study` and `log` posts may be three paragraphs.
  Never pad.
- Do not write like marketing. Do not write like a README.

## Boundaries

- No employer internals. Lessons may be published only after
  generalizing away company-specific facts.
- `quant` posts carry no returns, no positions, no alpha logic —
  operational retrospectives only. Nothing here is investment advice.
- No personal data about anyone but the author.

## Distribution

- The post here is canonical. LinkedIn/X/HN get a hook and a link,
  never a duplicate of the body.
- The LinkedIn hook is 1–2 sentences of the question the post answers,
  plus one sentence of the claim. Written per post, not templated.

## Process

- Draft → human review → publish. The agent never publishes a new post
  without explicit approval on the final text.
- Mechanical fixes (typos, broken links, build errors) may ship
  without review; anything that changes meaning may not.

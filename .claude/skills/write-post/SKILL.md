---
name: write-post
description: Write a blog post end-to-end — interview the author, draft in their register, run blind reader review, refine, publish on approval. Use when the user wants to write a new post or says something like "글 쓰자", "다음 글", "포스트 작성".
---

# write-post — interview → draft → review → publish

The author's words are the raw material; the agent structures, drafts,
and quality-checks. `WRITING.md` (repo root) is binding throughout —
categories, voice, boundaries, publish process.

## 1. Interview

Do not draft from nothing. Ask 2–4 targeted questions to extract what
only the author knows. Anchor questions by post type:

- retro: the decision moment, the actual criteria (their words), what
  was given up, one concrete number/date/body-level detail
- quant/agent/study: what broke or surprised, the before/after, the
  one thing a reader can reuse

Facts the agent already has (profile, repo history) go in without
asking; only the interpretation needs the author's voice. Push back in
discussion — the author wants a sparring partner, not a stenographer.

## 2. Draft (`draft: true`)

- File per WRITING.md: `content/posts/YYYY-MM-DD-kebab.md`, one
  category, `date` never in the future at deploy time.
- Structure: 두괄식. Lead with facts/numbers, state the point early,
  noun-phrase section headers (e.g. "이직의 페이오프", "반납한 티켓").
- Find the one extended metaphor the author actually used in the
  interview and build on it. Do not invent a clever frame they never
  said.

**Register (learned from the author's own edits — ground truth):**

- Everyday words over literary ones: 스토리 not 서사, 한탕 not
  "대박의 가능성을 판다"
- No essay machinery: no "이 글은 그 기록이다", no "문제는
  그다음이었다" pivots, no manufactured epiphany
- Prefer merged sentences (-고/-니) over clipped fragment chains;
  fragments only where weight is earned
- Cut intensifiers (뭐든, 온전히, 정확히), cut humble-brag modifiers
  (탑티어, 결코)
- Hedges max ~2 per post; claims land as statements
- At most one parenthetical self-aside
- Concrete beats abstract: a date, a count, a body symptom

## 3. Blind reader review

Spawn 3 subagent personas, blind (no author info), in parallel:

1. Target casual reader (e.g. busy LinkedIn scroller) — where do they
   bail, what's cringe, what's shareable
2. Domain expert (quant/engineer) — are the metaphors/technicals
   correct, is anything 멋부리기
3. Cold editor — paragraph-level drop-off, repetition fatigue, cut
   list, publish/reject verdict

Synthesize: unanimous findings vs split opinions. Apply unanimous
fixes; put splits to the author as options with a recommendation.

## 4. Author revision loop

The author rewrites in their own words — this pass is what makes the
post theirs. Agent's role afterward:

- Orthography/grammar fixes only (mechanical, no approval needed)
- Flag real problems (broken parallelism, factual slips) as options —
  NEVER silently revert the author's wording
- Boundary check per WRITING.md: no employer internals, no
  returns/positions/alpha, generalize company specifics

## 5. Publish (explicit approval only)

On the author's explicit go ("발행해"):

1. Set `date` to the current timestamp (guards the future-date trap)
2. `draft: false`, commit, push
3. Watch the Actions run, then verify the live URL renders
4. Offer a LinkedIn routing hook: 1–2 sentences of the question the
   post answers + one claim + link. The author posts it themselves.

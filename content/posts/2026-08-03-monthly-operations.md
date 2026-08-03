---
title: "[2026-07] Monthly operations"
date: 2026-08-03T10:00:00+09:00
categories: ["quant"]
tags: ["monthly"]
draft: true
cover:
  image: "/figures/2026-07-monthly/nav-index.png"
  alt: "Live NAV index vs BTC/ETH with gross exposure"
  relative: false
  hiddenInSingle: true
---

What I run is a cross-sectional long-short book on Binance perpetual futures.
Several signals combined, buying the relatively cheap and selling the relatively
expensive. Dollar-neutral, but not beta-neutral.

I set it up through early July, in the evenings after work following a job
change, and went live on July 9th. This is the first month's record and I intend
to write one every month. I don't disclose the capital — everything here is a
ratio.

## Performance

{{< stats "Return, 22 days=+11.7%|pos" "Max drawdown=-3.0%|neg" "Ann. volatility=27.4%" "t-stat=1.7|note:one-sided p≈0.04" >}}

{{< figure src="/figures/2026-07-monthly/nav-index.png"
  caption="Live NAV indexed to 100 at 7/9, against BTC and ETH. Vertical lines are book swaps; the lower panel is gross exposure as a multiple of equity. Dashed segments are where snapshots were missing and the last published weights were held." >}}

The book returned 11.7% over 22 days with a 3.0% maximum drawdown. It also got
swapped nine times in that month, which says as much about the trial and error as
it does about the result.

Here is why those numbers should not be taken at face value. Annualized
volatility of 27.4% (365-day basis) implies a 6.8% standard deviation over 22
days. An 11.7% return is 1.7 times that — one-sided p ≈ 0.04. The sign is right,
but it clears "could be luck" by a hair. Run the same inputs through a Sharpe
calculation and you get 7, except the standard error on that estimate is roughly
±4 at this sample size, which puts the confidence interval somewhere between 0
and 15. That is why there is no Sharpe figure in this post.

Exposure matters too. Gross ran between 0.44× and 1.99× of equity this month and
averaged 1.28×. Normalized to 1× exposure, the return is 9.2%.

That the return did not come from market direction is checkable. BTC beta was
−0.26 and BTC gained 0.4% over the same window, so the beta-explained portion of
the return is −0.1 percentage points. Add the ETH leg and it is −1.2. Essentially
none of the 11.7% is market direction.

{{< figure src="/figures/2026-07-monthly/sleeve-attribution.png"
  caption="Realized contribution per signal, split long/short. Covers 7/16 onward, where fill-level records exist. Signal names are masked." >}}

{{< figure src="/figures/2026-07-monthly/sleeve-correlation.png"
  caption="Daily correlation across the ten signals plus BTC and ETH. With 22 observations, anything under |0.42| is indistinguishable from noise." >}}

Eight of the ten signals correlate negatively with BTC, pointing the same way as
the book's negative beta. Pinning beta at zero would take an explicit constraint
and I have not found a reason worth its cost yet. What I have not checked is
whether those eight are negative for the *same* reason. If they are, ten signals
are effectively one bet — next month's question.

## What got fixed

The biggest change after going live was not alpha. It was how costs get counted.

Funding was not being charged anywhere in simulation. Perpetual futures move
money every eight hours purely for holding a position, and there was a flag to
switch that on and off — except no code path ever read it. On or off, the same
curve came out. Wiring it through and defaulting it on reordered the books and
flipped one signal negative.

While I was there I started persisting the venue's actual funding ledger rather
than the simulated estimate. Being able to check the estimate against reality is
the most practical thing that changed this month.

So I can finally state what costs actually are. Over the 11-day window with
complete fill records: fees −0.61% of NAV, slippage −0.45%, funding +0.56%, for
−0.51% net. Annualize that and it is roughly 17%. Traded notional over the same
window was 12× average equity — about 1.1× turnover per day — and that turnover
is where the cost comes from. Funding being positive is this month's positioning
happening to line up, not structural income.

A data hole had also manufactured a fake alpha. One signal backtested positive
only because the funding series had gaps in it; filling them turned it negative.
Dropped.

{{< figure src="/figures/2026-07-monthly/sleeve-decomposition.png"
  caption="Per-signal NAV against the whole book. Not live results — this reconstructs what July would have looked like had the current composition been held all month. That composition was arrived at with July's data in hand, so the curve is biased upward." >}}

I also measured whether truncating to the top 40 per side contributes anything.
Normalized for exposure, before and after come out at 7.5% either way. Twenty-two
days cannot separate those, so the honest reading is that there is no evidence
truncation generates alpha. It does scale exposure. What happened to the names
that got cut is unrecorded — I start logging that next month.

## Where it binds

{{< figure src="/figures/2026-07-monthly/ticker-concentration.png"
  caption="Top and bottom ten names by realized P&L, as a share of total absolute P&L. Names are masked." >}}

Drop to the name level and the picture changes. More than 200 names traded over
the month, and the top and bottom twenty produced over half of absolute P&L.
Though with 200 fat-tailed assets over 22 days, that much concentration is
roughly what you would expect anyway — it is not by itself evidence of a problem.

{{< figure src="/figures/2026-07-monthly/slippage-dist.png"
  caption="Slippage across 1,661 fills, in bps. Median +2.0bp; the 5th and 95th percentiles sit at −13.4 and +19.3." >}}

The problem is that those few names skew illiquid. Median slippage is 2bp, which
looks fine on average, but the 2.5% of fills beyond ±60bp account for 17% of all
slippage cost — mostly market orders in thin names. At this size it is ignorable;
at a larger size this is what binds first. I cannot yet say at what size, because
I have not been recording order size against each name's average daily volume.

## Running it alone on a Mac mini

Doing this alone is not easy. I write the infrastructure, wire the data, and do
the analysis, so when any one of those quietly springs a leak there is nobody
else to notice. One leak got expensive this month: a single symbol's slow
response was discarding entire collection cycles, it recurred without my
noticing, and a 15-hour gap and a 4-hour freeze went by. The book sat on stale
decisions throughout.

Fixed it and added monitoring. Discord pings me when data is late or a cycle
slips — enough to know something broke while I'm out. Even the monitoring lied
once: the process manager reported 40MB per runner where direct measurement
found bursts up to 723MB.

The order path got a fix too. Delisted and halted names were causing repeated
order rejections, so now they are screened out in one pass right before
publication. Which means I handled nine instances of the same rejection class
individually before fixing the cause on the tenth.

## Research

New alpha did not come easily. There was a nine-day stretch of roughly thirty
tests with zero registrations, and at month end I put the retail chart-pattern
family through 240,000 events and killed all of it. Gross returns were positive;
none of it cleared the fee wall.

Research runs entirely on agents. The loop — propose, attach data, judge by event
study — runs without supervision, and it has now tested more than 550 hypotheses.

Throwing more is not the goal. Ideas are cheap once an agent generates them, so
the binding constraint is the other side: what it takes to pass. Throw 550 and a
few will look good by chance, and that is not solved by tightening thresholds
after the fact. Better to reduce the number thrown. So the first gate is not
statistical, it is a question — can you say why this makes money? Not picking the
straightest NAV, but being able to name a mechanism. Statistical gates come after
that, five of them.

Three things remain unsolved.

The mechanism gate only reduces trials if it sits *before* the backtest, and
right now some of it happens after. Attaching a reason once you have seen the
result is not a gate, it is a rationalization.

The agent that proposes the mechanism is the agent that judges it. Handing
plausibility review to the machine that is best in the world at generating
plausible explanations means I cannot tell whether the gate binds unless I record
pass rates per stage — and I don't know how many of the 550 died at the mechanism
step.

Finally, the five statistical gates all test whether an individual hypothesis is
robust. None of them corrects for having thrown 550. Robustness and multiplicity
are different axes, and I have been answering the second with the first. Tighten
the gate hard enough and only large effects survive, but this book is ten
individually-weak signals combined — so I am looking at moving the threshold from
the signal to its marginal contribution to the portfolio.

## Next

The first month's numbers look good and 22 days proves nothing. Next month goes
to stabilizing operations rather than chasing return.

The leverage baseline rests on a broken backtest. A ladder cuts exposure in steps
at −10% and −15% drawdown, and leverage is set to whatever that ladder can
absorb — except the distribution behind those levels came from the same backtest
that was not charging funding. On top of that, realized drawdown was 3% this
month, so the ladder has never actually fired. As live data accumulates, those
levels need to move onto measurement.

I'll fix the remaining half of the data-collection defect and build a shadow
simulator that reconstructs what the book would have held during an outage. Right
now I can show what stopped but not what it cost.

I'll also start recording order size against each name's traded volume, so that
"this binds as capital grows" becomes a number rather than an assertion.

And the nine swaps need to come down. Individual compositions ran live for
anywhere from seven hours to four days, which is not long enough to judge any of
them. Between iterating fast and observing long enough, this is tilted much too
far one way.

The strategy and the research and execution pipelines are all operated by agents.
It is a setup with more documents written for agents than code written by humans,
and I intend to write that structure up separately.

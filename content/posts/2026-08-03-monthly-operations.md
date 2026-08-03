---
title: "[2026-07] Monthly operations"
date: 2026-08-03T10:00:00+09:00
categories: ["quant"]
tags: ["monthly"]
draft: true
cover:
  image: "/figures/2026-07-monthly/nav-index.png"
  alt: "Live NAV index vs BTC/ETH with position size"
  relative: false
  hiddenInSingle: true
---

What I run is a cross-sectional long-short book on Binance perpetual futures.
Several signals combined, buying the relatively cheap and selling the relatively
expensive. Dollar-neutral, but not beta-neutral.

I set it up through early July, working on it in the evenings after a job change,
and went live on July 9th. The strategy, the research and the execution are all
run by agents; how that works I'll get into over time. This is the first month's
record and I'll keep one every month. I don't disclose the size — everything here
is a ratio.

## Performance

{{< stats "Return, 22 days=+11.7%|pos" "Max drawdown=-3.0%|neg" "Ann. volatility=27.4%" "t-stat=1.7|note:one-sided p≈0.04" >}}

{{< figure src="/figures/2026-07-monthly/nav-index.png"
  caption="Equity indexed to 100 on July 9th, against BTC and ETH. Vertical lines mark where the portfolio was swapped; the lower panel is position size relative to capital. Dashed segments are where data was missing and the previous weights were held." >}}

11.7% over 22 days, with a 3.0% worst drawdown. The book also got swapped nine
times in that month, which says as much about the trial and error.

At 22 days, though, none of this is reliable. With no skill at all, luck alone
produces a result this good about 4% of the time. Ratios like Sharpe are not
worth computing here — the error on them is as large as the return.

Leverage matters too. Position size ran between 0.44× and 1.99× of capital,
averaging 1.28×. That range is not drift; I raised it in steps, only as far as
the drawdown I could stomach and the confidence I had in the strategy allowed. So
volatility grows toward the end of the month. Without leverage the return would
be around 9.2%.

The return did not come from the market going up. This book tends to fall
slightly when BTC rises (beta −0.26), and BTC gained 0.4% over the same window,
so the market-explained part of the return is −0.1 percentage points. Add ETH and
it is −1.2. Essentially none of the 11.7% is market direction.

{{< figure src="/figures/2026-07-monthly/sleeve-correlation.png"
  caption="How closely the ten signals and BTC/ETH move together day to day. With 22 days of data, anything under 0.42 is indistinguishable from chance." >}}

Eight of the ten signals move opposite to BTC — the same direction as the book as
a whole. What I have not checked is whether those eight are negative for the same
reason. If they are, running ten signals is effectively running one.

## Breaking the result down

{{< figure src="/figures/2026-07-monthly/sleeve-attribution.png"
  caption="What each signal actually earned, and whether it came from the long or the short side. Covers July 16th onward, where fill records exist. Signal names are masked." >}}

The ten signals did not contribute evenly. A few at the top made most of it and a
few at the bottom took some back. Split by side, the short leg earned more than
twice what the long leg did. The market went sideways this month, so selling the
expensive side worked — whether that is structural or just this month, one month
cannot say.

{{< figure src="/figures/2026-07-monthly/sleeve-decomposition.png"
  caption="Per-signal equity curves against the whole book. Not live results — this assumes the current composition was held all month, so it comes out better than reality." >}}

Overlaid, the signals earn and lose at different times. That is the reason for
combining them at all — though if eight of them are tied to BTC the same way, the
diversification is less than it looks.

{{< figure src="/figures/2026-07-monthly/ticker-concentration.png"
  caption="The ten biggest winners and ten biggest losers by name, as a share of total P&L. Names are masked." >}}

At the name level, more than 200 names traded over the month and the top and
bottom twenty produced over half of the P&L. With 200 volatile coins over 22 days
that much concentration is roughly what you would get anyway, so on its own it is
not evidence of a problem.

{{< figure src="/figures/2026-07-monthly/slippage-dist.png"
  caption="How far 1,661 fills landed from the intended price. Half are inside 0.02%; the outer 5% sit at −0.13% and +0.19%." >}}

The problem is that those few names are mostly thinly traded. Orders fill away
from the price you wanted — usually by about 0.02%, which is ignorable. But fills
that slipped more than 0.6% are only 2.5% of the total and account for 17% of all
the slippage. At this size I can absorb that; as capital grows this is what binds
first. At what size, I cannot yet say.

## Running it alone on a Mac mini

I write the infrastructure, wire the data, and do the analysis, so when one of
them quietly springs a leak there is nobody else to notice. One leak got
expensive this month. A single symbol's slow response was discarding whole
collection cycles, it kept happening without my noticing, and a 15-hour gap and a
4-hour freeze went by. The portfolio sat on old decisions the whole time.

Fixed it and added monitoring. Discord pings me when data is late or a cycle
slips. Even that monitoring lied once — the process manager reported 40MB per
runner where it was actually spiking to 723MB. On the order side, delisted and
halted names are now screened out in one pass right before publishing. Which
means I handled the same rejection nine separate times before fixing the cause on
the tenth.

## Research

Good new signals did not come easily. There was a nine-day stretch of about
thirty tests with nothing to keep, and at month end I put the chart patterns
retail traders like through 240,000 cases and threw all of it out. Before fees it
is positive; after fees there is nothing left.

{{< figure src="/figures/2026-07-monthly/research-funnel.png"
  caption="Ideas tested per day and how each was judged. Top is daily, bottom cumulative. The blue band is this month." >}}

Research runs entirely on agents. It keeps going without supervision, and since
late May it has made 551 runs across 356 ideas. 5.4% of those made it through
into actual use.

Throwing more is not the goal. Ideas are cheap, so what matters is the bar to
pass, and out of 550 attempts a few will look good by chance. Tightening
after the fact does not solve that; reducing the number thrown does. So the first
gate is not statistical, it is a question — can you explain why this makes money?

Three things about that remain unsolved. First, the question only reduces
attempts if it is asked *before* the backtest, and right now some of it happens
after. Attaching a reason once you have seen the result is not a gate, it is an
excuse. Second, the agent that supplies the reason is the agent that judges it —
handing plausibility review to the machine best at producing plausible
explanations. Without recording how many die at each stage, I cannot tell whether
the gate works. Third, the statistical checks that follow only test whether one
signal is solid; none of them corrects for having thrown 550.

## What got fixed

The biggest change was not the strategy. It was how costs get counted.

Perpetual futures move money every eight hours just for holding a position —
funding. The backtest had never once subtracted it. There was a setting to turn
it on and off, but no code actually read that setting, so on or off produced the
same result. Wiring it properly and re-running reordered the strategies and
flipped one signal into a loss. While I was there, I started pulling in what the
exchange actually charged.

So I can finally say what costs are. Over the 11 days with complete records:
fees −0.61% of capital, price slippage −0.45%, funding +0.56% received, netting
−0.51%. Annualized that is about 17%. Traded volume over the same window was 12×
capital — turning the whole book over roughly once a day — and that is where the
cost comes from. Funding being positive was this month's positioning happening to
line up, not recurring income.

A hole in the data had also manufactured a fake return. One signal backtested
positive only because the funding record had gaps; filling them turned it
negative. Dropped.

The signals pick names and the book keeps only the top 40 per side, so I checked
whether that cut adds anything. Stripped of the leverage effect, before and after
both come out at 7.5%. Twenty-two days cannot separate those, so there is no
evidence the cut generates return. It does size up the position. What happened to
the names that got cut is unrecorded — I start logging that next month.

## Next

Twenty-two days proves nothing. Next month goes to stabilizing operations rather
than chasing return.

The leverage baseline rests on a broken backtest. A ladder cuts the position in
steps once losses reach 10% and 15%, and leverage is set to whatever those losses
allow — except the thing that produced those levels is the same backtest that was
not subtracting funding. On top of that, the worst loss this month was 3%, so the
ladder has never once fired.

The rest is measurement. Fix the other half of the data-collection defect, build
something that reconstructs what the book would have held during an outage, and
start recording order size against how much each name actually trades. And the
nine swaps need to come down — none of them ran longer than four days, some only
seven hours, which is not long enough to judge anything.

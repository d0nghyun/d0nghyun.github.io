---
title: "Risk management, on my own"
date: 2026-08-13T21:00:00+09:00
categories: ["quant"]
tags: ["risk", "drawdown", "systematic"]
draft: false
cover:
  image: "/figures/2026-08-risk/cover.svg"
  alt: "309 days of drawdown, with the 3x path dropping below the −15% line"
  relative: false
  hiddenInSingle: true
---

Run money for a firm, or for a pod shop, and the risk limits come down from above.
An individual has none of that, and in my case not much time or know-how either. It
sits on a machine at home and there are plenty of days I never look at it. Sometimes
that helps. I've forgotten about it through a bad drawdown and found it recovered
before I noticed.

So what I tend to recommend to people is the buy-and-forget kind of investing. US
index, allocation funds, pension accounts, TDFs, individual names held long if you
care to. The answers arrive years later and you sleep fine in the meantime. For most
people that is enough.

But if you want to run a strategy in a market that never closes, with real turnover,
what does that take? For me it comes down to two rules and four numbers.

Both of them watch drawdown, not return. Here are the rules and the numbers first;
why they are set where they are comes after.

## Two rules

There are exactly two.

One is the size-down rule, the other is a kill switch. Both are brakes, but they
measure different windows and do different things.

| | Size-down rule | Kill switch |
|---|---|---|
| Window | Weeks to months since the high | Minutes to hours |
| Trigger | −10% / −15% from the high-water mark | −5% in a short window |
| Action | Halve exposure, then flatten | Stop sending new orders |
| Positions | Reduced or closed | Untouched |
| Reset | None. I reset it by hand | Automatic, next day |
| What it catches | An edge dying slowly | Something broken |

Exposure is the size actually sitting in the market. It's a separate number that
multiplies with leverage. Nothing turns itself back on, because turning it back on
isn't a machine's decision. It's me deciding to believe in the thing again.

The kill switch isn't there to cut losses. It's there to take my hands off when
something is wrong. When a book falls that far in minutes, I can't tell in the
moment whether an order went out wrong, the model emitted something strange, or the
market is genuinely breaking. When I can't tell, sending no new orders is the safest
thing to do.

{{< figure src="/figures/2026-08-risk/sizedown-rule.svg"
  caption="Exposure by drawdown band. Once a step goes down it stays there until I reset it." >}}

A −15% drawdown built up over weeks moves the size-down rule while the kill switch
never fires. A 5% fall inside an hour is the reverse: stopping orders comes before
resizing them. Which is why flattening only ever comes from the size-down rule. For
what it's worth, the worst single day at the current scale was −9.4%.

The one-month rule isn't automatic. The only things the machine does are the two
above. If the book stays below its high for a month, that's my cue to sit down and
decide whether to stop.

Hitting −15% doesn't mean the strategy is done forever. I'd flatten, look at what
broke, fix what can be fixed, and go back in. A brake isn't a device for quitting,
it's a device for buying time to think. That's the same reason nothing restarts on
its own: the moment it restarts should be a moment I judged.

I also tried scaling exposure up and down with volatility, and dropped it. Returns
in the flagged high-volatility states weren't actually worse, so cutting size there
was pure cost. I measured it three separate times before letting it go. Forecasting
volatility and forecasting losses turn out to be different jobs.

That's all of it. Neutralising factor exposure, decomposing excess return — those
still feel like luxuries to me.

## Four numbers

Alerts come through Discord, and the numbers I actually read are four: current
drawdown, max drawdown, the high-water mark, and time under water.

{{< figure src="/figures/2026-08-risk/four-metrics.svg"
  caption="All four live on one curve. The moment a new high prints, current drawdown and time under water reset to zero." >}}

Four because all four are inputs to the rules above. Current drawdown and the high
are what the size-down rule reads; time under water is what my one-month rule
measures. Monitoring is less about building a dashboard than about seeing the
minimum state the rules need to run.

Sharpe and Calmar I look at in backtests and research. Over a month or two of live
data the error on a Sharpe is bigger than the number. Even in research I mostly look
at the chart and go with it if it looks usable. The bar is loose: if there's an edge
visible anywhere, I'll put it up.

{{< figure src="/figures/2026-08-risk/alert-card.svg"
  caption="The alert that arrives on every rebalance. Book size is masked; the highlighted parts are the four I actually read." >}}

## Why drawdown and not return

There's no return in those four numbers. No Sharpe either. They all measure "now
against the past."

What I want to know first is whether the strategy is still behaving the way it used
to. Returns show up when you're lucky, and they keep showing up for a while after an
edge has died. So watching returns means finding out late. Drawdown and time under
water tell me sooner, because failing to print a new high is another way of saying
what worked yesterday isn't working today.

The two rules sit on drawdown for the same reason. The question isn't how much I
lost, it's how far this has drifted from what it used to be.

## The agent answers on the same terms

Agents run a good part of my research and execution. When the rules and the numbers
above are written down somewhere, the agent reads them too — it means there is a
record saying that long deep drawdowns are unwelcome and that printing new highs
quickly, even small ones, is what I want.

So when I ask "looks like we're down, should I stop trading?", what comes back is a
diagnosis instead of reassurance. How many sigma this drawdown is against the past
distribution, in other words how unusual this size is; how common a spell under water
this long is in a normal sample. Without that record on file, the same question gets
"it'll be fine."

{{< figure src="/figures/2026-08-risk/agent-reply.svg"
  caption="Redrawn from a real exchange. Every number in the reply comes off the same 309-day curve." >}}

## Costs don't wait

From here on it's why those numbers are set where they are.

I start with costs because they're an opportunity cost. Without conviction that the
book earns more than them, a strategy doesn't blow up so much as bleed downward
quietly. Nothing appears to happen while the money leaves. That's also why I can't
hold this the way I hold an index — the cost runs while I wait. And it's less a
question about the asset than about the strategy, so it would look the same running
US equity long-short or futures.

On turnover: measured over the last month of fills, the book trades 1.04× of capital
a day. Annualised that's 380×. What I run is a cross-sectional long-short on Binance
perpetual futures, buying the relatively cheap and selling the relatively expensive;
the details are in the [monthly write-up](/posts/2026-08-03-monthly-operations/).

| Metric | Value |
|---|---|
| Daily traded / capital (25 days measured) | **1.04×** |
| Annualised turnover | **380×** |
| Fee per notional (taker) | **0.05%** |
| Fees as a share of capital | **19%/yr** |

Orders are effectively all market orders, so fees run at the taker rate of 0.05% of
notional. It sounds like nothing, but at this turnover it comes to 19% of capital a
year. On top of that these are perpetuals — futures with no expiry — so simply
holding a position exchanges funding every eight hours, and over this window that
cost 11% annualised. Last month it paid me instead; the sign moves around.

| Cost | Annualised |
|---|---|
| Fees | 19%/yr |
| Funding (this window) | 11%/yr |
| **Total** | **19–30%/yr** |

So 19% is the floor and windows with funding against me reach 30%. Two or three
tenths of capital a year has to be cleared before breaking even. You cannot hold that
the way you hold an index fund fighting over 0.1% of fees.

## Tolerance

What matters most to me is how deep a fall I can sit through, and how long — how
quickly it comes back.

There's a term in asset management, the mandate: the contract the party handing over
the money gives to the party running it. Among other things it settles how much risk
is acceptable and where the limits are. On your own nobody makes you write one, but
I find it worth thinking through.

Take the US index in my pension. I keep buying it through months of double-digit
falls. The reasoning isn't sophisticated: American companies do their jobs far better
than I do mine, and if that fails, everything fails together. The calm that sentence
gives me is what tolerance actually is. It's the same reason I watch a lot of Ken
Fisher.

In practice I hold leveraged ETFs long term, a mix of 2x and 3x, accumulating through
the falls and rotating into the plain index once it clears the previous high. That's
how I went through a −60% stretch in 2022. The Nasdaq 100 itself was −35% over the
same window.

I'm the same person, and I'm far stingier with the systematic book. Down 10% from the
high, half comes off; down 15%, all of it.

The backtest gets fitted to that number, not the other way around. So the line is
less a loss limit than a signal that my own risk budget has been exceeded. Being
stopped out at a historical maximum doesn't mean the strategy got slightly worse; it
means the regime changed, or I've walked into a market I have never seen. The ruler I
measure tolerance with is the past I've observed, and outside that it isn't data, it's
a bet.

Last comes duration. Depth alone misses the shallow, long stay below the high. If
that's what I'm signing up for I'd rather just hold the index. Three months at −7% is
already cold. To catch it before it gets there, a month below the high is when I sit
down and reconsider.

| Asset | What I trust | Tolerance — depth · duration · size |
|---|---|---|
| US index<br>(accumulated via leveraged ETFs) | Structure — American companies do their jobs better than I do mine, and if that fails everything fails together | Depth: keep buying through tens of percent<br>Duration: unlimited<br>Size: the core of long-term assets |
| Systematic strategy | Statistics — only that an edge existed in a past sample | Depth: −10% half · −15% flat (automatic)<br>Duration: one month below the high triggers review (my call)<br>Size: a little over 5% of total assets |

Why sit through tens of percent on one and cut the other at −15%? Thinking about it,
what sets tolerance isn't the asset, it's what I trust about the asset. What I trust
about the index is structure: companies earn and it accrues to shareholders, a story
time keeps proving. A fall doesn't damage that reasoning. If anything it says things
got cheaper. What I trust about the strategy is statistics — only that an edge existed
in a past sample. So a drawdown in the strategy isn't information that it got cheaper,
it's information that the edge may be dead. Different reasons, different depths.

## Leverage is arithmetic

Pinning tolerance down first buys you one thing: leverage stops being a preference and
becomes the one unknown left.

The strategy sends its orders at 1x. That means capital only, nothing borrowed, and
the backtests all run on that basis.

Drawdown deepens roughly in proportion to leverage — put on 3x and the drawdown goes
close to three times as deep. Which gives −15% ÷ −6.1% ≈ two and a half. It's an
approximation, though. Compounding means 3x doesn't multiply the drawdown by exactly
three. So I don't stop at the division; I re-run the path at 3x and check.

A strategy good enough to have shallow drawdowns can carry more. One with deep
drawdowns can't carry much no matter how good the returns look. I'm not picking the
leverage; tolerance and the strategy pick it together.

{{< stats "Worst 1x drawdown, 309 days=-6.1%|neg" "My tolerance=-15%|neg" "Cap without brakes=2.5x" "Leverage actually run=3x|note:assumes the size-down rule" >}}

One thing to be careful about. That −6.1% is not a ceiling, it's the worst I've seen
so far. 309 days is short of a full crypto cycle, and a maximum drawdown only grows as
the sample does. It's also why −15% has never once been hit: the day it is, I'm
already outside my own data.

And I run 3x, which is past the number the arithmetic gives. Replaying those same 309
days at 3x, the worst is −17.6%, below my flatten line.

{{< figure src="/figures/2026-08-risk/drawdown-1x-3x.svg"
  caption="The same 309 days of drawdown at two scales, hourly. At the size the strategy actually orders, −6.1%; sent at 3x, −17.6%. No brakes applied here." >}}

Switch the brakes on and it changes. On day 68 it touches −10%, exposure halves, and
from there it takes the hits at half size, so the drawdown stops at −13.9%. −15% is
never reached. Half of 3x is 1.5x, which is below the 2.5x cap the arithmetic gave.

So 3x isn't a number that breaks my tolerance, it's a number that assumes the brakes.
It isn't free, either. Run all the way through at 3x with no brakes and the book ends
at 6.1× the starting capital; halved along the way it ends at 2.9×. That gap is what
the brake costs.

The same story holds looking at the episodes one at a time. Below are the five
stretches deeper than −3% plus the one I'm in now, aligned at their peaks. All at 1x.

{{< figure src="/figures/2026-08-risk/drawdown-episodes.svg"
  caption="Five backtest stretches deeper than −3% and the current live one, aligned at the peak, all at 1x." >}}

| Episode | Depth (1x) | At 3x | To trough | Total |
|---|---|---|---|---|
| 2025-11-04 | −6.10% | −17.57% | 27.3d | 45.1d |
| 2026-04-23 | −4.82% | −13.83% | 1.9d | 9.0d |
| 2026-05-04 | −3.72% | −11.02% | 23.0d | 30.4d |
| 2026-04-13 | −3.38% | −9.96% | 4.2d | 8.4d |
| 2026-03-23 | −3.26% | −9.62% | 8.8d | 12.4d |
| Now (ongoing) | −1.98% | −5.88% | 2.3d | 4.0d so far |

At 1x the current stretch is the shallowest of the six. It feels large in the account
because I'm running 3x, not because the strategy got worse. Mixing those two up is how
you misread the situation.

Say 3x and people think liquidation. Because the book is market-neutral, margin usage
runs around 1% even at 3x. The real risk isn't liquidation, it's the strategy going
cold, which is why the brakes watch drawdown rather than margin.

Order matters. Set tolerance, measure the strategy's drawdown, then decide scale and
exposure. Go the other way — set leverage out of greed for returns and discover your
tolerance after it's breached — and the market usually teaches you.

## 92.5% of the time, below the high

Run the same 309 days at 1x and the book ends at 1.85×. And 92.5% of that period was
spent below the previous high. Even over a stretch that went well.

{{< stats "Time below the previous high=92.5%" "Time printing new highs=7.5%" "Time deeper than −1%=45.4%" "309-day finish=1.85x|pos" >}}

Drawdown is the default state, not the exception. Even holding a strategy that goes
up, the screen is mostly red when you turn it on. Reading that as a sign something is
wrong means reading it wrong almost every time. So the default behaviour is to sit
still.

This seems to contradict what I wrote earlier, about not being able to wait the way I
wait on an index. Both are true. I do sit still, just not indefinitely — only as long
as the rules allow. If anything, without rules I'd sit still less. Not knowing how
long to wait means deciding every day, and deciding every day means quitting on the
worst one. With rules I don't have to look until that day arrives. A brake isn't for
the timid, it's what lets you sit through it.

So how sensitive should the rules be? There are two ways to be wrong: calling a
healthy strategy dead and stopping, or calling a dead one healthy and holding it.

The first can be counted. Lay the rules over the past curve and count how often they
fire. The strategy didn't die over that stretch, so every trigger is a false one. The
current rules fire −10% once in 309 days and −15% never. The old rules (−5/−10) went
all the way to flat, which is why they changed. The cost is the one already shown: the
single halving is the difference between 6.1× and 2.9×.

The second can't be counted. There's no sample of the strategy actually dying. There's
one live path and it hasn't died yet. So that side gets settled by disposition rather
than arithmetic — conservative where I can't measure.

That asymmetry is what ends up setting the numbers. A false alarm costs money I didn't
make. Missing the real one costs money I had.

## Closing

If you're setting up AI and a systematic strategy to trade on your own, there's one
question I'd ask. Am I the person who wants 1000% on the eighth try after seven
liquidations, or the one for whom 10–20% a year without drawdowns is enough? The
answer decides the strategy, the leverage, and what you hand to the AI.

Next I want to write about what I expect, and don't expect, from AI-run alpha research
on a systematic book.

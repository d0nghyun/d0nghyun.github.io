---
title: "[Live Performance] 2026-08"
date: 2026-09-01T22:00:00+09:00
categories: ["quant"]
tags: ["monthly"]
draft: false
cover:
  image: "/figures/2026-08-monthly/cumulative.png"
  alt: "Equity curve since going live, against BTC"
  relative: false
  hiddenInSingle: true
---

Second month on the record. Same book as last month — cross-sectional long/short on Binance
perpetuals. Size stays private; everything here is a ratio.

## Performance

{{< stats "Return, 31 days=+1.0%|pos" "Max drawdown=-15.6%|neg" "Annualised vol=36.0%" "t-stat=0.1|note:one-tailed p≈0.44" >}}

{{< figure src="/figures/2026-08-monthly/nav-index.png"
  caption="Equity curve indexed to 100 on Aug 1, against BTC. The grey band is the 41 hours the book sat flat; the lower panel is gross exposure as a multiple of equity." >}}

+1.0% over 31 days, 15.6% max drawdown. BTC was up 24.9% over the same period. The damage
came from one stretch of it — three days in which BTC rose 21%.

## What happened

Through August 9 it went well: +14.7% in ten days.

Then BTC rose 21% between the 18th and the 21st. That market is bad for a cross-sectional
long/short. The longs the signals pick sit in thinly traded names and the shorts sit in the
ones that move; when the whole market goes one way, the short leg breaks first and the long
leg cannot keep up. The index fell from 114.7 to 99. All of that was a known risk.

{{< figure src="/figures/2026-08-monthly/regime-coverage.png"
  caption="BTC daily returns over the 350 days inside the backtest window (left) and three-day cumulative returns (right). Red marks what arrived in August." >}}

In the 350 days the backtest saw, BTC rose more than 8% in a day exactly once. On a
three-day basis the largest run in that window was 11.8%; August delivered 21%. The
backtest had not told me this book was fine in such a market — it had never been asked the
question.

Last month I wrote that this book tends to fall slightly when BTC rises, with a beta of
-0.26. BTC moved 4.2% that month, so the property cost -1.3 points and was invisible. This
month the beta is -0.29, essentially unchanged, but BTC rose 24.9% — the same beta now costs
-7.1 points. With a 1.0% month, that means the rest of the book made +8.1 points; the same
calculation on July gives +11.8. Comparing two single months tells me nothing about whether
the signals themselves got worse.

A beta of -0.3 is a small short in BTC. I never chose it. It arrives through the names the
signals pick, and in July the market simply did not move enough for it to show up in the P&L.

There was an overlay meant to offset it, and it did not hold. The overlay shaved the exposure
from above rather than keeping it out of the selection, and the size was wrong. On the
morning of the 21st I closed the positions. The fix was not a few hours of work, and I
decided not to run the book while making it.

{{< figure src="/figures/2026-08-monthly/decomposition.png"
  caption="Return by segment. The hatched bar is what the 41 hours would have cost had the book stayed on." >}}

-0.9% up to the stop, +1.9% after the restart, zero in the 41 hours between. The month's P&L
sat almost entirely in two days. Holding through those 41 hours would have cost -10.2% and
ended the month at -9.3%. Not running for two days is what protected the other twenty-nine.

The 15.6% drawdown still stands. Stopping does not undo the fall from the August 9 high, and
the trough at 96.8 makes this a return to flat rather than a save.

{{< figure src="/figures/2026-08-monthly/beta.png"
  caption="Beta to BTC measured on hourly returns. Bars are 95% intervals; the post-restart window is only 208 hours, hence the width." >}}

Since the restart the beta is -0.12. On daily data there are only eight observations and the
standard error is 0.40, which says nothing; on 208 hourly observations it falls to 0.05. The
same method gives -0.24 for July and -0.18 for August before the stop — half by the July
reference, a third by the more recent one. The three intervals overlap, so how much it
actually came down is not something this sample can settle. And BTC has moved only 3.3% since
the restart, so the reduced beta has cost -0.4 points. The market that broke this book was
21% in three days, and it has not come back; whether the fix works is a question for then.

## The loop

Research still runs entirely through agents. 261 ideas were tested last month and 74 this
month, and deployments fell from 39 to 9. The pass rate went from 15% to 12%, roughly flat.

I ran fewer this month because the token budget went elsewhere. Running fewer is also what
made the diminishing returns obvious. Once the frame is built, the data is loaded and the
loop is turning, results accumulate on their own up to a point — past it, something only
comes out when I steer.

What seems to break the ceiling is new data, different trading frequencies, and areas and
markets I have not looked at. So in September I plan to collect derivatives and options data
and work with that.

## Next

Thirty-one days prove nothing.

Last month I wrote that a ladder cutting position size at 10% and 15% drawdowns had never
fired. This month it came close. But the thing that cut the position was me watching the
logs — had I been asleep, nobody would have cut it.

First job next month is putting the stop condition in code. After that: record what market a
book has never seen at the time it is deployed, and fix a unit error I found in the comparison
code. Live position size is a multiple of equity while the backtest side is a notional amount,
and the two were being divided as if they were the same thing. The comparison figures in last
month's post came out of that code.

## Cumulative

{{< figure src="/figures/2026-08-monthly/cumulative.png"
  caption="Equity curve indexed to 100 on July 9, the day the book went live, against BTC. The dashed line is the month boundary and the grey band is the 41 flat hours in August." >}}

Two months together: +13.7% over 54 days. The 15.6% max drawdown is entirely August's; July's
was 3.0%.

The 11.7% from last month covered July 9 through the 22nd. A further month added 2 points on
top of that, so anyone extrapolating the first month's pace would have been wrong — which is
the normal outcome.

Across both months the t-stat is 1.1. It was 1.7 last month, so it fell as the sample grew.
Still not distinguishable from luck.

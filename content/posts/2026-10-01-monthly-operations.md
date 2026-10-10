---
title: "[Live Performance] 2026-09"
date: 2026-10-10T11:07:30+09:00
categories: ["quant"]
tags: ["monthly"]
draft: false
cover:
  image: "/figures/2026-09-monthly/nav-index.png"
  alt: "September equity curve against BTC"
  relative: false
  hiddenInSingle: true
---

Third month on the record, and the last one on this account. Same strategy — cross-sectional
long/short on Binance perpetuals. Size stays private; everything here is a return or a ratio.

## Performance

{{< stats "Return, 30 days=-1.9%|neg" "Max drawdown=-9.4%|neg" "Annualised vol=30.0%" "t-stat=-0.2|note:one-tailed p≈0.58" >}}

{{< figure src="/figures/2026-09-monthly/nav-index.png"
  caption="Equity curve indexed to 100 on Sep 1, against BTC. Red dashed lines mark composition changes; grey bands are when the host was down and rebalancing stopped. The lower panel is gross exposure as a multiple of equity." >}}

-1.9% over 30 days, 9.4% max drawdown. BTC was up 6.3% over the same period. The index
peaked at 105.1 on the 4th, fell to 95.2 by the 22nd, and closed the month at 98.1.

## What happened

August's problem was an unintended BTC short (beta -0.29). This month the beta is +0.03, and the
correlation with BTC over 691 hourly returns is 0.04. The -1.9% is the alpha's result, not the
market's.

{{< figure src="/figures/2026-09-monthly/decomposition.png"
  caption="Return of each composition over its own window, with BTC over the same window. The two hours on the 22nd are the transition during the second swap." >}}

The book ran three compositions. The first lost 0.9% through the 7th, the second lost 3.1%
through the 21st, and the two-hour transition on the 22nd cost another 0.9%. The third is
+3.1% through the 30th.

On the 21st I re-scored all fourteen alphas on their last seven weeks. Five were positive and
nine negative, and most of the nine belonged to one group of similar alphas. The third
composition caps that group's total weight and gives the freed weight to the best alpha of the
seven weeks. Applied to the backtest from 2023, every variant of this change did worse than the
original composition. It is a bet that the recent regime continues, not a validated
improvement. The original composition keeps running as a paper portfolio.

The same review made the opposite call elsewhere. One alpha registered in July earned only in
the eleven months used to choose its direction and parameters; in the 411 days before that its
Sharpe was -1.2. From August 1 to September 26 it made +7.2%, but I discounted that as too short
and listed it as a retirement candidate. That is not the same standard I used to move weight on
seven weeks of performance. The paper comparison will show which call was right.

## Operations

From the 10th the host went down four times in three days, and three of those also cut the
equity record. The last time it rebooted and sat at the login screen for 16 hours, holding
positions with no orders. Those are the grey bands above.

The cause was the process that computes target positions every hour. To read one value it
recomputed 44 months of history from scratch, using up to 33 GB per run. Monitoring showed
1 GB; the cause only appeared once compressed memory was measured separately. After the fix it
runs at about 120 MB with bit-identical output. Nothing restarts unless someone logs in — the
same structure as in August.

## The research loop

Research tested 132 ideas this month and registered 10. July was 39 of 261 and August 9 of 74:
a pass rate of 15%, 12%, then 8%.

The loop changed shape. One agent acts as PM and picks the studies, a separate agent runs each
one, and another tries to refute the result. All four first-round studies failed because the
signal's sign flipped in mid-2025. The next round drew from the 591 rejections on file, picking
the ones marked "revisit if conditions change," and one study reached paper trading. Instead of
the options data I mentioned in August, I worked with spot data; most of it was rejected.

## Three months, then a reset

{{< figure src="/figures/2026-09-monthly/cumulative.png"
  caption="Equity curve indexed to 100 on July 9, the day the book went live, against BTC. Dashed lines are month boundaries; grey marks the 41 flat hours in August and the September host outages. Flow-adjusted time-weighted return." >}}

+10.4% over 83 days from July 9, against +33.5% for BTC. The max drawdown is 16.4%, from the
August 9 peak (128.1) to September 22 (107.1), deeper than the 15.6% in the August post. The
t-stat was 1.7 after one month, 1.1 after two, and 0.8 after three.

One correction. The August post put the two-month return at +13.7%, but chaining its own
monthly figures (July +11.7%, August +1.0%) gives +12.8%. The cumulative here re-chains hourly
returns from the start; the index at the end of August is 112.7.

This account closes with September. The composition changed more than ten times in three
months, and flattening and restarting in August left the performance baseline out of line with
the account balance. From October a new account starts, measured from a single starting point.
Next quarter's first task is making the system restart itself without a person.

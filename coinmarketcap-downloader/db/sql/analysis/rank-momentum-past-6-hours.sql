WITH

snap_6h_ago AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '6 hours' AND
    market_cap_usd > 1000000 AND
    volume_24h_usd > 500000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated ASC
),

snap_5h_ago AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '5 hours' AND
    market_cap_usd > 1000000 AND
    volume_24h_usd > 500000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated ASC
),

snap_4h_ago AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '4 hours' AND
    market_cap_usd > 1000000 AND
    volume_24h_usd > 500000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated ASC
),

snap_3h_ago AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '3 hours' AND
    market_cap_usd > 1000000 AND
    volume_24h_usd > 500000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated ASC
),

snap_2h_ago AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '2 hours' AND
    market_cap_usd > 1000000 AND
    volume_24h_usd > 500000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated ASC
),

snap_1h_ago AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '1 hours' AND
    market_cap_usd > 1000000 AND
    volume_24h_usd > 500000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated ASC
),

latest AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '30 minutes' AND
    market_cap_usd > 1000000 AND
    volume_24h_usd > 500000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated DESC
),

earliest AS (
  SELECT *
  FROM snap_6h_ago
),

final_analysis AS (
  SELECT
    latest.ticker,
    latest.symbol,
    latest.rank,
    latest.price_usd,
    latest.market_cap_usd,
    latest.volume_24h_usd,
    latest.last_updated  AT TIME ZONE 'America/New_York' AS last_updated,

    snap_6h_ago.price_usd AS snap_6h_ago_price_usd,
    snap_5h_ago.price_usd AS snap_5h_ago_price_usd,
    snap_4h_ago.price_usd AS snap_4h_ago_price_usd,
    snap_3h_ago.price_usd AS snap_3h_ago_price_usd,
    snap_2h_ago.price_usd AS snap_2h_ago_price_usd,
    snap_1h_ago.price_usd AS snap_1h_ago_price_usd,
    latest.price_usd AS latest_price_usd,

    snap_5h_ago.price_usd - snap_6h_ago.price_usd AS time_6h_5h_price_diff,
    snap_4h_ago.price_usd - snap_5h_ago.price_usd AS time_5h_4h_price_diff,
    snap_3h_ago.price_usd - snap_4h_ago.price_usd AS time_4h_3h_price_diff,
    snap_2h_ago.price_usd - snap_3h_ago.price_usd AS time_3h_2h_price_diff,
    snap_1h_ago.price_usd - snap_2h_ago.price_usd AS time_2h_1h_price_diff,
    latest.price_usd - snap_1h_ago.price_usd AS time_1h_0h_price_diff,

    ROUND(((snap_5h_ago.price_usd - snap_6h_ago.price_usd)/snap_6h_ago.price_usd) * 100, 2) AS time_6h_5h_price_percent_diff,
    ROUND(((snap_4h_ago.price_usd - snap_5h_ago.price_usd)/snap_5h_ago.price_usd) * 100, 2) AS time_5h_4h_price_percent_diff,
    ROUND(((snap_3h_ago.price_usd - snap_4h_ago.price_usd)/snap_4h_ago.price_usd) * 100, 2) AS time_4h_3h_price_percent_diff,
    ROUND(((snap_2h_ago.price_usd - snap_3h_ago.price_usd)/snap_3h_ago.price_usd) * 100, 2) AS time_3h_2h_price_percent_diff,
    ROUND(((snap_1h_ago.price_usd - snap_2h_ago.price_usd)/snap_2h_ago.price_usd) * 100, 2) AS time_2h_1h_price_percent_diff,
    ROUND(((latest.price_usd - snap_1h_ago.price_usd)/snap_1h_ago.price_usd) * 100, 2) AS time_1h_0h_price_percent_diff,

    snap_6h_ago.rank AS snap_6h_ago_rank,
    snap_5h_ago.rank AS snap_5h_ago_rank,
    snap_4h_ago.rank AS snap_4h_ago_rank,
    snap_3h_ago.rank AS snap_3h_ago_rank,
    snap_2h_ago.rank AS snap_2h_ago_rank,
    snap_1h_ago.rank AS snap_1h_ago_rank,
    latest.rank AS latest_rank,

    -1 * (snap_5h_ago.rank - snap_6h_ago.rank) AS time_6h_5h_rank_diff,
    -1 * (snap_4h_ago.rank - snap_5h_ago.rank) AS time_5h_4h_rank_diff,
    -1 * (snap_3h_ago.rank - snap_4h_ago.rank) AS time_4h_3h_rank_diff,
    -1 * (snap_2h_ago.rank - snap_3h_ago.rank) AS time_3h_2h_rank_diff,
    -1 * (snap_1h_ago.rank - snap_2h_ago.rank) AS time_2h_1h_rank_diff,
    -1 * (latest.rank - snap_1h_ago.rank) AS time_1h_0h_rank_diff,

    ROUND(((latest.price_usd - snap_6h_ago.price_usd)/snap_6h_ago.price_usd) * 100, 2) AS overall_price_percent_diff,
    -1 * (latest.rank - snap_6h_ago.rank) AS overall_rank_diff

  FROM latest
  INNER JOIN snap_6h_ago USING (ticker, symbol)
  INNER JOIN snap_5h_ago USING (ticker, symbol)
  INNER JOIN snap_4h_ago USING (ticker, symbol)
  INNER JOIN snap_3h_ago USING (ticker, symbol)
  INNER JOIN snap_2h_ago USING (ticker, symbol)
  INNER JOIN snap_1h_ago USING (ticker, symbol)
)

SELECT
  final_analysis.*
FROM final_analysis
WHERE
  time_1h_0h_rank_diff > 0
ORDER BY overall_rank_diff DESC

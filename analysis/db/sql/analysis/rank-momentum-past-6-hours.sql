WITH

time_6h_ago AS (
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

time_5h_ago AS (
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

time_4h_ago AS (
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

time_3h_ago AS (
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

time_2h_ago AS (
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

time_1h_ago AS (
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
  FROM time_6h_ago
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

    time_6h_ago.volume_24h_usd AS time_6h_ago_volume_24h_usd,
    time_5h_ago.volume_24h_usd AS time_5h_ago_volume_24h_usd,
    time_4h_ago.volume_24h_usd AS time_4h_ago_volume_24h_usd,
    time_3h_ago.volume_24h_usd AS time_3h_ago_volume_24h_usd,
    time_2h_ago.volume_24h_usd AS time_2h_ago_volume_24h_usd,
    time_1h_ago.volume_24h_usd AS time_1h_ago_volume_24h_usd,
    latest.volume_24h_usd AS latest_volume_24h_usd,

    time_5h_ago.volume_24h_usd - time_6h_ago.volume_24h_usd AS time_6h_5h_volume_diff,
    time_4h_ago.volume_24h_usd - time_5h_ago.volume_24h_usd AS time_5h_4h_volume_diff,
    time_3h_ago.volume_24h_usd - time_4h_ago.volume_24h_usd AS time_4h_3h_volume_diff,
    time_2h_ago.volume_24h_usd - time_3h_ago.volume_24h_usd AS time_3h_2h_volume_diff,
    time_1h_ago.volume_24h_usd - time_2h_ago.volume_24h_usd AS time_2h_1h_volume_diff,
    latest.volume_24h_usd - time_1h_ago.volume_24h_usd AS time_1h_0h_volume_diff,

    ROUND(((time_5h_ago.volume_24h_usd - time_6h_ago.volume_24h_usd)/time_6h_ago.volume_24h_usd) * 100, 2) AS time_6h_5h_volume_percent_diff,
    ROUND(((time_4h_ago.volume_24h_usd - time_5h_ago.volume_24h_usd)/time_5h_ago.volume_24h_usd) * 100, 2) AS time_5h_4h_volume_percent_diff,
    ROUND(((time_3h_ago.volume_24h_usd - time_4h_ago.volume_24h_usd)/time_4h_ago.volume_24h_usd) * 100, 2) AS time_4h_3h_volume_percent_diff,
    ROUND(((time_2h_ago.volume_24h_usd - time_3h_ago.volume_24h_usd)/time_3h_ago.volume_24h_usd) * 100, 2) AS time_3h_2h_volume_percent_diff,
    ROUND(((time_1h_ago.volume_24h_usd - time_2h_ago.volume_24h_usd)/time_2h_ago.volume_24h_usd) * 100, 2) AS time_2h_1h_volume_percent_diff,
    ROUND(((latest.volume_24h_usd - time_1h_ago.volume_24h_usd)/time_1h_ago.volume_24h_usd) * 100, 2) AS time_1h_0h_volume_percent_diff,


    time_6h_ago.price_usd AS time_6h_ago_price_usd,
    time_5h_ago.price_usd AS time_5h_ago_price_usd,
    time_4h_ago.price_usd AS time_4h_ago_price_usd,
    time_3h_ago.price_usd AS time_3h_ago_price_usd,
    time_2h_ago.price_usd AS time_2h_ago_price_usd,
    time_1h_ago.price_usd AS time_1h_ago_price_usd,
    latest.price_usd AS latest_price_usd,

    time_5h_ago.price_usd - time_6h_ago.price_usd AS time_6h_5h_price_diff,
    time_4h_ago.price_usd - time_5h_ago.price_usd AS time_5h_4h_price_diff,
    time_3h_ago.price_usd - time_4h_ago.price_usd AS time_4h_3h_price_diff,
    time_2h_ago.price_usd - time_3h_ago.price_usd AS time_3h_2h_price_diff,
    time_1h_ago.price_usd - time_2h_ago.price_usd AS time_2h_1h_price_diff,
    latest.price_usd - time_1h_ago.price_usd AS time_1h_0h_price_diff,

    ROUND(((time_5h_ago.price_usd - time_6h_ago.price_usd)/time_6h_ago.price_usd) * 100, 2) AS time_6h_5h_price_percent_diff,
    ROUND(((time_4h_ago.price_usd - time_5h_ago.price_usd)/time_5h_ago.price_usd) * 100, 2) AS time_5h_4h_price_percent_diff,
    ROUND(((time_3h_ago.price_usd - time_4h_ago.price_usd)/time_4h_ago.price_usd) * 100, 2) AS time_4h_3h_price_percent_diff,
    ROUND(((time_2h_ago.price_usd - time_3h_ago.price_usd)/time_3h_ago.price_usd) * 100, 2) AS time_3h_2h_price_percent_diff,
    ROUND(((time_1h_ago.price_usd - time_2h_ago.price_usd)/time_2h_ago.price_usd) * 100, 2) AS time_2h_1h_price_percent_diff,
    ROUND(((latest.price_usd - time_1h_ago.price_usd)/time_1h_ago.price_usd) * 100, 2) AS time_1h_0h_price_percent_diff,

    time_6h_ago.rank AS time_6h_ago_rank,
    time_5h_ago.rank AS time_5h_ago_rank,
    time_4h_ago.rank AS time_4h_ago_rank,
    time_3h_ago.rank AS time_3h_ago_rank,
    time_2h_ago.rank AS time_2h_ago_rank,
    time_1h_ago.rank AS time_1h_ago_rank,
    latest.rank AS latest_rank,

    -1 * (time_5h_ago.rank - time_6h_ago.rank) AS time_6h_5h_rank_diff,
    -1 * (time_4h_ago.rank - time_5h_ago.rank) AS time_5h_4h_rank_diff,
    -1 * (time_3h_ago.rank - time_4h_ago.rank) AS time_4h_3h_rank_diff,
    -1 * (time_2h_ago.rank - time_3h_ago.rank) AS time_3h_2h_rank_diff,
    -1 * (time_1h_ago.rank - time_2h_ago.rank) AS time_2h_1h_rank_diff,
    -1 * (latest.rank - time_1h_ago.rank) AS time_1h_0h_rank_diff,

    ROUND(((latest.volume_24h_usd - time_6h_ago.volume_24h_usd)/time_6h_ago.volume_24h_usd) * 100, 2) AS overall_volume_percent_diff,
    ROUND(((latest.price_usd - time_6h_ago.price_usd)/time_6h_ago.price_usd) * 100, 2) AS overall_price_percent_diff,
    -1 * (latest.rank - time_6h_ago.rank) AS overall_rank_diff

  FROM latest
  INNER JOIN time_6h_ago USING (ticker, symbol)
  INNER JOIN time_5h_ago USING (ticker, symbol)
  INNER JOIN time_4h_ago USING (ticker, symbol)
  INNER JOIN time_3h_ago USING (ticker, symbol)
  INNER JOIN time_2h_ago USING (ticker, symbol)
  INNER JOIN time_1h_ago USING (ticker, symbol)
)

SELECT
  final_analysis.*
FROM final_analysis
ORDER BY overall_rank_diff DESC

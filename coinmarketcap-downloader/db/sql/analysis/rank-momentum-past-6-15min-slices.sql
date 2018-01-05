WITH

slice_6 AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '90 min' AND
    market_cap_usd > 1000000 AND
    volume_24h_usd > 500000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated ASC
),

slice_5 AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '75 min' AND
    market_cap_usd > 1000000 AND
    volume_24h_usd > 500000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated ASC
),

slice_4 AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '60 min' AND
    market_cap_usd > 1000000 AND
    volume_24h_usd > 500000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated ASC
),

slice_3 AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '45 min' AND
    market_cap_usd > 1000000 AND
    volume_24h_usd > 500000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated ASC
),

slice_2 AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '30 min' AND
    market_cap_usd > 1000000 AND
    volume_24h_usd > 500000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated ASC
),

slice_1 AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '15 min' AND
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
  FROM slice_6
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

    slice_6.volume_24h_usd AS slice_6_volume_24h_usd,
    slice_5.volume_24h_usd AS slice_5_volume_24h_usd,
    slice_4.volume_24h_usd AS slice_4_volume_24h_usd,
    slice_3.volume_24h_usd AS slice_3_volume_24h_usd,
    slice_2.volume_24h_usd AS slice_2_volume_24h_usd,
    slice_1.volume_24h_usd AS slice_1_volume_24h_usd,
    latest.volume_24h_usd AS latest_volume_24h_usd,

    slice_5.volume_24h_usd - slice_6.volume_24h_usd AS slice_6_5_volume_diff,
    slice_4.volume_24h_usd - slice_5.volume_24h_usd AS slice_5_4_volume_diff,
    slice_3.volume_24h_usd - slice_4.volume_24h_usd AS slice_4_3_volume_diff,
    slice_2.volume_24h_usd - slice_3.volume_24h_usd AS slice_3_2_volume_diff,
    slice_1.volume_24h_usd - slice_2.volume_24h_usd AS slice_2_1_volume_diff,
    latest.volume_24h_usd - slice_1.volume_24h_usd AS slice_1_0_volume_diff,

    ROUND(((slice_5.volume_24h_usd - slice_6.volume_24h_usd)/slice_6.volume_24h_usd) * 100, 2) AS slice_6_5_volume_percent_diff,
    ROUND(((slice_4.volume_24h_usd - slice_5.volume_24h_usd)/slice_5.volume_24h_usd) * 100, 2) AS slice_5_4_volume_percent_diff,
    ROUND(((slice_3.volume_24h_usd - slice_4.volume_24h_usd)/slice_4.volume_24h_usd) * 100, 2) AS slice_4_3_volume_percent_diff,
    ROUND(((slice_2.volume_24h_usd - slice_3.volume_24h_usd)/slice_3.volume_24h_usd) * 100, 2) AS slice_3_2_volume_percent_diff,
    ROUND(((slice_1.volume_24h_usd - slice_2.volume_24h_usd)/slice_2.volume_24h_usd) * 100, 2) AS slice_2_1_volume_percent_diff,
    ROUND(((latest.volume_24h_usd - slice_1.volume_24h_usd)/slice_1.volume_24h_usd) * 100, 2) AS slice_1_0_volume_percent_diff,


    slice_6.price_usd AS slice_6_price_usd,
    slice_5.price_usd AS slice_5_price_usd,
    slice_4.price_usd AS slice_4_price_usd,
    slice_3.price_usd AS slice_3_price_usd,
    slice_2.price_usd AS slice_2_price_usd,
    slice_1.price_usd AS slice_1_price_usd,
    latest.price_usd AS latest_price_usd,

    slice_5.price_usd - slice_6.price_usd AS slice_6_5_price_diff,
    slice_4.price_usd - slice_5.price_usd AS slice_5_4_price_diff,
    slice_3.price_usd - slice_4.price_usd AS slice_4_3_price_diff,
    slice_2.price_usd - slice_3.price_usd AS slice_3_2_price_diff,
    slice_1.price_usd - slice_2.price_usd AS slice_2_1_price_diff,
    latest.price_usd - slice_1.price_usd AS slice_1_0_price_diff,

    ROUND(((slice_5.price_usd - slice_6.price_usd)/slice_6.price_usd) * 100, 2) AS slice_6_5_price_percent_diff,
    ROUND(((slice_4.price_usd - slice_5.price_usd)/slice_5.price_usd) * 100, 2) AS slice_5_4_price_percent_diff,
    ROUND(((slice_3.price_usd - slice_4.price_usd)/slice_4.price_usd) * 100, 2) AS slice_4_3_price_percent_diff,
    ROUND(((slice_2.price_usd - slice_3.price_usd)/slice_3.price_usd) * 100, 2) AS slice_3_2_price_percent_diff,
    ROUND(((slice_1.price_usd - slice_2.price_usd)/slice_2.price_usd) * 100, 2) AS slice_2_1_price_percent_diff,
    ROUND(((latest.price_usd - slice_1.price_usd)/slice_1.price_usd) * 100, 2) AS slice_1_0_price_percent_diff,

    slice_6.rank AS slice_6_rank,
    slice_5.rank AS slice_5_rank,
    slice_4.rank AS slice_4_rank,
    slice_3.rank AS slice_3_rank,
    slice_2.rank AS slice_2_rank,
    slice_1.rank AS slice_1_rank,
    latest.rank AS latest_rank,

    -1 * (slice_5.rank - slice_6.rank) AS slice_6_5_rank_diff,
    -1 * (slice_4.rank - slice_5.rank) AS slice_5_4_rank_diff,
    -1 * (slice_3.rank - slice_4.rank) AS slice_4_3_rank_diff,
    -1 * (slice_2.rank - slice_3.rank) AS slice_3_2_rank_diff,
    -1 * (slice_1.rank - slice_2.rank) AS slice_2_1_rank_diff,
    -1 * (latest.rank - slice_1.rank) AS slice_1_0_rank_diff,

    ROUND(((latest.volume_24h_usd - slice_6.volume_24h_usd)/slice_6.volume_24h_usd) * 100, 2) AS overall_volume_percent_diff,
    ROUND(((latest.price_usd - slice_6.price_usd)/slice_6.price_usd) * 100, 2) AS overall_price_percent_diff,
    -1 * (latest.rank - slice_6.rank) AS overall_rank_diff

  FROM latest
  INNER JOIN slice_6 USING (ticker, symbol)
  INNER JOIN slice_5 USING (ticker, symbol)
  INNER JOIN slice_4 USING (ticker, symbol)
  INNER JOIN slice_3 USING (ticker, symbol)
  INNER JOIN slice_2 USING (ticker, symbol)
  INNER JOIN slice_1 USING (ticker, symbol)
)

SELECT
  final_analysis.*
FROM final_analysis
ORDER BY overall_rank_diff DESC

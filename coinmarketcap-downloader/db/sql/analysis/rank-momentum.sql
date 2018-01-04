WITH

earliest AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '1 day' AND
    market_cap_usd > 1000000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated ASC
),

latest AS (
  SELECT DISTINCT ON (ticker, symbol) *
  FROM cmc_market_data
  WHERE
    last_updated > now() - interval '1 day' AND
    market_cap_usd > 1000000 AND
    price_usd IS NOT NULL AND
    market_cap_usd IS NOT NULL
  ORDER BY ticker, symbol, last_updated DESC
),

final_analysis AS (
  SELECT
    latest.*,
    earliest.rank AS earliest_rank,
    latest.rank AS latest_rank,
    earliest.price_usd AS earliest_price_usd,
    latest.price_usd AS latest_price_usd,
    (latest.price_usd - earliest.price_usd) AS price_diff,
    ROUND(((latest.price_usd - earliest.price_usd)/earliest.price_usd) * 100, 2) AS price_percent_diff,
    (latest.rank - earliest.rank) * -1 AS rank_diff
  FROM earliest
  INNER JOIN latest USING (ticker, symbol)
)

SELECT
  final_analysis.ticker,
  final_analysis.symbol,
  final_analysis.rank,
  final_analysis.price_usd,
  final_analysis.market_cap_usd,
  final_analysis.volume_24h_usd,
  final_analysis.last_updated  AT TIME ZONE 'America/New_York' AS last_updated,
  final_analysis.earliest_rank,
  final_analysis.latest_rank,
  final_analysis.earliest_price_usd,
  final_analysis.latest_price_usd,
  final_analysis.price_diff,
  final_analysis.price_percent_diff,
  final_analysis.rank_diff
FROM final_analysis
WHERE volume_24h_usd > 500000
ORDER BY rank_diff DESC

WITH latest AS (
  SELECT DISTINCT ON(ticker, symbol) *
  FROM cmc_market_data
  WHERE last_updated > now() - interval '10 minutes'
  ORDER BY
    ticker,
    symbol,
    last_updated DESC
),

orders_with_latest AS (
  SELECT
    orders.strategy,
    orders.ticker,
    orders.symbol,
    orders.price_usd,
    latest.price_usd AS latest_price_usd,
    latest.price_usd - orders.price_usd AS price_diff
  FROM orders
  LEFT JOIN latest USING (ticker,symbol)
  ORDER BY
    strategy
),

strategy_review AS (
  SELECT
    strategy,
    ((SUM(latest_price_usd)/SUM(price_usd)) - 1) * 100 AS percent_gains
  FROM orders_with_latest
  GROUP BY strategy
)

SELECT *
FROM strategy_review

WITH
filtered AS (
  SELECT * FROM cmc_market_data WHERE ticker NOT IN (
    SELECT ticker
    FROM cmc_market_data
    WHERE
      last_updated > now() - interval '3 hours' AND
      (
      market_cap_usd < 1000000 OR
      price_usd IS NULL OR
      market_cap_usd IS NULL)
  )
  ORDER BY last_updated DESC
),

last_3 AS (
  SELECT *
  FROM (
    SELECT
      4 - ROW_NUMBER() OVER (
        PARTITION BY ticker
        ORDER BY ticker ASC, last_updated DESC
      ) AS row_num,
      filtered.*
    FROM filtered
  ) numbered
  WHERE
    numbered.row_num <= 3 AND
    numbered.row_num > 0
  ORDER BY ticker, row_num DESC
),

last_5 AS (
  SELECT *
  FROM (
    SELECT
      6 - ROW_NUMBER() OVER (
        PARTITION BY ticker
        ORDER BY ticker ASC, last_updated DESC
      ) AS row_num,
      filtered.*
    FROM filtered
  ) numbered
  WHERE
    numbered.row_num <= 5 AND
    numbered.row_num > 0
  ORDER BY ticker, row_num DESC
),

last_10 AS (
  SELECT *
  FROM (
    SELECT
      11 - ROW_NUMBER() OVER (
        PARTITION BY ticker
        ORDER BY ticker ASC, last_updated DESC
      ) AS row_num,
      filtered.*
    FROM filtered
  ) numbered
  WHERE
    numbered.row_num <= 10 AND
    numbered.row_num > 0
  ORDER BY ticker, row_num DESC
),

percent_change_3 AS (
  SELECT
    row_num,
    ticker,
    last_updated,
    price_usd,
    market_cap_usd,
    (price_usd - lead(price_usd) OVER (PARTITION BY ticker ORDER BY row_num DESC)) / lead(price_usd) OVER (PARTITION BY ticker ORDER BY row_num DESC) * 100 as percent_change
  FROM last_3
),

percent_change_5 AS (
  SELECT
    row_num,
    ticker,
    last_updated,
    price_usd,
    market_cap_usd,
    (price_usd - lead(price_usd) OVER (PARTITION BY ticker ORDER BY row_num DESC)) / lead(price_usd) OVER (PARTITION BY ticker ORDER BY row_num DESC) * 100 as percent_change
  FROM last_5
),

percent_change_10 AS (
  SELECT
    row_num,
    ticker,
    last_updated,
    price_usd,
    market_cap_usd,
    (price_usd - lead(price_usd) OVER (PARTITION BY ticker ORDER BY row_num DESC)) / lead(price_usd) OVER (PARTITION BY ticker ORDER BY row_num DESC) * 100 as percent_change
  FROM last_10
),

percent_change_3_counts AS (
  SELECT ticker, COUNT(*) AS cnt
  FROM percent_change_3
  WHERE
    percent_change_3.percent_change > 0 AND
    percent_change_3.percent_change <= 50
  GROUP BY ticker
  ORDER BY cnt DESC
),

percent_change_5_counts AS (
  SELECT ticker, COUNT(*) AS cnt
  FROM percent_change_5
  WHERE
    percent_change_5.percent_change >= 5 AND
    percent_change_5.percent_change <= 50
  GROUP BY ticker
  ORDER BY cnt DESC
),

percent_change_10_counts AS (
  SELECT ticker, COUNT(*) AS cnt
  FROM percent_change_10
  WHERE
    percent_change_10.percent_change >= 10 AND
    percent_change_10.percent_change <= 50
  GROUP BY ticker
  ORDER BY cnt DESC
),

final_analysis AS (
  SELECT
    percent_change_10_counts.ticker,
    percent_change_10_counts.cnt AS cnt_10,
    percent_change_5_counts.cnt AS cnt_5,
    percent_change_3_counts.cnt AS cnt_3
  FROM percent_change_10_counts
  LEFT JOIN percent_change_3_counts USING (ticker)
  LEFT JOIN percent_change_5_counts USING (ticker)
)

SELECT
  f.ticker,
  f.rank,
  f.price_usd,
  f.market_cap_usd,
  f.volume_24h_usd,
  f.last_updated  AT TIME ZONE 'America/New_York' AS last_updated
FROM final_analysis
INNER JOIN (
  SELECT DISTINCT ON (ticker) *
  FROM filtered
  ORDER BY ticker, last_updated DESC
) f USING(ticker)
WHERE
  cnt_10 >= 3 AND
  cnt_5 >= 1 AND
  cnt_3 >= 1

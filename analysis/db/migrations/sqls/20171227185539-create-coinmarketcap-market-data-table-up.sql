CREATE TABLE cmc_market_data (
  id BIGSERIAL PRIMARY KEY,
  ticker TEXT NOT NULL,
  name TEXT NOT NULL,
  symbol TEXT NOT NULL,
  rank INTEGER NOT NULL,
  price_usd NUMERIC NOT NULL,
  price_btc NUMERIC NOT NULL,
  volume_24h_usd NUMERIC,
  market_cap_usd NUMERIC,
  available_supply NUMERIC,
  total_supply NUMERIC,
  max_supply NUMERIC,
  percent_change_1h NUMERIC,
  percent_change_24h NUMERIC,
  percent_change_7d NUMERIC,
  last_updated TIMESTAMPTZ NOT NULL
);

CREATE UNIQUE INDEX cmc_market_data_unique_ticker_last_updated_idx ON cmc_market_data(ticker, last_updated);

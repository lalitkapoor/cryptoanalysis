CREATE TABLE orders (
  id BIGSERIAL PRIMARY KEY,
  strategy TEXT,
  ticker TEXT NOT NULL,
  symbol TEXT NOT NULL,
  price_usd NUMERIC NOT NULL,
  shares NUMERIC NOT NULL,
  buy_at TIMESTAMPTZ DEFAULT now(),
  sell_at TIMESTAMPTZ
);

CREATE INDEX orders_strategy ON orders(strategy);
CREATE INDEX orders_ticker ON orders(ticker);
CREATE INDEX orders_symbol ON orders(symbol);
CREATE INDEX orders_price_usd ON orders(price_usd);
CREATE INDEX orders_shares ON orders(shares);
CREATE INDEX orders_buy_at ON orders(buy_at);
CREATE INDEX orders_sell_at ON orders(sell_at);
